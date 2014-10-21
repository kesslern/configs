/**
 * \file
 * \author Guillaume Papin <guillaume.papin@epitech.eu>
 *
 * \brief See TUManager.hh
 *
 * This file is distributed under the GNU General Public License. See
 * COPYING for details.
 *
 */

#include "TUManager.h"

#include <iostream>

typedef TUManager::SettingsID SettingsID;
typedef TUManager::Settings Settings;

Settings::Settings() : parseTUOptions(0) {
}

void Settings::merge(const Settings &other) {
  parseTUOptions |= other.parseTUOptions;
}

bool Settings::equals(const Settings &other) const {
  return parseTUOptions == other.parseTUOptions;
}

TUManager::TUManager()
  : index_(clang_createIndex(0, 0))
  , translationUnits_()
  , effectiveSettings_()
  , settingsList_() {
  effectiveSettings_ = computeEffectiveSettings();
}

TUManager::~TUManager() {
  clang_disposeIndex(index_);
}

CXTranslationUnit &TUManager::tuRef(const std::string &filename,
                                    const std::vector<std::string> &flags) {
  CXTranslationUnit &tu = translationUnits_[filename];

  // if the flags changed since the last time, invalidate the translation unit
  auto &flagsCache = flagsPerFileCache_[filename];
  if (flagsCache.size() != flags.size() ||
      !std::equal(flagsCache.begin(), flagsCache.end(), flags.begin())) {
    if (tu) {
      clang_disposeTranslationUnit(tu);
      tu = nullptr;
    }
    // remember the flags for the next parse
    flagsCache = flags;
  }
  return tu;
}

CXTranslationUnit
TUManager::parse(const std::string &filename,
                 const std::vector<std::string> &flags,
                 const std::vector<CXUnsavedFile> &unsavedFiles) {
  CXTranslationUnit &tu = tuRef(filename, flags);

  if (tu == nullptr) {
    std::vector<const char *> argv;

#ifdef CLANG_BUILTIN_HEADERS_DIR
    // Make sure libclang find its builtin headers, this is a known issue with
    // libclang, see:
    // - http://lists.cs.uiuc.edu/pipermail/cfe-dev/2012-July/022893.html
    //
    // > Make sure that Clang is using its own . It will be in a directory
    // > ending in clang/3.2/include/ where 3.2 is the version of clang that you
    // > are using. You may need to explicitly add it to your header search.
    // > Usually clang finds this directory relative to the executable with
    // > CompilerInvocation::GetResourcesPath(Argv0, MainAddr), but using just
    // > the libraries, it can't automatically find it.
    argv.push_back("-isystem");
    argv.push_back(CLANG_BUILTIN_HEADERS_DIR);
#endif

    for (auto &flag : flags) {
      argv.push_back(flag.c_str());
    }

    tu = clang_parseTranslationUnit(
        index_,
        filename.c_str(),
        argv.data(),
        static_cast<int>(argv.size()),
        const_cast<CXUnsavedFile *>(unsavedFiles.data()),
        unsavedFiles.size(),
        effectiveSettings_.parseTUOptions);
  }

  if (tu == nullptr) {
    std::clog << "error: libclang couldn't parse '" << filename << "'\n";
    return 0;
  }

  // Reparsing is necessary to enable optimizations.
  //
  // From the clang mailing list (cfe-dev):
  // From: Douglas Gregor
  // Subject: Re: Clang indexing library performance
  // ...
  // You want to use the "default editing options" when parsing the translation
  // unit
  //    clang_defaultEditingTranslationUnitOptions()
  // and then reparse at least once. That will enable the various
  // code-completion optimizations that should bring this time down
  // significantly.
  if (clang_reparseTranslationUnit(
          tu,
          unsavedFiles.size(),
          const_cast<CXUnsavedFile *>(unsavedFiles.data()),
          clang_defaultReparseOptions(tu))) {
    // a 'fatal' error occured (even a diagnostic is impossible)
    clang_disposeTranslationUnit(tu);
    std::clog << "error: libclang couldn't reparse '" << filename << "'\n";
    tu = 0;
    return 0;
  }

  return tu;
}

CXTranslationUnit
TUManager::getOrCreateTU(const std::string &filename,
                         const std::vector<std::string> &flags,
                         const std::vector<CXUnsavedFile> &unsavedFiles) {
  if (auto tu = tuRef(filename, flags))
    return tu;

  return parse(filename, flags, unsavedFiles);
}

SettingsID TUManager::registerSettings(const Settings &settings) {
  SettingsID settingsID = settingsList_.insert(settingsList_.end(), settings);

  onSettingsChanged();
  return settingsID;
}

void TUManager::unregisterSettings(SettingsID settingsID) {
  onSettingsChanged();
  settingsList_.erase(settingsID);
}

void TUManager::onSettingsChanged() {
  const Settings &newSettings = computeEffectiveSettings();

  if (newSettings.equals(effectiveSettings_))
    return;

  effectiveSettings_ = newSettings;
  invalidateAllCachedTUs();
}

Settings TUManager::computeEffectiveSettings() const {
  Settings settings;

  settings.parseTUOptions = clang_defaultEditingTranslationUnitOptions();

  // this seems necessary to trigger "correct" reparse (/codeCompleteAt)
  // clang_reparseTranslationUnit documentation states:
  //
  // >  * \param TU The translation unit whose contents will be re-parsed. The
  // >  * translation unit must originally have been built with
  // >  * \c clang_createTranslationUnitFromSourceFile().
  //
  // clang_createTranslationUnitFromSourceFile() is just a call to
  // clang_parseTranslationUnit() with
  // CXTranslationUnit_DetailedPreprocessingRecord enabled but because we
  // want some other flags to be set we can't just call
  // clang_createTranslationUnitFromSourceFile()
  settings.parseTUOptions |= CXTranslationUnit_DetailedPreprocessingRecord;

  for (std::list<Settings>::const_iterator it = settingsList_.begin(),
                                           end = settingsList_.end();
       it != end;
       ++it) {
    settings.merge(*it);
  }

#if !defined(CINDEX_VERSION_MAJOR) || !defined(CINDEX_VERSION_MINOR) ||        \
    (CINDEX_VERSION_MAJOR == 0 && CINDEX_VERSION_MINOR < 6)
  // XXX: A bug in old version of Clang (at least '3.1-8') caused the completion
  //      to fail on the standard library types when
  //      CXTranslationUnit_PrecompiledPreamble is used. We disable this option
  //      for old versions of libclang. As a result the completion will work but
  //      significantly slower.
  // -- https://github.com/Sarcasm/irony-mode/issues/4
  settings.parseTUOptions &= ~CXTranslationUnit_PrecompiledPreamble;
#endif

  // Completion results caching doesn't seem to work right, changes at the top
  // of the file (i.e: new declarations) aren't detected and do not appear in
  // completion results.
  settings.parseTUOptions &= ~CXTranslationUnit_CacheCompletionResults;

  return settings;
}

void TUManager::invalidateCachedTU(const std::string &filename) {
  TranslationUnitsMap::iterator it = translationUnits_.find(filename);

  if (it != translationUnits_.end()) {
    if (CXTranslationUnit &tu = it->second)
      clang_disposeTranslationUnit(tu);

    translationUnits_.erase(it);
  }
}

void TUManager::invalidateAllCachedTUs() {
  TranslationUnitsMap::iterator it = translationUnits_.begin();

  while (it != translationUnits_.end()) {
    if (CXTranslationUnit &tu = it->second) {
      clang_disposeTranslationUnit(tu);
      translationUnits_.erase(it++); // post-increment keeps the iterator valid
    } else {
      ++it;
    }
  }
}

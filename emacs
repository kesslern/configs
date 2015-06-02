;;; .emacs -- kesslern

;;; Commentary:
;;; GNU/emacs config file

;;; Code:

;;; Kill current buffer immediately with C-x C-k.
;;; C-x k still prompts for which buffer to kill.
(global-set-key (kbd "C-x C-k") 'kill-this-buffer)

;;; Better buffer switching with C-x C-b
;;; (this is built in)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;; Set RET to newline-and-indent so the a newly created line
;;; is automatically indented without pressing tab.
(define-key global-map (kbd "RET") 'newline-and-indent)

;;; hs-minor-mode in C editing. Allows hiding/showing blocks of code.
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'objc-mode-hook 'hs-minor-mode)

;;; Disable menu bar at top of screen
(menu-bar-mode -1)

;;; This installs and initializes the MELPA package manager.
;;; Allows us to automatically install needed packages below
;;; using use-package package.
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(require 'use-package)

;;; On the fly syntax checking with flycheck.
(use-package flycheck
	:ensure flycheck)
;;; Uncomment to enable flycheck mode by default.
;(global-flycheck-mode 1)

;;; Find files in svn/git repo
(use-package find-file-in-repository
	:ensure find-file-in-repository)
;;; Will default to normal find-file if not in a repo
;;; Normal find-file with C-x f everywhere
(global-set-key (kbd "C-x C-f") 'find-file-in-repository)
(global-set-key (kbd "C-x f") 'find-file)

;;; Should look into more helm extensions
(use-package helm
	:ensure helm)
(use-package helm-company
	:ensure helm-company)

;;; Start Helm globally. Better menus, must have.
(helm-mode 1)

;;; Install flyspell but don't enable it by default
;;; Enable for spell checking
(use-package flyspell 
	:ensure flyspell)

;;; Complete anywhere
(use-package company
	:ensure company)
(global-company-mode)
;;; Delay of 0.5s before completion menu appears
(set 'company-idle-delay 0.5)

;;; IDO mode, better buffer switching. Use vertical mode too.
;;; Helm replaces most of the places where ido-mode would
;;; normally be used, but not all, so we still use it.
(use-package ido-vertical-mode
	:ensure ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)

;;; Install color themes from MELPA
;;; requires package cl
(use-package cl
  :ensure cl)
(use-package color-theme
  :ensure color-theme)
(color-theme-initialize)
;;; midnight color theme
;;; billw is another good one
(color-theme-midnight)

;;; Install magit, git integration
(use-package magit
  :ensure magit)

(use-package nyan-mode
  :ensure nyan-mode)
(nyan-mode 1)

(use-package ggtags
  :ensure ggtags)			

;;; Save backup files to the system's temporary space
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;; Hide tool bar by default
(tool-bar-mode -1)
;;; Highlight matching parenthesis
(show-paren-mode 1)
;;; 9 point font in the GUI
(set-face-attribute 'default nil :height 90)

(provide '.emacs)
;;; .emacs ends here

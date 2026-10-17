;;; early-init.el --- Early startup config -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; Disable GC during startup; init.el restores it on `emacs-startup-hook'.
(setq gc-cons-threshold most-positive-fixnum)

(setq package-enable-at-startup nil)

(setq frame-inhibit-implied-resize t)

(setq inhibit-compacting-font-caches t)

;; Set via frame parameters rather than `tool-bar-mode' so GUI frames
;; opened later by emacsclient (Emacs runs as a daemon) get them too.
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Native compilation cache, kept out of `user-emacs-directory'.
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name "emacs/eln-cache/"
                     (or (getenv "XDG_CACHE_HOME") "~/.cache/"))))

(provide 'early-init)

;;; early-init.el ends here

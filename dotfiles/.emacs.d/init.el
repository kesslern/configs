; Initialize package management
(require 'package)
(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/") t)
(package-initialize)

;;; Add use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


;;; Add & Configure Packages
(use-package markdown-mode)

(use-package js2-mode)

(use-package org)

(use-package osx-clipboard)
(osx-clipboard-mode +1)

(use-package solarized-theme)
(load-theme 'solarized-dark t)

(use-package powerline)
(powerline-default-theme)

(use-package helm)
(helm-mode 1)
(helm-autoresize-mode t)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(use-package hungry-delete)
(global-hungry-delete-mode)

;;; Custom configuration
(menu-bar-mode -1)
(xterm-mouse-mode 1)
(show-paren-mode 1)
(save-place-mode 1)
(electric-pair-mode 1)

(setq-default indent-tabs-mode nil)
(setq scroll-error-top-bottom t)
(setq require-final-newline t)
(setq scroll-step 1)

;;; Store backup files in temporary filesytem to prevent clutter
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;; Add folder names if buffer names are identical
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;;; Scroll with mouse
(unless window-system
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))


(custom-set-variables
 ;;; custom-set-variables was added by Custom.
 ;;; If you edit it by hand, you could mess it up, so be careful.
 ;;; Your init file should contain only one such instance.
 ;;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(helm-mode t)
 '(package-selected-packages
   (quote
    (hungry-delete powerline smart-mode-line htmlize use-package solarized-theme osx-clipboard helm color-theme-solarized))))
(custom-set-faces
 ;;; custom-set-faces was added by Custom.
 ;;; If you edit it by hand, you could mess it up, so be careful.
 ;;; Your init file should contain only one such instance.
 ;;; If there is more than one, they won't work right.
 )

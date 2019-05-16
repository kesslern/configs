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
(setq js2-strict-missing-semi-warning nil)
(setq js2-missing-semi-one-line-override t)

(use-package org)

(use-package osx-clipboard)
(osx-clipboard-mode +1)

(use-package solarized-theme)
(load-theme 'solarized-dark t)

(use-package powerline)
(powerline-default-theme)

(use-package which-key)
(which-key-mode)

(use-package helm)
(helm-mode 1)
(helm-autoresize-mode t)
(setq helm-boring-buffer-regexp-list
      '("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*Minibuf"))
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
(setq create-lockfiles nil)

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

(defun my-setup-indent (n)
  (setq-local standard-indent n)
  (setq-local c-basic-offset n)
  (setq-local javascript-indent-level n)
  (setq-local js-indent-level n)
  (setq-local react-indent-level n)
  (setq-local js2-basic-offset n)
  (setq-local web-mode-attr-indent-offset n)
  (setq-local web-mode-code-indent-offset n)
  (setq-local web-mode-css-indent-offset n)
  (setq-local web-mode-markup-indent-offset n)
  (setq-local web-mode-sql-indent-offset n)
  (setq-local web-mode-attr-value-indent-offset n)
  (setq-local css-indent-offset n)
  (setq-local sh-basic-offset n)
  (setq-local sh-indentation n))

(defun my-personal-code-style ()
  (interactive)
  ;; use space instead of tab
  (setq indent-tabs-mode nil)
  ;; indent 2 spaces width
  (my-setup-indent 2))

(my-personal-code-style)

;; Some major modes overwrite indentation settings. Run code stye settings after major mode load.
(add-hook 'css-mode-hook 'my-personal-code-style)
(add-hook 'js2-mode-hook 'my-personal-code-style)
(add-hook 'react-mode-hook 'my-personal-code-style)
(add-hook 'sh-mode-hook 'my-personal-code-style)
(add-hook 'js-mode-hook 'my-personal-code-style)

(set-face-attribute 'helm-selection nil 
                    :background "purple"
                    :foreground "black")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(helm-mode t)
 '(package-selected-packages
   (quote
    (which-key multiple-cursors hungry-delete powerline smart-mode-line htmlize use-package solarized-theme osx-clipboard helm))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(header-line ((t (:background "brightcyan" :foreground "black" :inverse-video t))))
 '(org-block-begin-line ((t (:inherit org-meta-line :underline nil)))))

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
(use-package arduino-mode)
(use-package markdown-mode)
(use-package groovy-mode)
(use-package kotlin-mode)
(use-package meghanada)
(use-package company)
(use-package company-arduino)
(use-package company-c-headers)
(use-package company-shell)

(use-package org)

(use-package hl-todo)
(global-hl-todo-mode)

(use-package js2-mode)
(setq js2-strict-missing-semi-warning nil)
(setq js2-missing-semi-one-line-override t)

(use-package osx-clipboard)
(osx-clipboard-mode +1)

(use-package solarized-theme)
(load-theme 'solarized-dark t)

(use-package telephone-line)
(telephone-line-mode 1)

(use-package which-key)
(which-key-mode)

(use-package helm)
(set-face-attribute 'helm-selection nil 
                    :background "purple"
                    :foreground "black")
(helm-mode 1)
(helm-autoresize-mode t)
(setq helm-boring-buffer-regexp-list
      '("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*Minibuf"))
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(use-package smart-hungry-delete
  :ensure t
  :bind (("DEL" . smart-hungry-delete-backward-char)
		 ("C-d" . smart-hungry-delete-forward-char))
  :defer nil ;; dont defer so we can add our functions to hooks 
  :config (smart-hungry-delete-add-default-hooks)
  )

(use-package auto-package-update
   :ensure t
   :config
   (setq auto-package-update-delete-old-versions t
         auto-package-update-interval 4)
   (auto-package-update-maybe))

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
    (hl-todo auto-package-update smart-hungry-delete helm which-key telephone-line solarized-theme osx-clipboard js2-mode company-shell company-arduino meghanada kotlin-mode groovy-mode markdown-mode arduino-mode use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "gray18" :foreground "#839496" :box (:line-width 1 :color "#073642" :style unspecified) :overline "#073642" :underline "#284b54"))))
 '(org-block-begin-line ((t (:inherit org-meta-line :underline nil))))
 '(telephone-line-accent-active ((t (:inherit mode-line :background "darkslateblue" :foreground "white")))))

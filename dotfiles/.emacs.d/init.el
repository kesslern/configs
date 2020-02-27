;;; init.el --- test
;;; Commentary:
;;; kesslern's Emacs config

;;; Code:
;;; Initialize package management
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
(use-package company-arduino)
(use-package company-c-headers)
(use-package company-shell)
(use-package groovy-mode)
(use-package kotlin-mode)
(use-package lsp-ui)
(use-package markdown-mode)
(use-package meghanada)
(use-package org)
(use-package toml-mode)
(use-package web-mode)
(use-package yasnippet)

(use-package flycheck
  :hook (prog-mode . flycheck-mode))

(use-package company
  :hook (prog-mode . company-mode)
  :config (setq company-tooltip-align-annotations t)
          (setq company-minimum-prefix-length 1))

(use-package lsp-mode
  :commands lsp
  :config (require 'lsp-clients))

(use-package hl-todo
  :config
  (global-hl-todo-mode))

(use-package js2-mode
  :config
  (setq js2-strict-missing-semi-warning nil)
  (setq js2-missing-semi-one-line-override t))

(use-package xclip
  :config
  (xclip-mode +1))

(use-package solarized-theme
  :config
  (load-theme 'solarized-dark t))

(use-package telephone-line
  :config
  (telephone-line-mode 1))

(use-package which-key
  :config
  (which-key-mode))

(use-package rust-mode
  :hook (rust-mode . lsp))

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

(use-package flycheck-rust
  :hook (flycheck-mode-hook . flycheck-rust-setup)
  :config
  (setq rust-format-on-save t))

(use-package company-lsp
  :after (rust-mode)
  :config
  (push 'company-lsp company-backends)
  (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common))

(use-package helm
  :config
  (set-face-attribute 'helm-selection nil
                      :background "purple"
                      :foreground "black")
  (helm-mode 1)
  (helm-autoresize-mode t)
  (defvar helm-boring-buffer-regexp-list
    '("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*Minibuf"))
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-x C-b") 'helm-mini)
  (global-set-key (kbd "C-x f") 'helm-find-files)
  (global-set-key (kbd "C-x C-f") 'helm-find-files))

(use-package smart-hungry-delete
  :ensure t
  :bind (("DEL" . smart-hungry-delete-backward-char)
		 ("C-d" . smart-hungry-delete-forward-char))
  :defer nil ;; dont defer so we can add our functions to hooks
  :config (smart-hungry-delete-add-default-hooks))

(use-package auto-package-update
   :ensure t
   :config
   (setq auto-package-update-delete-old-versions t
         auto-package-update-interval 4)
   (auto-package-update-maybe))

;;; Customize built-in modes and settings
(cua-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
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

;;; Use 2 space indents for most languages
(defun my-setup-indent (n)
  "Apply N spaces of indentation for various modes."
  (setq-local standard-indent n)
  (setq-local c-basic-offset n)
  (setq-local js-indent-level n)
  (setq-local js2-basic-offset n)
  (setq-local web-mode-attr-indent-offset n)
  (setq-local web-mode-code-indent-offset n)
  (setq-local web-mode-css-indent-offset n)
  (setq-local web-mode-markup-indent-offset n)
  (setq-local web-mode-sql-indent-offset n)
  (setq-local web-mode-attr-value-indent-offset n))

(defun my-personal-code-style ()
  "Use spaces instead of tabs and two space indent."
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

(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to smarter-move-beginning-of-line
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)

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
    (jsx-mode react-mode web-mode sh-mode company-lsp lsp-ui cargo xclip hl-todo auto-package-update smart-hungry-delete helm which-key telephone-line solarized-theme js2-mode company-shell company-arduino meghanada kotlin-mode groovy-mode markdown-mode arduino-mode use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "gray18" :foreground "#839496" :box (:line-width 1 :color "#073642" :style unspecified) :overline "#073642" :underline nil))))
 '(mode-line-inactive ((t (:background "gray20" :foreground "#586e75" :box (:line-width 1 :color "#002b36" :style unspecified) :overline "#073642" :underline nil))))
 '(org-block-begin-line ((t (:inherit org-meta-line :underline nil))))
 '(telephone-line-accent-active ((t (:inherit mode-line :background "darkslateblue" :foreground "white" :underline nil))))
 '(telephone-line-accent-inactive ((t (:inherit mode-line-inactive :background "grey11" :foreground "gray40")))))

(provide 'init.el)
;;; init.el ends here

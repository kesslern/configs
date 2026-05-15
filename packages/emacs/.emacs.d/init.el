;;; init.el --- Modern Emacs 30 Native Config -*-

;;; Commentary:
;; Single-file, minimal, modern Emacs 30 config using built-in features.

;;; Code:

;; -------------------------------------------------------------------
;;; Early-init behavior (inlined)
;; -------------------------------------------------------------------

(setq gc-cons-threshold most-positive-fixnum)
(setq package-enable-at-startup nil)

;; -------------------------------------------------------------------
;;; XDG Directory Setup
;; -------------------------------------------------------------------

(defvar my/emacs-cache-dir
  (expand-file-name "emacs/" (or (getenv "XDG_CACHE_HOME") "~/.cache"))
  "Directory for Emacs cache files.")

(defvar my/emacs-data-dir
  (expand-file-name "emacs/" (or (getenv "XDG_DATA_HOME") "~/.local/share"))
  "Directory for Emacs data files.")

(unless (file-exists-p my/emacs-cache-dir)
  (make-directory my/emacs-cache-dir t))

(unless (file-exists-p my/emacs-data-dir)
  (make-directory my/emacs-data-dir t))

;; Redirect auto-save and backup files
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" my/emacs-cache-dir) t)))
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" my/emacs-cache-dir))))

;; Redirect package installation
(setq package-user-dir (expand-file-name "elpa/" my/emacs-data-dir))

;; Redirect native-comp cache
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name "eln-cache/" my/emacs-cache-dir)))

;; Redirect other ephemeral files (configured later with their modes)
(setq custom-file (expand-file-name "custom.el" my/emacs-cache-dir))
(setq savehist-file (expand-file-name "history" my/emacs-data-dir))
(setq save-place-file (expand-file-name "places" my/emacs-data-dir))
(setq recentf-save-file (expand-file-name "recentf" my/emacs-data-dir))
(setq recentf-exclude
      (list
       (expand-file-name "eln-cache/" my/emacs-cache-dir)
       (expand-file-name "auto-save/" my/emacs-cache-dir)
       (expand-file-name "backups/" my/emacs-cache-dir)))

(make-directory (expand-file-name "auto-save/" my/emacs-cache-dir) t)
(make-directory (expand-file-name "backups/" my/emacs-cache-dir) t)

;; -------------------------------------------------------------------
;;; Startup Performance
;; -------------------------------------------------------------------

(setq read-process-output-max (* 1024 1024)) ;; 1MB

(defun my/minibuffer-setup ()
  (setq gc-cons-threshold (* 200 1024 1024)))

(defun my/minibuffer-exit ()
  (setq gc-cons-threshold (* 20 1024 1024)))

(add-hook 'minibuffer-setup-hook #'my/minibuffer-setup)
(add-hook 'minibuffer-exit-hook #'my/minibuffer-exit)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 20 1024 1024))))

;; -------------------------------------------------------------------
;;; Package Setup (built-in + use-package)
;; -------------------------------------------------------------------

(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(setq package-quickstart t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; -------------------------------------------------------------------
;;; UI & Appearance
;; -------------------------------------------------------------------

(setq inhibit-startup-screen t)
(column-number-mode 1)

(when (display-graphic-p)
  (tool-bar-mode -1))

(load-theme 'wombat t)

(show-paren-mode 1)
(setq show-paren-delay 0)

(xterm-mouse-mode 1)

;; Smooth scrolling (modern Emacs)
(pixel-scroll-precision-mode 1)
(setq scroll-conservatively 101
      scroll-margin 2
      scroll-error-top-bottom t)

;; which-key
(use-package which-key
  :init (which-key-mode))

;; -------------------------------------------------------------------
;;; Completion (modern stack)
;; -------------------------------------------------------------------

;; Minibuffer completion
(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

;; In-buffer completion popup
(use-package corfu
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)

  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-preview-current nil)
  (corfu-preselect 'prompt)

  ;; Better TAB behavior
  (tab-always-indent 'complete)

  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)
        ("RET" . corfu-insert)))

;; Extra completion backends
(use-package cape
  :init
  ;; Add useful completion-at-point functions
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; -------------------------------------------------------------------
;;; Editing Behavior
;; -------------------------------------------------------------------

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq c-basic-offset 4
      js-indent-level 2
      css-indent-offset 2)

(setq sentence-end-double-space nil)
(setq require-final-newline t)

(delete-selection-mode 1)
(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)

(electric-pair-mode 1)

;; Whitespace + line numbers (fixed)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(dolist (hook '(prog-mode-hook conf-mode-hook text-mode-hook))
  (add-hook hook (lambda ()
                   (setq show-trailing-whitespace t))))

(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; -------------------------------------------------------------------
;;; Navigation Enhancements
;; -------------------------------------------------------------------

(use-package mwim
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)
         ("<home>" . mwim-beginning-of-line-or-code)
         ("<end>" . mwim-end-of-line-or-code)))

(global-set-key (kbd "M-o") #'other-window)

;; -------------------------------------------------------------------
;;; Project Management (built-in)
;; -------------------------------------------------------------------

(global-set-key (kbd "C-c p") project-prefix-map)

;; -------------------------------------------------------------------
;;; Tree-sitter (built-in)
;; -------------------------------------------------------------------

(setq treesit-language-source-alist
      '((python "https://github.com/tree-sitter/tree-sitter-python")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (bash "https://github.com/tree-sitter/tree-sitter-bash")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")))

(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)
        (js-mode . js-ts-mode)
        (css-mode . css-ts-mode)
        (json-mode . json-ts-mode)
        (sh-mode . bash-ts-mode)))

;; -------------------------------------------------------------------
;;; LSP (Eglot - built-in)
;; -------------------------------------------------------------------

(use-package eglot
  :hook ((python-ts-mode . eglot-ensure)
         (js-ts-mode . eglot-ensure)
         (css-ts-mode . eglot-ensure)
         (rust-ts-mode . eglot-ensure))

  :custom
  (eglot-autoshutdown t)

  :config
  ;; Rust analyzer tweaks
  (add-to-list 'eglot-server-programs
               '(rust-ts-mode . ("rust-analyzer"))))

(setq eldoc-echo-area-use-multiline-p nil)

;; -------------------------------------------------------------------
;;; Rust
;; -------------------------------------------------------------------

(use-package rust-mode
  :mode "\\.rs\\'")

(add-to-list 'major-mode-remap-alist
             '(rust-mode . rust-ts-mode))

(use-package flymake
  :ensure nil)

(use-package cargo
  :hook (rust-ts-mode . cargo-minor-mode))

;; -------------------------------------------------------------------
;;; Version Control
;; -------------------------------------------------------------------

(use-package magit
  :commands (magit-status magit-dispatch)
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch))
  :custom
  (magit-display-buffer-function
   #'magit-display-buffer-same-window-except-diff-v1)
  (magit-diff-refine-hunk 'all)
  (magit-save-repository-buffers 'dontask))

(use-package diff-hl
  :hook ((prog-mode text-mode) . diff-hl-mode)
  :hook (magit-pre-refresh . diff-hl-magit-pre-refresh)
  :hook (magit-post-refresh . diff-hl-magit-post-refresh))

;; -------------------------------------------------------------------
;;; Lisp Development
;; -------------------------------------------------------------------

(use-package paredit
  :hook ((emacs-lisp-mode
          eval-expression-minibuffer-setup
          ielm-mode
          lisp-mode
          lisp-interaction-mode) . paredit-mode))

(use-package rainbow-delimiters
  :hook ((emacs-lisp-mode
          ielm-mode
          lisp-mode
          lisp-interaction-mode) . rainbow-delimiters-mode))

;; -------------------------------------------------------------------
;;; File Types
;; -------------------------------------------------------------------

(use-package markdown-mode
  :mode "\\.md\\'")

;; -------------------------------------------------------------------
;;; Server
;; -------------------------------------------------------------------

(use-package server
  :config
  (unless (server-running-p)
    (server-start)))

;; -------------------------------------------------------------------
;;; Local Lisp
;; -------------------------------------------------------------------

(add-to-list 'load-path "~/.emacs.d/lisp")

(use-package rgbds-mode
  :load-path "lisp"
  :mode "\\.asm\\'")

(load custom-file t)
(provide 'init)
;;; init.el ends here

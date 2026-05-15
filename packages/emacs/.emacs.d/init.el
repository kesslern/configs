;;; init.el --- Modern Emacs 30 Config -*- lexical-binding: t; -*-

;;; Commentary:
;; Minimal, modern Emacs 30 configuration using built-in features
;; and a small set of focused packages.

;;; Code:

;; -------------------------------------------------------------------
;;; XDG Directories
;; -------------------------------------------------------------------

(defvar my/cache-dir
  (expand-file-name "emacs/" (or (getenv "XDG_CACHE_HOME")
                                 "~/.cache/"))
  "Directory for cache files.")

(defvar my/data-dir
  (expand-file-name "emacs/" (or (getenv "XDG_DATA_HOME")
                                 "~/.local/share/"))
  "Directory for persistent data files.")

(dolist (dir (list my/cache-dir my/data-dir))
  (make-directory dir t))

;; -------------------------------------------------------------------
;;; File Locations
;; -------------------------------------------------------------------

(setq package-user-dir
      (expand-file-name "elpa/" my/data-dir))

(setq custom-file
      (expand-file-name "custom.el" my/cache-dir))

(setq savehist-file
      (expand-file-name "history" my/data-dir))

(setq save-place-file
      (expand-file-name "places" my/data-dir))

(setq recentf-save-file
      (expand-file-name "recentf" my/data-dir))

;; Auto-save / backups

(defvar my/auto-save-dir
  (expand-file-name "auto-save/" my/cache-dir))

(defvar my/backup-dir
  (expand-file-name "backups/" my/cache-dir))

(make-directory my/auto-save-dir t)
(make-directory my/backup-dir t)

(setq auto-save-file-name-transforms
      `((".*" ,my/auto-save-dir t)))

(setq backup-directory-alist
      `(("." . ,my/backup-dir)))

(setq version-control t
      delete-old-versions t
      kept-new-versions 10
      kept-old-versions 5)

;; Native compilation cache

(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name "eln-cache/" my/cache-dir)))

(setq native-comp-async-report-warnings-errors nil)

;; Recentf exclusions

(setq recentf-exclude
      (list
       (regexp-quote my/auto-save-dir)
       (regexp-quote my/backup-dir)
       (regexp-quote
        (expand-file-name "eln-cache/" my/cache-dir))))

;; -------------------------------------------------------------------
;;; Performance
;; -------------------------------------------------------------------

(setq read-process-output-max (* 4 1024 1024))

(setq gc-cons-threshold (* 64 1024 1024))
(setq gc-cons-percentage 0.1)

(defun my/minibuffer-setup ()
  (setq gc-cons-threshold (* 128 1024 1024)))

(defun my/minibuffer-exit ()
  (setq gc-cons-threshold (* 64 1024 1024)))

(add-hook 'minibuffer-setup-hook #'my/minibuffer-setup)
(add-hook 'minibuffer-exit-hook #'my/minibuffer-exit)

;; -------------------------------------------------------------------
;;; Package Management
;; -------------------------------------------------------------------

(require 'package)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

(setq package-quickstart t)

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)

;; -------------------------------------------------------------------
;;; Core UI
;; -------------------------------------------------------------------

(setq inhibit-startup-screen t)
(setq use-short-answers t)
(setq sentence-end-double-space nil)
(setq require-final-newline t)

(column-number-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)
(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)
(global-auto-revert-mode 1)
(delete-selection-mode 1)
(pixel-scroll-precision-mode 1)
(xterm-mouse-mode 1)

(setq show-paren-delay 0)

(setq scroll-conservatively 101
      scroll-margin 2
      scroll-error-top-bottom t)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

;; -------------------------------------------------------------------
;;; Whitespace / Line Numbers
;; -------------------------------------------------------------------

(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(add-hook 'prog-mode-hook
          (lambda ()
            (setq show-trailing-whitespace t)))

(add-hook 'conf-mode-hook
          (lambda ()
            (setq show-trailing-whitespace t)))

(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; -------------------------------------------------------------------
;;; which-key
;; -------------------------------------------------------------------

(use-package which-key
  :init
  (which-key-mode 1))

;; -------------------------------------------------------------------
;;; Completion Stack
;; -------------------------------------------------------------------

(use-package vertico
  :init
  (vertico-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles partial-completion))
     (eglot (styles orderless)))))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package corfu
  :init
  (global-corfu-mode 1)

  :hook
  (corfu-mode . corfu-history-mode)

  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-preview-current nil)
  (corfu-preselect 'prompt)
  (corfu-quit-no-match 'separator)

  (tab-always-indent 'complete)

  :config
  (when (display-graphic-p)
    (add-hook 'corfu-mode-hook
              #'corfu-popupinfo-mode)))

(use-package corfu-terminal
  :if (not (display-graphic-p))
  :after corfu
  :config
  (corfu-terminal-mode 1))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; -------------------------------------------------------------------
;;; Navigation
;; -------------------------------------------------------------------

(use-package mwim
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)
         ("<home>" . mwim-beginning-of-line-or-code)
         ("<end>" . mwim-end-of-line-or-code)))

(global-set-key (kbd "M-o") #'other-window)

;; -------------------------------------------------------------------
;;; Projects
;; -------------------------------------------------------------------

(global-set-key (kbd "C-c p") project-prefix-map)

;; -------------------------------------------------------------------
;;; Tree-sitter
;; -------------------------------------------------------------------

(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (json "https://github.com/tree-sitter/tree-sitter-json")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
        (toml "https://github.com/tree-sitter/tree-sitter-toml")
        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)
        (css-mode . css-ts-mode)
        (js-mode . js-ts-mode)
        (json-mode . json-ts-mode)
        (sh-mode . bash-ts-mode)
        (typescript-mode . typescript-ts-mode)
        (rust-mode . rust-ts-mode)))

(defun my/install-treesit-grammars ()
  "Install missing tree-sitter grammars."
  (interactive)
  (dolist (grammar
           '(bash css javascript json python rust toml tsx typescript yaml))
    (unless (treesit-language-available-p grammar)
      (treesit-install-language-grammar grammar))))

;; -------------------------------------------------------------------
;;; Eglot
;; -------------------------------------------------------------------

(use-package eglot
  :ensure nil

  :hook ((python-ts-mode . eglot-ensure)
         (js-ts-mode . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (tsx-ts-mode . eglot-ensure)
         (css-ts-mode . eglot-ensure)
         (rust-ts-mode . eglot-ensure))

  :custom
  (eglot-autoshutdown t)

  :config
  (add-to-list 'eglot-server-programs
               '(rust-ts-mode . ("rust-analyzer"))))

(setq eldoc-echo-area-use-multiline-p nil)

;; -------------------------------------------------------------------
;;; Rust
;; -------------------------------------------------------------------

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
  :hook ((prog-mode . diff-hl-mode)
         (text-mode . diff-hl-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh)))

;; -------------------------------------------------------------------
;;; Lisp Development
;; -------------------------------------------------------------------

(use-package paredit
  :hook ((emacs-lisp-mode
          eval-expression-minibuffer-setup
          ielm-mode
          lisp-mode
          lisp-interaction-mode)
         . paredit-mode))

(use-package rainbow-delimiters
  :hook ((emacs-lisp-mode
          ielm-mode
          lisp-mode
          lisp-interaction-mode)
         . rainbow-delimiters-mode))

;; -------------------------------------------------------------------
;;; File Types
;; -------------------------------------------------------------------

(use-package markdown-mode
  :mode "\\.md\\'")

;; -------------------------------------------------------------------
;;; Server
;; -------------------------------------------------------------------

(use-package server
  :ensure nil
  :config
  (unless (server-running-p)
    (server-start)))

;; -------------------------------------------------------------------
;;; Local Lisp
;; -------------------------------------------------------------------

(add-to-list 'load-path
             (expand-file-name "lisp"
                               user-emacs-directory))

(use-package rgbds-mode
  :load-path "lisp"
  :mode "\\.asm\\'")

;; -------------------------------------------------------------------
;;; Custom File
;; -------------------------------------------------------------------

(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

(provide 'init)

;;; init.el ends here
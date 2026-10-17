;;; init.el --- Modern Emacs 31 Config -*- lexical-binding: t; -*-

;;; Commentary:
;; Minimal, modern Emacs 31 configuration using built-in features
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

(setq package-quickstart-file
      (expand-file-name "package-quickstart.el" my/cache-dir))

(setq custom-file
      (expand-file-name "custom.el" my/data-dir))

(setq savehist-file
      (expand-file-name "history" my/data-dir))

(setq save-place-file
      (expand-file-name "places" my/data-dir))

(setq recentf-save-file
      (expand-file-name "recentf" my/data-dir))

(setq project-list-file
      (expand-file-name "projects" my/data-dir))

(setq tramp-persistency-file-name
      (expand-file-name "tramp" my/data-dir))

(setq transient-history-file
      (expand-file-name "transient/history.el" my/data-dir)
      transient-levels-file
      (expand-file-name "transient/levels.el" my/data-dir)
      transient-values-file
      (expand-file-name "transient/values.el" my/data-dir))

(defvar my/treesit-dir
  (expand-file-name "tree-sitter/" my/data-dir)
  "Directory that `my/install-treesit-grammars' installs grammars into.")

(setq treesit-extra-load-path (list my/treesit-dir))

;; Auto-save / backups

(defvar my/auto-save-dir
  (expand-file-name "auto-save/" my/cache-dir))

(defvar my/backup-dir
  (expand-file-name "backups/" my/cache-dir))

(make-directory my/auto-save-dir t)
(make-directory my/backup-dir t)

(setq auto-save-file-name-transforms
      `((".*" ,my/auto-save-dir t)))

(setq auto-save-list-file-prefix
      (expand-file-name "auto-save-list/.saves-" my/cache-dir))

(setq backup-directory-alist
      `(("." . ,my/backup-dir)))

(setq version-control t
      delete-old-versions t
      kept-new-versions 10
      kept-old-versions 5)

;; Native compilation (the eln-cache is redirected in early-init.el)

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

;; early-init.el disables GC for startup; restore it once init is done.
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 64 1024 1024)
                  gc-cons-percentage 0.1)))

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

;; Dark theme with a full palette, so GUI frames don't fall back to
;; Emacs' default black foreground. Built in since Emacs 28.
(setq modus-themes-common-palette-overrides
      '((bg-main "#111111")
        (cursor "#cc9966")
        (comment "#ffcc00")))
(load-theme 'modus-vivendi t)

;; Terminal-style clipboard keys, alongside the usual M-w / C-y / C-w.
(global-set-key (kbd "C-S-c") #'kill-ring-save)
(global-set-key (kbd "C-S-v") #'yank)
(global-set-key (kbd "C-S-x") #'kill-region)

;; -------------------------------------------------------------------
;;; Whitespace / Line Numbers
;; -------------------------------------------------------------------

(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Only in code and config buffers: in Markdown, trailing double spaces
;; are hard line breaks.
(defun my/trailing-whitespace-setup ()
  "Show trailing whitespace and strip it on save in this buffer."
  (setq show-trailing-whitespace t)
  (add-hook 'before-save-hook #'delete-trailing-whitespace nil t))

(add-hook 'prog-mode-hook #'my/trailing-whitespace-setup)
(add-hook 'conf-mode-hook #'my/trailing-whitespace-setup)

;; -------------------------------------------------------------------
;;; which-key
;; -------------------------------------------------------------------

(use-package which-key
  :ensure nil
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
  :hook
  ((prog-mode . corfu-mode)
   (corfu-mode . corfu-history-mode))

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
  ;; Emacs 31+ supports child frames on TTYs, so popupinfo works there too.
  (when (or (display-graphic-p) (>= emacs-major-version 31))
    (add-hook 'corfu-mode-hook
              #'corfu-popupinfo-mode)))

;; Only needed before Emacs 31, which renders Corfu's child frames on TTYs.
(when (< emacs-major-version 31)
  (use-package corfu-terminal
    :if (not (display-graphic-p))
    :after corfu
    :config
    (corfu-terminal-mode 1)))

(use-package cape
  :init
  ;; `add-hook' sets the global value even if the current buffer has a
  ;; local one, and prepends, so the last one added is tried first.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file))

;; -------------------------------------------------------------------
;;; IDE-style TAB / Shift-TAB indentation
;; -------------------------------------------------------------------

(defun my/shift-region (columns)
  "Rigidly shift every line starting in the region by COLUMNS, keeping it active.
A region ending at the start of a line leaves that line alone."
  (let ((deactivate-mark nil))
    (indent-rigidly (region-beginning) (region-end) columns)
    (setq deactivate-mark nil)))

(defun my/indent-dwim (&optional arg)
  "Shift the active region right by `tab-width'; otherwise normal TAB.
With no region this calls `indent-for-tab-command', so
`tab-always-indent' (indent-then-complete) still applies."
  (interactive "P")
  (if (use-region-p)
      (my/shift-region tab-width)
    (indent-for-tab-command arg)))

(defun my/outdent-dwim ()
  "Shift the active region, or the current line, left by `tab-width'."
  (interactive)
  (if (use-region-p)
      (my/shift-region (- tab-width))
    (indent-rigidly (line-beginning-position) (line-end-position)
                    (- tab-width))))

(dolist (key '("TAB" "<tab>"))
  (define-key prog-mode-map (kbd key) #'my/indent-dwim))
(dolist (key '("<backtab>" "S-TAB" "S-<tab>"))
  (define-key prog-mode-map (kbd key) #'my/outdent-dwim))

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
        (js-json-mode . json-ts-mode)
        (sh-mode . bash-ts-mode)
        (typescript-mode . typescript-ts-mode)
        (rust-mode . rust-ts-mode)))

(defun my/install-treesit-grammars ()
  "Install missing tree-sitter grammars into `my/treesit-dir'."
  (interactive)
  (dolist (grammar
           '(bash css javascript json python rust toml tsx typescript yaml))
    (unless (treesit-language-available-p grammar)
      (treesit-install-language-grammar grammar my/treesit-dir))))

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
  (eglot-workspace-configuration
   '(:rust-analyzer (:check (:command "clippy")))))

(setq eldoc-echo-area-use-multiline-p nil)

;; -------------------------------------------------------------------
;;; Rust
;; -------------------------------------------------------------------

(use-package cargo
  :hook (rust-ts-mode . cargo-minor-mode))

;; Only while eglot manages the buffer: with no server connected,
;; `eglot-format-buffer' errors and that aborts the save.
(defun my/eglot-format-on-save ()
  (if (and (eglot-managed-p) (derived-mode-p 'rust-ts-mode))
      (add-hook 'before-save-hook #'eglot-format-buffer nil t)
    (remove-hook 'before-save-hook #'eglot-format-buffer t)))

(add-hook 'eglot-managed-mode-hook #'my/eglot-format-on-save)

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
         (magit-post-refresh . diff-hl-magit-post-refresh)
         (diff-hl-mode . my/diff-hl-use-margin-on-tty)))

;; Terminal frames have no fringe, so show diff-hl in the margin there.
(defun my/diff-hl-use-margin-on-tty ()
  (when (and diff-hl-mode (not (display-graphic-p)))
    (diff-hl-margin-local-mode 1)))

;; -------------------------------------------------------------------
;;; Lisp Development
;; -------------------------------------------------------------------

(use-package paredit
  :hook ((emacs-lisp-mode
          eval-expression-minibuffer-setup
          ielm-mode
          lisp-mode
          lisp-interaction-mode)
         . paredit-mode)
  :config
  ;; paredit-RET shadows RET in the M-: minibuffer and ielm, so RET would
  ;; insert a newline instead of evaluating.
  (define-key paredit-mode-map (kbd "RET") nil))

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

(use-package org
  :ensure nil
  :preface
  (defun my/org-latex-preview-setup ()
    "Render LaTeX fragments now and as they are edited, when images can be shown."
    (when (display-graphic-p)
      (org-latex-preview '(16))
      (org-fragtog-mode 1)))
  :hook (org-mode . my/org-latex-preview-setup)
  :custom
  (org-pretty-entities t)
  (org-highlight-latex-and-related '(native script entities)))

;; Shows a fragment's source while point is inside it, re-renders on leaving.
(use-package org-fragtog
  :commands org-fragtog-mode)

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
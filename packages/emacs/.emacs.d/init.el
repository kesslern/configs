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

(custom-set-faces
 '(default ((t (:background "#111"))))
 '(cursor ((t (:background "#c96"))))
 '(font-lock-comment-face ((t (:foreground "#fc0"))))
 '(isearch ((t (:background "#ff0" :foreground "#000"))))
 '(lazy-highlight ((t (:background "#990" :foreground "#000")))))

(show-paren-mode 1)
(setq show-paren-delay 0)

(xterm-mouse-mode 1)

;; Smooth scrolling (modern Emacs)
(pixel-scroll-precision-mode 1)
(setq scroll-conservatively 101
      scroll-margin 2
      scroll-error-top-bottom t)

;; -------------------------------------------------------------------
;;; Completion (modern stack)
;; -------------------------------------------------------------------

(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom (completion-styles '(orderless basic)))

(use-package marginalia
  :init (marginalia-mode))

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
        (bash "https://github.com/tree-sitter/tree-sitter-bash")))

(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)
        (js-mode . js-ts-mode)
        (css-mode . css-ts-mode)
        (json-mode . json-ts-mode)
        (sh-mode . bash-ts-mode)))

;; -------------------------------------------------------------------
;;; LSP (Eglot - built-in)
;; -------------------------------------------------------------------

(add-hook 'prog-mode-hook #'eglot-ensure)
(setq eglot-autoshutdown t)

;; -------------------------------------------------------------------
;;; Copilot (AI completion)
;; -------------------------------------------------------------------

(use-package copilot
  :ensure t
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . copilot-accept-completion)
              ("TAB" . copilot-accept-completion)
              ("C-TAB" . copilot-accept-completion-by-word)
              ("C-<tab>" . copilot-accept-completion-by-word)))

(setq copilot-idle-delay 0.2)
(setq copilot-max-char -1)
(define-key copilot-completion-map (kbd "C-<return>") #'copilot-accept-completion)

(defun my/copilot-disable-p ()
  (or (derived-mode-p 'emacs-lisp-mode)
      (derived-mode-p 'org-mode)
      (derived-mode-p 'shell-mode)))

(add-hook 'copilot-mode-hook
          (lambda ()
            (when (my/copilot-disable-p)
              (copilot-mode -1))))

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
;;; Backup & Auto-save
;; -------------------------------------------------------------------

(setq backup-directory-alist '(("." . "~/.tmp/emacs/backup/")))
(setq auto-save-file-name-transforms '((".*" "~/.tmp/emacs/auto-save/" t)))

(setq backup-by-copying t
      create-lockfiles nil
      version-control t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2)

(make-directory "~/.tmp/emacs/auto-save/" t)
(make-directory "~/.tmp/emacs/backup/" t)

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

;; -------------------------------------------------------------------
;;; Custom file
;; -------------------------------------------------------------------

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

(provide 'init)
;;; init.el ends here

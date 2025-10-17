;;; init.el --- Modern Emacs Config inspired by Emfy <https://github.com/susam/emfy>

;;; Commentary:
;; A minimal, modern, and maintainable Emacs setup.

;;; Code:

;; -------------------------------------------------------------------
;;; Startup Performance Tweaks
;; -------------------------------------------------------------------

(setq gc-cons-threshold (* 50 1000 1000))
(setq read-process-output-max (* 1024 1024)) ;; 1MB

(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 2 1000 1000))))

;; -------------------------------------------------------------------
;;; Package Setup
;; -------------------------------------------------------------------

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; -------------------------------------------------------------------
;;; UI & Look and Feel
;; -------------------------------------------------------------------

;; Disable unneeded UI elements
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

(setq inhibit-startup-screen t)
(column-number-mode 1)
(global-display-line-numbers-mode 0) ;; enabled selectively later

;; Theme and face customization
(load-theme 'wombat t)
(custom-set-faces
 '(default ((t (:background "#111"))))
 '(cursor ((t (:background "#c96"))))
 '(font-lock-comment-face ((t (:foreground "#fc0"))))
 '(isearch ((t (:background "#ff0" :foreground "#000"))))
 '(lazy-highlight ((t (:background "#990" :foreground "#000")))))

;; Highlight matching parens
(setq show-paren-delay 0)
(show-paren-mode 1)

;; Enable mouse in terminal
(xterm-mouse-mode 1)

;; Scroll to top/bottom error
(setq scroll-error-top-bottom t)

;; Smarter line navigation
(use-package mwim
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)
         ("<home>" . mwim-beginning-of-line-or-code)
         ("<end>" . mwim-end-of-line-or-code)))

;; Completion in minibuffer
(fido-vertical-mode 1)

;; -------------------------------------------------------------------
;;; Editing Behavior
;; -------------------------------------------------------------------

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-basic-offset 4
      js-indent-level 2
      css-indent-offset 2)

;; Single space ends sentences
(setq sentence-end-double-space nil)

;; Newline at end of file
(setq require-final-newline t)

;; Show trailing whitespace
(dolist (hook '(prog-mode-hook conf-mode-hook text-mode-hook))
  (add-hook hook (lambda () (setq show-trailing-whitespace t)))
  (add-hook hook #'display-line-numbers-mode))

;; Highlight empty lines
(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

;; Delete trailing whitespace before save
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; Replace active selection when typing
(delete-selection-mode 1)

;; Restore cursor position on reopen
(save-place-mode 1)

;; Enable persistent minibuffer history
(savehist-mode 1)

;; Track recent files
(recentf-mode 1)

;; -------------------------------------------------------------------
;;; Backup & Auto-save
;; -------------------------------------------------------------------

(setq backup-directory-alist '(("." . "~/.tmp/emacs/backup/")))
(setq auto-save-file-name-transforms '((".*" "~/.tmp/emacs/auto-save/" t)))
(setq backup-by-copying t)
(setq create-lockfiles nil)

(make-directory "~/.tmp/emacs/auto-save/" t)
(make-directory "~/.tmp/emacs/backup/" t)

;; Store customizations separately
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

;; -------------------------------------------------------------------
;;; Key Bindings & Commands
;; -------------------------------------------------------------------

(defun show-current-time ()
  "Display current time in minibuffer."
  (interactive)
  (message (current-time-string)))

(global-set-key (kbd "C-c t") 'show-current-time)
(global-set-key (kbd "C-c d") 'delete-trailing-whitespace)

;; -------------------------------------------------------------------
;;; Server Mode
;; -------------------------------------------------------------------

(use-package server
  :config
  (unless (server-running-p)
    (server-start)))

;; -------------------------------------------------------------------
;;; Development Tools
;; -------------------------------------------------------------------

(use-package paredit
  :hook ((emacs-lisp-mode
          eval-expression-minibuffer-setup
          ielm-mode
          lisp-interaction-mode
          lisp-mode) . paredit-mode)
  :config
  (define-key paredit-mode-map (kbd "RET") nil))

(use-package rainbow-delimiters
  :hook ((emacs-lisp-mode
          ielm-mode
          lisp-interaction-mode
          lisp-mode) . rainbow-delimiters-mode)
  :config
  (set-face-foreground 'rainbow-delimiters-depth-1-face "#c66")
  (set-face-foreground 'rainbow-delimiters-depth-2-face "#6c6")
  (set-face-foreground 'rainbow-delimiters-depth-3-face "#69f")
  (set-face-foreground 'rainbow-delimiters-depth-4-face "#cc6")
  (set-face-foreground 'rainbow-delimiters-depth-5-face "#6cc")
  (set-face-foreground 'rainbow-delimiters-depth-6-face "#c6c")
  (set-face-foreground 'rainbow-delimiters-depth-7-face "#ccc")
  (set-face-foreground 'rainbow-delimiters-depth-8-face "#999")
  (set-face-foreground 'rainbow-delimiters-depth-9-face "#666"))

(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode))

;; -------------------------------------------------------------------
;;; Load Local Lisp Packages (Optional)
;; -------------------------------------------------------------------

(add-to-list 'load-path "~/.emacs.d/lisp")

(use-package rgbds-mode
  :load-path "lisp"
  :mode ("\\.asm\\'" . rgbds-mode))

;;; End of File
(provide 'init)

;;; init.el ends here

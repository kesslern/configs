;;; .emacs -- kesslern

;;; Commentary:
;;; GNU/emacs config file

;;; Code:

;; Ensure emacs can install packages, add melpa to repo list
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
;; Install use-package if it isn't installed
(package-initialize)
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(require 'use-package)

;;; Install packages

;; Used by other packages
(use-package popup
    :ensure popup)
(use-package yasnippet
    :ensure yasnippet)
;; Syntax checking
(use-package flycheck
    :ensure flycheck)
;; Find files in svn/git repo
(use-package find-file-in-repository
    :ensure find-file-in-repository)
;; Color themes, requires cl
(use-package cl
    :ensure cl)
(use-package color-theme
    :ensure color-theme)
;; Should look into more helm extensions
(use-package helm
    :ensure helm)
(use-package helm-company
    :ensure helm-company)
;; Magit, git integration
(use-package magit
    :ensure magit)
;; Nyan-cat in modebar
(use-package nyan-mode
    :ensure nyan-mode)
;; Spell checking
(use-package flyspell
    :ensure flyspell)
(use-package auto-complete
    :ensure auto-complete)
(use-package auto-complete-clang
    :ensure auto-complete-clang)
(use-package slime
    :ensure slime)
(use-package ac-slime
    :ensure ac-slime)
(use-package elisp-slime-nav
    :ensure elisp-slime-nav)
(use-package smooth-scrolling
    :ensure smooth-scrolling)
(use-package hungry-delete
    :ensure hungry-delete)
(use-package yascroll
    :ensure yascroll)
(use-package powerline
    :ensure powerline)
(use-package rainbow-delimiters
    :ensure rainbow-delimiters)
(use-package smartparens
    :ensure smartparens)
(use-package yaml-mode
    :ensure yaml-mode)
;;; Configuration of packages

(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(helm-mode 1)
(color-theme-initialize)
(powerline-default-theme)
(ac-config-default)
(global-hungry-delete-mode)
;; elisp-slime-nav config
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'elisp-slime-nav-mode))
;; Don't show magit setup instructions. Info here:
;; https://raw.githubusercontent.com/magit/magit/next/Documentation/RelNotes/1.4.0.txt
(setq magit-last-seen-setup-instructions "1.4.0")
;; ac-slime config, slime should be configured more probably
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'slime-repl-mode))
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))
(global-flycheck-mode)
(global-set-key (kbd "C-c o") 'ff-find-other-file)

;;; Configuration of built-in emacs features

;; Set the theme
(custom-set-variables
 '(custom-enabled-themes (quote(misterioso))))
;; Save backup files to the system's temporary space
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
;; Hide tool bar by default
(tool-bar-mode -1)
;; Disable menu bar at top of screen
(menu-bar-mode -1)
;; Highlight matching parenthesis
(show-paren-mode 1)
(setq scroll-error-top-bottom t)
;; hs-minor-mode in C editing. Allows hiding/showing blocks of code.
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'objc-mode-hook 'hs-minor-mode)
;;  Tab-indent makefiles
(add-hook 'makefile-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)))
;; Automatic bracket completion
(electric-pair-mode)

(if window-system

    (progn
      ;; Options specific to GUI
      (set-face-attribute 'default nil :height 90)
      (nyan-mode 1))

    (progn
      ;; Options specific to CLI
      (color-theme-billw)
      (nyan-mode -1)
      ))

;;; Keyboard shortcuts

;; Kill current buffer immediately with C-x C-k.
;; C-x k still prompts for which buffer to kill.
(global-set-key (kbd "C-x C-k") 'kill-this-buffer)
;; Better buffer switching with C-x C-b (this is built in)
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; Use find-file-in-repository by default.
;; Will fall back to find-file when not in a repo.
(global-set-key (kbd "C-x C-f") 'find-file-in-repository)
;; find-file with C-x f everywhere
(global-set-key (kbd "C-x f") 'find-file)
;; Set RET to newline-and-indent so the a newly created line
;; is automatically indented without pressing tab.
(define-key global-map (kbd "RET") 'newline-and-indent)

(provide '.emacs)
;;; .emacs ends here

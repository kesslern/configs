;;; .emacs -- kesslern

;;; Commentary:
;;; GNU/emacs config file

;;; Code:

;;; Kill current buffer immediately with C-x C-k.
;;; C-x k still prompts for which buffer to kill.
(global-set-key (kbd "C-x C-k") 'kill-this-buffer)

;;; Better buffer switching with C-x C-b
;;; (this is built in)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;; Set RET to newline-and-indent so the a newly created line
;;; is automatically indented without pressing tab.
(define-key global-map (kbd "RET") 'newline-and-indent)

;;; hs-minor-mode in C editing. Allows hiding/showing blocks of code.
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'objc-mode-hook 'hs-minor-mode)

;;; Disable menu bar at top of screen
(menu-bar-mode -1)

;;; This installs and initializes the MELPA package manager.
;;; Allows us to automatically install needed packages below
;;; using use-package package.
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(require 'use-package)

(use-package flycheck
	:ensure flycheck)

;;; On-the-fly syntax checking wherever possible
;;; (disabled, was deleting code?)
;(global-flycheck-mode 1)

(use-package find-file-in-repository
	:ensure find-file-in-repository)

;;; Will default to normal find-file if not in a repo
;;; Normal find-file with C-x f everywhere
(global-set-key (kbd "C-x C-f") 'find-file-in-repository)
(global-set-key (kbd "C-x f") 'find-file)

;;; Should look into more helm extensions
(use-package helm
	:ensure helm)
(use-package helm-company
	:ensure helm-company)

;;; Start Helm globally. Better menus, must have.
(helm-mode 1)

;;; Install flyspell but don't enable it by default
(use-package flyspell 
	:ensure )

(use-package company
	:ensure company)

;;; Company mode globally
(global-company-mode)
;;; Delay of 0.5s before menu shows
(set 'company-idle-delay 0.5)

(use-package ido-vertical-mode
	:ensure ido-vertical-mode)
;;; IDO mode, better buffer switching. Use vertical mode too.
;;; Helm replaces most of the places where ido-mode would
;;; normally be used, but not all.
(ido-mode 1)
(ido-vertical-mode 1)

;;; Install color themes from MELPA
;;; requires package cl
(use-package cl
  :ensure cl)
(use-package color-theme
  :ensure color-theme)
(color-theme-initialize)
;;; billw color theme
(color-theme-billw)

;;; Install magit, git integration
(use-package magit
  :ensure magit)

;;; Install malabar-mode, a better java mode
;;; TODO: Make work...
;; (use-package malabar-mode
;;   :ensure malabar-mode)

;; (require 'cedet)
;; (require 'semantic)
;; (load "semantic/loaddefs.el")
;; (semantic-mode 1);;
;; (require 'malabar-mode)
;; (add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))  

(provide '.emacs)
;;; .emacs ends here

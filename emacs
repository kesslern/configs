;;; .emacs -- kesslern

;;; Commentary:
;;; GNU/emacs config file

;;; Code:

;;; ****General settings, no packages required:

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
(global-flycheck-mode 1)

(use-package find-file-in-repository
	:ensure find-file-in-repository)
;;; ****Requires find-file-in-repository:
;;; Will default to normal find-file if not in a repo
(global-set-key (kbd "C-x C-f") 'find-file-in-repository)

;;; Should look into more helm extensions
(use-package helm
	:ensure helm)
(use-package helm-company
	:ensure helm-company)
;;; ****Requires helm:
;;; Start Helm globally. Better menus, must have.
(helm-mode 1)

;;; Install flyspell but don't enable it by default
(use-package flyspell 
	:ensure )

(use-package company
	:ensure company)
;;; ****Requires company-mode:
;;; Company mode in C editing. Required by irony-mode.
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)
(add-hook 'objc-mode-hook 'company-mode)

(use-package irony
	:ensure irony)
;;; **** Requires irony-mode:
;;; Irony mode in C editing. Smart completion with clang.
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;;; Irony-Mode install told me to put this here... try removing?
;;; replace the `completion-at-point' and `complete-symbol' bindings in
;;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)

(use-package ido-vertical-mode
	:ensure ido-vertical-mode)
;;; IDO mode, better buffer switching. Use vertical mode too.
;;; Helm replaces most of the places where ido-mode would
;;; normally be used, but not all.
(ido-mode 1)
(ido-vertical-mode 1)

;;; Install color themes from MELPA
(use-package cl
    :ensure cl)
(use-package color-theme
    :ensure color-theme)
(color-theme-initialize)
    
;;; Install magit
(use-package magit
    :ensure magit)

(provide '.emacs)
;;; .emacs ends here

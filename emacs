;;; .emacs -- kesslern

;;; Commentary:
;;; GNU/emacs config file

;;; Code:

;;; ****General settings, no packages required:
;;; On-the-fly syntax checking wherever possible
(global-flycheck-mode 1)

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

;;; ****You must manually install the MELPA package manager:
;;; Will list all installed packages in future...
(require 'package)
(add-to-list 'package-archives
  '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
(package-initialize)

;;; ****Requires find-file-in-repository:
;;; Will default to normal find-file if not in a repo
(global-set-key (kbd "C-x C-f") 'find-file-in-repository)

;;; ****Requires helm:
;;; Start Helm globally. Better menus, must have.
(helm-mode 1)

;;; ****Requires flyspell:
;;; Enable flyspell
(add-hook 'c++-mode-hook 'flyspell-mode)
(add-hook 'c-mode-hook 'flyspell-mode)
(add-hook 'objc-mode-hook 'flyspell-mode)

;;; ****Requires company-mode:
;;; Company mode in C editing. Required by irony-mode.
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)
(add-hook 'objc-mode-hook 'company-mode)

;;; **** Requires irony-mode:
;;; Irony mode in C editing. Smart completion with clang.
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;;; Irony-Mode install told me to put this here
;;; replace the `completion-at-point' and `complete-symbol' bindings in
;;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)

;;; ****Requires ido-mode-vertical:
;;; IDO mode, better buffer switching. Use vertical mode too.
;;; Helm replaces most of the places where ido-mode would
;;; normally be used, but not all.
(require 'ido)
(ido-mode 1)
(setq ido-separator "\n")
(ido-vertical-mode 1)

;;; ****I bet these are in MELPA...? I need to investigate this.
;;; Color themes. These were installed manually, without MELPA.
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-billw))) ; Change to whatever theme

;;; Disable menu bar at top of screen
(menu-bar-mode -1)

(provide '.emacs)
;;; .emacs ends here
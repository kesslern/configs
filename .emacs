;;; Will default to normal find-file if not in a repo
(global-set-key (kbd "C-x C-f") 'find-file-in-repository)

;;; Set RET to newline-and-indent
(define-key global-map (kbd "RET") 'newline-and-indent)

;;; MEPLA package manager
;;; Install company-mode, irony-mode for auto completion
;;; also, find-file-in-repository, magit
;;; ido-vertical installed, dunno if it does anything
(require 'package)
(add-to-list 'package-archives
  '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
(package-initialize)

;;; Start Helm globally
(helm-mode 1)

;;; hs-minor in C editing
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'objc-mode-hook 'hs-minor-mode)

;;; Company mode in C editing
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)
(add-hook 'objc-mode-hook 'company-mode)

;;; Irony mode in C editing
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point]
          'irony-completion-at-point-async)
      (define-key irony-mode-map [remap complete-symbol]
	    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)

;;; IDO mode, better buffer switching
(require 'ido)
(ido-mode 1)
(setq ido-separator "\n")

;;; Color themes
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-billw)))

;;; No menu bar
(menu-bar-mode -1)

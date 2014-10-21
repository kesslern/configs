(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(require 'use-package)

(use-package ido-vertical-mode
  :ensure ido-vertical-mode)
(require 'ido)
(ido-mode 1)
(ido-vertical-mode 1)

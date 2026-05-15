;;; early-init.el --- Early startup config -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(setq gc-cons-threshold most-positive-fixnum)

(setq package-enable-at-startup nil)

(setq frame-inhibit-implied-resize t)

(setq inhibit-compacting-font-caches t)

(provide 'early-init)

;;; early-init.el ends here
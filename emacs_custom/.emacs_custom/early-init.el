;;; early-init.el --- init before GUI -*- lexical-binding: t; -*-
;;; Commentary:
;;;
;;; Code:
(add-to-list 'load-path (expand-file-name "elisp" user-emacs-directory))

;; Disable package.el in favor of straight.el
(setq package-enable-at-startup nil)
(setq native-comp-deferred-compilation-deny-list ())

;;; early-init.el ends here

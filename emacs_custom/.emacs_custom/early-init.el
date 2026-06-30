;;; early-init.el --- init before GUI -*- lexical-binding: t; -*-
;;; Commentary:
;;;
;;; Code:

;; Load customizations as early as possible so user settings
;; (e.g. emacs-solo-avoid-flash-options) take effect before they are used.
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

(add-to-list 'load-path (expand-file-name "elisp" user-emacs-directory))

;; Disable package.el in favor of straight.el
(setq package-enable-at-startup nil)
(setq native-comp-deferred-compilation-deny-list ())

;;; early-init.el ends here

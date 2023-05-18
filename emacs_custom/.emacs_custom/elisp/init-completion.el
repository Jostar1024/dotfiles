;;; init-completion.el --- init of emacs -*- lexical-binding: t; -*-

;; A few more useful configurations...
(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)

  ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
  ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete))

(use-package corfu
  :straight (corfu :files (:defaults "extensions/*"))
  :custom
  (corfu-cycle nil)			;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)			;; Enable auto completion
  (corfu-auto-delay 0)
  (corfu-auto-prefix 2)
  
  (corfu-separator ?\s)			;; Orderless field separator
  (corfu-quit-at-boundary t)		;; Never quit at completion boundary
  (corfu-quit-no-match t)		;; Never quit, even if there is no match
  (corfu-preview-current 'insert)	;; Disable current candidate preview
  (corfu-preselect 'prompt)		;; Preselect the prompt
  (corfu-on-exact-match nil)		;; Configure handling of exact matches
  (corfu-scroll-margin 5)		;; se scroll margin

  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  ) 


(provide 'init-completion)

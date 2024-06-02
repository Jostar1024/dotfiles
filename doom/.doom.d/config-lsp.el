;;; ../dotfiles/doom/config-lsp.el -*- lexical-binding: t; -*-

(use-package lsp-mode
  :hook
  ((rust-mode c-mode elixir-mode) . lsp-deferred)
  :commands
  (lsp lsp-deferred)
  :custom
  ;; (lsp-completion-provider :capf)
  (lsp-enable-file-watchers nil)
  (lsp-keymap-prefix "C-l")
  (lsp-enable-symbol-highlighting nil)
  (lsp-lens-enable nil)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-modeline-code-actions-enable nil)
  (lsp-signature-auto-activate nil)
  (lsp-modeline-diagnostics-enable nil)
  (lsp-signature-render-documentation nil)
  ;; (lsp-completion-show-detail nil)
  ;; (lsp-completion-show-kind t)
  (lsp-elixir-server-command '("elixir-ls"))
  :config
  (defun lsp-booster--advice-json-parse (old-fn &rest args)
    "Try to parse bytecode instead of json."
    (or
     (when (equal (following-char) ?#)
       (let ((bytecode (read (current-buffer))))
         (when (byte-code-function-p bytecode)
           (funcall bytecode))))
     (apply old-fn args)))
  (advice-add 'json-parse-buffer :around #'lsp-booster--advice-json-parse)

  (defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
    "Prepend emacs-lsp-booster command to lsp CMD."
    (let ((orig-result (funcall old-fn cmd test?)))
      (if (and (not test?)                             ;; for check lsp-server-present?
               (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
               lsp-use-plists
               (not (functionp 'json-rpc-connection))  ;; native json-rpc
               (executable-find "emacs-lsp-booster"))
          (progn
            (message "Using emacs-lsp-booster for %s!" orig-result)
            (cons "emacs-lsp-booster" orig-result))
        orig-result)))
  (advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)
  )


(use-package! lsp-ui
  :hook
  (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'top
        lsp-ui-doc-include-signature t
        lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-delay 0
        lsp-ui-doc-max-height 13
        lsp-ui-doc-max-width 150
        ))
;; (use-package eglot
;;   :bind
;;   (:map eglot-mode-map ("M-." . '+lsp-xfind-or-dumb-jump))
;;   :hook
;;   ((rust-mode c-mode elixir-mode) . eglot-ensure)
;;   :custom
;;   (eglot-ignored-server-capabilites '(:documentHighlightProvider))
;;   :config
;;   (add-to-list 'eglot-server-programs '(elixir-mode "/home/yucheng/projects/elixir-ls/release/language_server.sh")))

;; (use-package nox
;;   :hook
;;   ((rust-mode c-mode elixir-mode) . nox-ensure)
;;   :bind
;;   (:map nox-mode-map
;;    ("M-f" . nox-show-doc)
;;    ("M-h" . nox-show-signature))
;;   :custom-face
;;   (highlight . (((t (:background "red")))))
;;   :config
;;   (add-to-list 'nox-server-programs '(elixir-mode "/home/yucheng/projects/elixir-ls/release/language_server.sh")))

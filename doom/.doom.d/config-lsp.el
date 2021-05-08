;;; ../dotfiles/doom/config-lsp.el -*- lexical-binding: t; -*-

(use-package lsp-mode
  :hook
  ((rust-mode c-mode elixir-mode) . lsp-deferred)
  :commands
  (lsp lsp-deferred)
  :custom
  (lsp-completion-provider :capf)
  (lsp-enable-file-watchers nil)
  (lsp-keymap-prefix "C-l")
  (lsp-enable-symbol-highlighting nil)
  (lsp-lens-enable nil)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-modeline-code-actions-enable nil)
  (lsp-signature-auto-activate t)
  (lsp-modeline-diagnostics-enable nil)
  (lsp-signature-render-documentation nil)
  (lsp-completion-show-detail nil)
  (lsp-completion-show-kind t)
  (lsp-elixir-server-command '("/home/yucheng/projects/elixir-ls/release/language_server.sh")))


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

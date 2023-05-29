;;; init-elixir.el --- init of emacs -*- lexical-binding: t; -*-

(use-package elixir-mode
  :config
  (font-lock-add-keywords 'elixir-mode
                          '(("\\([_a-zA-Z0-9!?]+\\):" 1 'default)
                            (":[_a-zA-Z0-9\"!?]+" . font-lock-constant-face)
                            ("defmacro \\([a-zA-Z0-9!?_]+\\)" 1 font-lock-function-name-face)
                            ("\\_<@[_a-zA-Z0-9!?]+\\_>" . 'default)
                            ("\\_<true\\_>" . font-lock-constant-face)
                            ("\\_<false\\_>" . font-lock-constant-face)
                            ("\\_<nil\\_>" . font-lock-constant-face)
                            ("\\_<_[a-zA-Z0-9]*\\_>" . '+elixir-dim-face)))

  (modify-syntax-entry ?& "'" elixir-mode-syntax-table)
  )

(use-package lsp-mode
  :hook
  ((rust-mode c-mode elixir-mode) . lsp-deferred)
  :commands
  (lsp lsp-deferred)
  :custom
  (lsp-completion-provider :none) ;; we use Corfu!

  (lsp-elixir-server-command '("/home/yucheng/community/elixir-ls/release/language_server.sh"))
  )


(provide 'init-elixir)

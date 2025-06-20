;;; ../dotfiles/doom/config-elixir.el -*- lexical-binding: t; -*-

(defface +elixir-dim-face
  '((((class color) (background dark))
     (:foreground "grey60"))
    (((class color) (background light))
     (:foreground "grey40")))
  "Elixir dim face.")


(use-package! elixir-ts-mode
  :init
  ;; Disable default smartparens config. There are too many pairs; we only want
  ;; a subset of them (defined below).
  (provide 'smartparens-elixir)
  :config
  (font-lock-add-keywords 'elixir-ts-mode
                          '(("\\([_a-zA-Z0-9!?]+\\):" 1 'default)
                            (":[_a-zA-Z0-9\"!?]+" . font-lock-constant-face)
                            ("defmacro \\([a-zA-Z0-9!?_]+\\)" 1 font-lock-function-name-face)
                            ("\\_<@[_a-zA-Z0-9!?]+\\_>" . 'default)
                            ("\\_<true\\_>" . font-lock-constant-face)
                            ("\\_<false\\_>" . font-lock-constant-face)
                            ("\\_<nil\\_>" . font-lock-constant-face)
                            ("\\_<_[a-zA-Z0-9]*\\_>" . '+elixir-dim-face)))

  ;; ...and only complete the basics
  (sp-with-modes 'elixir-ts-mode
    (sp-local-pair "do" "end"
                   :when '(("RET" "<evil-ret>"))
                   :unless '(sp-in-comment-p sp-in-string-p)
                   :post-handlers '("||\n[i]"))
    (sp-local-pair "do " " end" :unless '(sp-in-comment-p sp-in-string-p))
    (sp-local-pair "fn " " end" :unless '(sp-in-comment-p sp-in-string-p)))
  (evil-define-key '(normal visual) elixir-ts-mode-map (kbd "RET") 'inf-iex-eval)
  (map! :after elixir-ts-mode
        :map elixir-ts-mode-map
        :localleader
        :n "f" #'elixir-format
        :n "d" #'lsp-ui-doc-glance
        :n "c c" #'inf-iex-eval
        :n "c v" #'inf-iex-toggle-send-target
        :n "i" #'lsp-ui-imenu)
  )

(use-package! inf-iex
  :hook
  (elixir-ts-mode . inf-iex-minor-mode)
  :init
  (evil-set-initial-state 'inf-iex-tracer-mode 'motion))

(defun +copy-file-name ()
  (interactive)
  (kill-new (buffer-file-name)))

(use-package! exunit
  :hook (elixir-ts-mode . exunit-mode)
  :init
  (map! :after elixir-ts-mode
        :localleader
        :map elixir-ts-mode-map
        "m" #'exunit-transient)

  (map! :after elixir-ts-mode
        :localleader
        :map elixir-ts-mode-map
        :prefix ("t" . "test")
        "a" #'exunit-verify-all
        "r" #'exunit-rerun
        "v" #'exunit-verify
        "T" #'exunit-toggle-file-and-test
        "t" #'exunit-toggle-file-and-test-other-window
        "s" #'exunit-verify-single))

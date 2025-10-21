;;; ../dotfiles/doom/config-elixir.el -*- lexical-binding: t; -*-

(use-package! elixir-ts-mode
  :init
  ;; Disable default smartparens config. There are too many pairs; we only want
  ;; a subset of them (defined below).
  (provide 'smartparens-elixir)
  :hook (elixir-ts-mode . my/elixir-ts-map-keys-as-default)
  :config
  (defun my/elixir-ts-map-keys-as-default ()
    (when (treesit-ready-p 'elixir)
      (setq-local treesit-font-lock-feature-list
                  (let ((base (copy-sequence treesit-font-lock-feature-list)))
                    (setf (nth 0 base)
                          (append (nth 0 base)
                                  '(my/map-key-default my/map-key-default-2 my/keyword-key-default)))
                    base))

      (setq-local treesit-font-lock-level (max 4 (or treesit-font-lock-level 4)))

      (setq-local treesit-font-lock-settings
                  (append treesit-font-lock-settings
                          (treesit-font-lock-rules
                           ;; 1) 关键词语法：%{a: b, c: d}
                           :language 'elixir
                           :feature 'my/map-key-default
                           :override t
                           '((map
                              (map_content
                               (keywords (pair key: (keyword) @default)))))

                           ;; 2) => 语法：%{:a => :b, "c" => :d}
                           ;;    只把左侧 key 的 atom 设为 default，不影响右侧
                           :language 'elixir
                           :feature 'my/map-key-default-2
                           :override t
                           '((map
                              (map_content
                               (binary_operator
                                left: (atom) @default
                                operator: "=>"
                                right: (_)))))

                           :language 'elixir
                           :feature 'my/keyword-key-default
                           :override t
                           '((keywords (pair key: (keyword) @default)
                              )))))
      (treesit-font-lock-recompute-features)
      (font-lock-flush)))


  ;; ...and only complete the basics
  (sp-with-modes 'elixir-ts-mode
    (sp-local-pair "do" "end"
                   :when '(("RET" "<evil-ret>"))
                   :unless '(sp-in-comment-p sp-in-string-p)
                   :post-handlers '("||\n[i]"))
    (sp-local-pair "do " " end" :unless '(sp-in-comment-p sp-in-string-p))
    (sp-local-pair "fn " " end" :unless '(sp-in-comment-p sp-in-string-p)))
  (evil-define-key '(normal visual) elixir-ts-mode-map (kbd "RET") 'inf-iex-eval)
  ;; (defun +drop-db ()
  ;;   (interactive)
  ;;   (let*
  ;;       (env (read-from-minibuffer "Environment: " "dev"))
  ;;     (projectile-run-async-shell-command-in-root "mix ecto.drop && mix ecto.create && mix ecto.migrate")))
  (defun +update-deps ()
    (interactive)
    (projectile-run-async-shell-command-in-root "mix deps.get"))
  (map! :after elixir-ts-mode
        :map elixir-ts-mode-map
        :localleader
        :n "f" #'elixir-format
        :n "g" #'+update-deps
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

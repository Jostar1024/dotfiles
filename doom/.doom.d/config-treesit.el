;;; ../.dotfiles/doom/.doom.d/config-treesit.el -*- lexical-binding: t; -*-

(defvar treesit--fold-elixir-tests-query '(((call target: (_) @identifier (arguments (_)) (do_block _ _) @do_block)
                                            (:match "test" @identifier)))
  "The query to fold all elixir tests"
  )

(defvar treesit--fold-elixir-functions-query '(((call target: (_) @identifier (arguments (_)) (do_block _ _) @do_block)
                                                (:match "defp?$" @identifier)))
  "The query to fold all elixir functions, both public and private")

(defun treesit-fold-all-elixir-tests-in-current-buffer ()
  "Fold all Elixir tests."
  (interactive)
  (when (treesit-available-p)
    (let* ((query (treesit-query-compile 'elixir treesit--fold-elixir-tests-query))
           (nodes (treesit-query-capture (treesit-buffer-root-node) query)))
      (thread-last nodes
                   (seq-filter (lambda (node) (eq (car node) 'do_block)))
                   (mapcar #'cdr)
                   (mapc #'treesit-fold-close)))))

(defun treesit-fold-all-elixir-functions-in-current-buffer ()
  "Fold all Elixir function definitions in the current buffer."
  (interactive)
  (when (treesit-available-p)
    (let* ((query (treesit-query-compile 'elixir treesit--fold-elixir-functions-query))
           (nodes (treesit-query-capture (treesit-buffer-root-node) query)))
      (thread-last nodes
                   (seq-filter (lambda (node) (eq (car node) 'do_block)))
                   (mapcar #'cdr)
                   (mapc #'treesit-fold-close)))))

(use-package! treesit-fold
  :hook
  ((elixir-ts-mode) . treesit-fold-mode))

(use-package! treesit-langs
  :config
  (setq major-mode-remap-alist
        '((python-mode      . python-ts-mode)
          (c-mode           . c-ts-mode)
          (js-mode          . js-ts-mode)
          (typescript-mode  . typescript-ts-mode)
          (css-mode         . css-ts-mode)
          (json-mode        . json-ts-mode)
          (yaml-mode        . yaml-ts-mode)
          (bash-mode        . bash-ts-mode)
          (rust-mode        . rust-ts-mode)
          (elixir-mode      . elixir-ts-mode))))

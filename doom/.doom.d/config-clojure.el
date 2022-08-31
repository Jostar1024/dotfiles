;;; ../.dotfiles/doom/.doom.d/config-clojure.el -*- lexical-binding: t; -*-

(use-package! clojure-mode
  :custom
  (clojure-toplevel-inside-comment-form t)
  :hook
  (clojure-mode . paredit-mode)
  :config
  (add-hook 'clojure-mode-hook 'paredit-mode)
  (evil-define-key 'normal clojure-mode-map (kbd "RET") 'cider-eval-defun-at-point)
  (map! :map clojure-mode-map
        :localleader
        :n "a" #'clojure-align))

;; (defun exec-sexp ()
;;   (interactive)
;;   (execute-kbd-macro (read-kbd-macro "C-M-x")))

;; (evil-global-set-key 'normal (kbd "RET") 'exec-sexp)

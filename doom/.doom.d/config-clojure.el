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
        :n "a" #'clojure-align
        ))

(use-package! cider
  :custom
  ;; NOTE: to see the doc from Java, e.g. StringBuilder, InputStream
  (cider-enrich-classpath t)
  :config
  (cider-register-cljs-repl-type 'mynbb "(+ 1 2 3)")
  (defun mm/cider-connected-hook ()
    (when (eq 'nbb cider-cljs-repl-type)
      (setq-local cider-show-error-buffer nil)
      (cider-set-repl-type 'cljs)))
  (defun custom-eval-user-go ()
    (interactive)
    (save-buffer)
    (cider-interactive-eval (format "(integrant.repl/reset)" (cider-last-sexp))))
  (add-hook 'cider-connected-hook #'mm/cider-connected-hook)
  (map! :map cider-mode-map
        :localleader
        :n "k" #'custom-eval-user-go))


;; (defun exec-sexp ()
;;   (interactive)
;;   (execute-kbd-macro (read-kbd-macro "C-M-x")))

;; (evil-global-set-key 'normal (kbd "RET") 'exec-sexp)

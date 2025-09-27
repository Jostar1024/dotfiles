;; init-cljoure.el -*- lexical-binding: t; -*-

(use-package clojure-mode
  :custom
  (clojure-toplevel-inside-comment-form t)
  :hook
  (clojure-mode . paredit-mode)
  :config
  (add-hook 'clojure-mode-hook 'paredit-mode)
  ;; (evil-define-key 'normal clojure-mode-map (kbd "RET") 'cider-eval-defun-at-point)
  )

(use-package cider
  :custom
  ;; NOTE: to see the doc from Java, e.g. StringBuilder, InputStream
  (cider-enrich-classpath t)
  :config
  (defun custom-eval-user-go ()
    (interactive)
    (save-buffer)
    (cider-interactive-eval (format "(integrant.repl/reset)" (cider-last-sexp))))
  :bind
  (:map cider-mode-map ("k" . #'custom-eval-user-go))
  )


(provide 'init-clojure)

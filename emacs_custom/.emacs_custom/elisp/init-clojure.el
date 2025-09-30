;; init-cljoure.el -*- lexical-binding: t; -*-

(use-package clojure-mode
  :custom
  (clojure-toplevel-inside-comment-form t)
  ;; :hook
  ;; (clojure-mode . paredit-mode)
  ;; :config
  ;; (add-hook 'clojure-mode-hook 'paredit-mode)
  ;; (evil-define-key 'normal clojure-mode-map (kbd "RET") 'cider-eval-defun-at-point)
  )

(use-package cider
  :custom
  ;; NOTE: to see the doc from Java, e.g. StringBuilder, InputStream
  (cider-enrich-classpath t)
  (cider-completion-annotations-include-ns 'always)
  :config
  ;; NOTE: when typing .get, the popup for chosing the class for the doc will be popped up.
  ;; which is annoying. Disable it completely and find a better solution later.
  (advice-add 'cider-class-choice-completing-read
              :around
              (lambda (f a b)
		nil
		))
  (defun custom-eval-user-go ()
    (interactive)
    (save-buffer)
    (cider-interactive-eval (format "(integrant.repl/reset)" (cider-last-sexp))))
  :bind
  (:map cider-mode-map ("C-c k" . #'custom-eval-user-go))
  )


(provide 'init-clojure)

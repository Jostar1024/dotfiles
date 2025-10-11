;; init-cljoure.el -*- lexical-binding: t; -*-


(use-package clj-refactor
  :ensure t
  :after (clojure-mode cider)
  :hook (clojure-mode . clj-refactor-mode)
  :config
  (defun my-clojure-mode-hook ()
    (clj-refactor-mode 1)
    (yas-minor-mode 1) ; for adding require/use/import statements
    (cljr-add-keybindings-with-prefix "C-c C-a"))

  (add-hook 'clojure-mode-hook #'my-clojure-mode-hook)
  )

(use-package clojure-mode
  :custom
  (clojure-toplevel-inside-comment-form t))

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
  (:map cider-mode-map
	("C-c k" . #'custom-eval-user-go)
	("C-c <RET>" . #'cider-eval-defun-at-point)
	))

(provide 'init-clojure)

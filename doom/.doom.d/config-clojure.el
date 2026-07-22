;;; ../.dotfiles/doom/.doom.d/config-clojure.el -*- lexical-binding: t; -*-

(use-package! clojure-ts-mode
  :custom
  (clojure-toplevel-inside-comment-form t)
  (clojure-ts-align-forms-automatically t)
  :hook
  (clojure-mode . paredit-mode)
  (clojure-ts-mode-local-vars-hook . cider-mode)
  (clojure-ts-clojurescript-mode-local-vars-hook . cider-mode)
  (clojure-ts-clojurescript-mode . (lambda ()
                                     (setq-local indent-region-function #'clojure-ts-indent-region)))
  :config
  (evil-define-key 'normal clojure-mode-map (kbd "RET") 'cider-eval-defun-at-point)
  (+clojure-common-config '(clojure-ts-mode clojure-ts-clojurescript-mode))
  (map! :map clojure-mode-map
        :localleader
        :n "a" #'clojure-align))

(use-package! cider-mode
  :custom
  ;; NOTE: to see the doc from Java, e.g. StringBuilder, InputStream
  (cider-enrich-classpath t)
  :config
  (defun custom-eval-user-go ()
    (interactive)
    (save-buffer)
    (cider-interactive-eval (format "(integrant.repl/reset)" (cider-last-sexp))))

  (map! :map cider-mode-map
        :localleader
        :n "k" #'custom-eval-user-go)
  )

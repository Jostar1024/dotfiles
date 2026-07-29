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

;; https://emacsredux.com/blog/2026/07/25/cider-and-projectile-meet-embark/
(defun my-cider-embark-doc (sym)
  (interactive "sClojure symbol: ")
  (cider-doc-lookup sym))

(defun my-cider-embark-find-def (sym)
  (interactive "sClojure symbol: ")
  (cider-find-var nil sym))

(defun my-cider-embark-fn-refs (sym)
  (interactive "sClojure symbol: ")
  (cider-xref-fn-refs nil sym))

(defun my-cider-embark-inspect (sym)
  (interactive "sClojure symbol: ")
  (cider-inspect-expr sym (cider-current-ns)))

(defun my-cider-embark-clojuredocs (sym)
  (interactive "sClojure symbol: ")
  (cider-clojuredocs-lookup sym))

(defun my-cider-embark-apropos (sym)
  (interactive "sClojure symbol: ")
  (cider-apropos sym))

(defvar my-cider-embark-symbol-map
  (let ((map (make-sparse-keymap)))
    (define-key map "d" #'my-cider-embark-doc)
    (define-key map "." #'my-cider-embark-find-def)
    (define-key map "r" #'my-cider-embark-fn-refs)
    (define-key map "i" #'my-cider-embark-inspect)
    (define-key map "c" #'my-cider-embark-clojuredocs)
    (define-key map "a" #'my-cider-embark-apropos)
    map))

(defun my-cider-embark-target ()
  (when (derived-mode-p 'clojure-mode 'clojurescript-mode 'clojurec-mode
                        'clojure-ts-mode 'cider-repl-mode)
    (when-let* ((bounds (bounds-of-thing-at-point 'symbol))
                (sym (cider-symbol-at-point)))
      (unless (string-empty-p sym)
        `(cider-clojure-symbol ,sym . ,bounds)))))

(with-eval-after-load 'embark
  (add-to-list 'embark-target-finders #'my-cider-embark-target)
  (add-to-list 'embark-keymap-alist '(cider-clojure-symbol my-cider-embark-symbol-map))
  (add-to-list 'embark-keymap-alist '(cider my-cider-embark-symbol-map)))

(provide 'init-clojure)

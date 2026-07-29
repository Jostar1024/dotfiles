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

;; NOTE: https://emacsredux.com/blog/2026/07/25/cider-and-projectile-meet-embark/
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

(after! embark
  (add-to-list 'embark-target-finders #'my-cider-embark-target)
  (add-to-list 'embark-keymap-alist '(cider-clojure-symbol my-cider-embark-symbol-map))
  (add-to-list 'embark-keymap-alist '(cider my-cider-embark-symbol-map)))

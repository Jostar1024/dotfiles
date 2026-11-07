;;; ../.dotfiles/doom/.doom.d/config-clojure.el -*- lexical-binding: t; -*-

(use-package! clojure-mode
  :custom
  (clojure-toplevel-inside-comment-form t)
  (clojure-align-forms-automatically t)
  :config
  (evil-define-key 'normal clojure-mode-map (kbd "RET") 'cider-eval-defun-at-point)
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

(use-package! cider
  :defer t
  :init
  ;; `:config' and `after!' bodies are not byte-compiled, so define it here.
  (defun my-cider-save-load-run-ns-tests ()
    "Save the buffer, reload its namespace, then run its ns tests.

     ClojureScript only.  `cider-load-buffer' does not load a namespace in a
     cljs REPL.  The call chain is:

       `cider-load-buffer' sends an nREPL `load-file' request.
       piggieback gives the cljs session's `load-file' to `do-load-file'.
       `do-load-file' calls `load-source'.
       `load-source' calls `cljs.repl/load-stream'.
       `load-stream' evaluates the file's forms one by one with
       `evaluate-form', and never loads their dependencies.

     So `(ns cl-03.event-test (:require [reagent.core ...]))' only compiles
     into `goog.require' calls.  Those modules never entered the runtime, so
     each call fails with \"goog.require could not find: ...\".  A `require'
     loads the whole dependency chain instead.

     The namespace alone is reloaded by default.  With a prefix argument its
     dependencies are reloaded too.  Use that after you edit a source
     namespace."
    (interactive)
    ;; Two requests on one session.  nREPL runs a session's requests in order,
    ;; so the tests see the code that was just reloaded.
    (save-buffer)
    (cider-interactive-eval
     (format "(require '%s :%s)"
             (cider-current-ns)
             (if current-prefix-arg "reload-all" "reload")))
    (cider-test-run-ns-tests nil))

  (defun my-cider-test-rect-newline (fn &rest args)
    "Call FN with `insert-rectangle' adding a trailing newline."
    (let ((orig (symbol-function 'insert-rectangle)))
      (cl-letf (((symbol-function 'insert-rectangle)
                 (lambda (&rest rect-args)
                   (prog1 (apply orig rect-args)
                     (insert "\n")))))
        (apply fn args))))
  :config
  ;; CIDER's test report puts expected/actual on one line. The local `insert-rect'
  ;; in `cider-test-render-assertion' ends with `(beginning-of-line)', so the next
  ;; label lands before the value it follows. Upstream bug, present since 2018.
  ;; Drop the advice once CIDER fixes it.
  (require 'rect)                       ; `insert-rectangle' is an autoload
  (advice-add 'cider-test-render-report :around #'my-cider-test-rect-newline)
  (map! :map cider-mode-map
        :localleader
        :desc "Save, load, run ns tests"
        ;; Multi-key form on purpose. A `(:prefix ("t" . "test") ...)' group
        ;; rebinds the whole "t" prefix in this keymap and drops Doom's own
        ;; SPC m t {a,l,n,p,r,s,t} bindings.
        "t e" #'my-cider-save-load-run-ns-tests))

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

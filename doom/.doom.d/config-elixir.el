;;; ../dotfiles/doom/config-elixir.el -*- lexical-binding: t; -*-

(defface +elixir-dim-face
  '((((class color) (background dark))
     (:foreground "grey60"))
    (((class color) (background light))
     (:foreground "grey40")))
  "Elixir dim face.")

(use-package! elixir-mode
  :init
  ;; Disable default smartparens config. There are too many pairs; we only want
  ;; a subset of them (defined below).
  (provide 'smartparens-elixir)
  :mode
  (("\\.eex\\'" . web-mode)
   ("\\.leex\\'" . web-mode)
   ("\\.sface\\'" . web-mode))
  ;; :bind
  ;; (:map elixir-mode-map
  ;;  ("C-c C-f" . 'elixir-format))
  :config
  (font-lock-add-keywords 'elixir-mode
                          '(("\\([_a-zA-Z0-9!?]+\\):" 1 'default)
                            (":[_a-zA-Z0-9\"!?]+" . font-lock-constant-face)
                            ("defmacro \\([a-zA-Z0-9!?_]+\\)" 1 font-lock-function-name-face)
                            ("\\_<@[_a-zA-Z0-9!?]+\\_>" . 'default)
                            ("\\_<true\\_>" . font-lock-constant-face)
                            ("\\_<false\\_>" . font-lock-constant-face)
                            ("\\_<nil\\_>" . font-lock-constant-face)
                            ("\\_<_[a-zA-Z0-9]*\\_>" . '+elixir-dim-face)))

  ;; ...and only complete the basics
  (sp-with-modes 'elixir-mode
    (sp-local-pair "do" "end"
                   :when '(("RET" "<evil-ret>"))
                   :unless '(sp-in-comment-p sp-in-string-p)
                   :post-handlers '("||\n[i]"))
    (sp-local-pair "do " " end" :unless '(sp-in-comment-p sp-in-string-p))
    (sp-local-pair "fn " " end" :unless '(sp-in-comment-p sp-in-string-p)))

  (modify-syntax-entry ?& "'" elixir-mode-syntax-table)
  (add-hook 'elixir-mode-hook 'poly-elixir-mode)
  (map! :after elixir-mode
        :map elixir-mode-map
        :localleader
        :n "f" #'elixir-format
        :n "t" #'+elixir-test-current-file
        :n "d" #'lsp-ui-doc-glance
        :n "c c" #'inf-iex-eval
        :n "c v" #'inf-iex-toggle-send-target)
  )



(use-package! inf-iex
  :hook
  (elixir-mode . inf-iex-minor-mode)
  :init
  (evil-set-initial-state 'inf-iex-tracer-mode 'motion))

;; (defun +toggle-ex-leex ()
;;   (interactive)
;;   (cond
;;    ((string-suffix-p ".ex" (buffer-file-name))
;;     (find-file (string-replace ".ex" ".html.leex" (buffer-file-name))))
;;    ((string-suffix-p ".html.leex" (buffer-file-name))
;;     (let ((sym (thing-at-point 'symbol)))
;;       (find-file (string-replace ".html.leex" ".ex" (buffer-file-name)))
;;       (when sym
;;         (let (pos)
;;           (save-mark-and-excursion
;;             (goto-char (point-min))
;;             (setq pos (re-search-forward (format "\"%s\"" (regexp-quote sym)) nil t)))
;;           (when pos (goto-char pos) (recenter))))))
;;    (t
;;     (error "File extension is neither .ex nor .html.leex"))))

;; (define-key elixir-mode-map (kbd "C-c C-q") '+toggle-ex-leex)
;; (define-key web-mode-map (kbd "C-c C-q") '+toggle-ex-leex)

;; (defun +toggle-ex-leex ()
;;   (interactive)
;;   (cond
;;    ((string-suffix-p ".ex" (buffer-file-name))
;;     (find-file (string-replace ".ex" ".html.leex" (buffer-file-name))))
;;    ((string-suffix-p ".html.leex" (buffer-file-name))
;;     (let ((sym (thing-at-point 'symbol)))
;;       (find-file (string-replace ".html.leex" ".ex" (buffer-file-name)))
;;       (when sym
;;         (re-search-forward (regexp-quote sym) nil t))
;;       (recenter)))
;;    (t
;;     (error "File extension is neither .ex nor .html.leex"))))

(require 'dash)

(defun +elixir-test-current-file ()
  (interactive)
  (let* ((str-list             (split-string (projectile-project-root) "\/"))
         (trimed-list          (-remove (lambda (x) (string= x "")) str-list))
         (dropped              (length trimed-list))
         (filename-list        (split-string (buffer-file-name) "\/"))
         (filename-trimed-list (-remove (lambda (x) (string= x "")) filename-list))
         (filename             (mapconcat 'identity (-drop dropped filename-trimed-list) "\/")))
    (inf-iex--tmux-send (concat "mix test " filename))))

(defun +copy-file-name ()
  (interactive)
  (kill-new (buffer-file-name))
  )
;; elixir should have a cider-doc
;; (defun cider-doc (&optional arg)
;;   "Open Clojure documentation in a popup buffer.

;; Prompts for the symbol to use, or uses the symbol at point, depending on
;; the value of `cider-prompt-for-symbol'.  With prefix arg ARG, does the
;; opposite of what that option dictates."
;;   (interactive "P")
;;   (cider-ensure-connected)
;;   (funcall (cider-prompt-for-symbol-function arg)
;;            "Doc for"
;;            #'cider-doc-lookup))

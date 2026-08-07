;;; ../dotfiles/doom/config-elixir.el -*- lexical-binding: t; -*-

(after! quickrun
  (quickrun-add-command "elixir"
    `((:command . "mix")
      (:exec . ,(lambda ()
                  (setq quickrun-option-default-directory (doom-project-root))
                  "%c run %d/%s"))
      (:tempfile . nil)
      (:description . "Run Elixir script with mix run"))
    :default "elixir"))

(use-package! elixir-ts-mode
  :init
  ;; Disable default smartparens config. There are too many pairs; we only want
  ;; a subset of them (defined below).
  (provide 'smartparens-elixir)
  :hook
  (elixir-ts-mode . my/elixir-ts-map-keys-as-default)

  ;; When press `g d` to jump to definition with ctags, for example Ecto.Query|, it wants me to select from a list of *.Query. 
  ;; The issue is that Emacs's thing-at-point 'symbol doesn't include . - it treats it as punctuation. So when cursor is on Query, +lookup/definition only grabs Query.
  ;; Fix: make . a symbol constituent in elixir-ts-mode. 
  ;; "_" means "symbol constituent" (not word constituent), so:
  ;; - thing-at-point 'symbol on Query in Ecto.Query → grabs Ecto.Query
  ;; - gd works without selection
  ;; - w/e/b word motions are unaffected (they use word class, not symbol)
  ;; - */# search will match the full Ecto.Query
  (elixir-ts-mode . (lambda () (modify-syntax-entry ?. "_")))
  :config
  (defface my-elixir-unused-variable
    '((t :inherit shadow))
    "Face for unused variables (prefixed with _) in Elixir."
    :group 'elixir-ts)
  (defun my/elixir-ts-map-keys-as-default ()
    (when (treesit-ready-p 'elixir)
      (setq-local treesit-font-lock-feature-list
                  (let ((base (copy-sequence treesit-font-lock-feature-list)))
                    (setf (nth 0 base)
                          (append (nth 0 base)
                                  '(my/unused-var
                                    my/map-key-default
                                    my/map-key-default-2
                                    my/keyword-key-default)))
                    base))

      (setq-local treesit-font-lock-level (max 4 (or treesit-font-lock-level 4)))

      (setq-local treesit-font-lock-settings
                  (append treesit-font-lock-settings
                          (treesit-font-lock-rules
                           ;; _vars get shadow face instead
                           :language 'elixir
                           :feature 'my/unused-var
                           :override t
                           '(((identifier) @my-elixir-unused-variable
                              (:match "^_[a-z]\\|^_$" @my-elixir-unused-variable)))

                           ;; 1) 关键词语法：%{a: b, c: d}
                           :language 'elixir
                           :feature 'my/map-key-default
                           :override t
                           '((map
                              (map_content
                               (keywords (pair key: (keyword) @default)))))

                           ;; 2) => 语法：%{:a => :b, "c" => :d}
                           ;;    只把左侧 key 的 atom 设为 default，不影响右侧
                           :language 'elixir
                           :feature 'my/map-key-default-2
                           :override t
                           '((map
                              (map_content
                               (binary_operator
                                left: (atom) @default
                                operator: "=>"
                                right: (_)))))

                           :language 'elixir
                           :feature 'my/keyword-key-default
                           :override t
                           '((keywords (pair key: (keyword) @default))))))
      (treesit-font-lock-recompute-features)
      (font-lock-flush)))

  ;; ...and only complete the basics
  (sp-with-modes 'elixir-ts-mode
    (sp-local-pair "do" "end"
                   :when '(("RET" "<evil-ret>"))
                   :unless '(sp-in-comment-p sp-in-string-p)
                   :post-handlers '("||\n[i]"))
    (sp-local-pair "do " " end" :unless '(sp-in-comment-p sp-in-string-p))
    (sp-local-pair "fn " " end" :unless '(sp-in-comment-p sp-in-string-p)))
  (evil-define-key '(normal visual) elixir-ts-mode-map (kbd "RET") '+iex-eval-overlay)
  ;; (defun +drop-db ()
  ;;   (interactive)
  ;;   (let*
  ;;       (env (read-from-minibuffer "Environment: " "dev"))
  ;;     (projectile-run-async-shell-command-in-root "mix ecto.drop && mix ecto.create && mix ecto.migrate")))
  (defun +update-deps ()
    (interactive)
    (projectile-run-async-shell-command-in-root "mix deps.get"))
  (map! :after elixir-ts-mode
        :map elixir-ts-mode-map
        :localleader
        :n "f" #'elixir-format
        :n "g" #'+update-deps
        :n "d" #'lsp-ui-doc-glance
        :n "D" #'+iex-doc
        :n "c c" #'inf-iex-eval
        :n "c e" #'+iex-eval-overlay
        :n "c i" #'+iex-inspect-last-result
        :n "c v" #'inf-iex-toggle-send-target
        :n "i" #'lsp-ui-imenu)
  )

(use-package! inf-iex
  :hook
  (elixir-ts-mode . inf-iex-minor-mode)
  :init
  (evil-set-initial-state 'inf-iex-tracer-mode 'motion))

;;; IEx eval with inline overlay (eros-style)

(defvar +iex-last-result nil
  "The last evaluation result string from IEx.")

(defvar +iex--eval-proc nil)
(defvar +iex--eval-src-buf nil)
(defvar +iex--eval-end-pos nil)
(defvar +iex--eval-output "")
(defvar +iex--eval-orig-filter nil)
(defvar +iex--eval-timeout-timer nil)

(defun +iex--eval-cleanup ()
  "Restore process filter and clear eval capture state."
  (when +iex--eval-timeout-timer
    (cancel-timer +iex--eval-timeout-timer)
    (setq +iex--eval-timeout-timer nil))
  (when (and +iex--eval-proc
             (process-live-p +iex--eval-proc)
             +iex--eval-orig-filter)
    (set-process-filter +iex--eval-proc +iex--eval-orig-filter))
  (setq +iex--eval-proc nil
        +iex--eval-src-buf nil
        +iex--eval-end-pos nil
        +iex--eval-output ""
        +iex--eval-orig-filter nil))

(defun +iex--strip-ansi (str)
  "Strip all ANSI escape sequences from STR."
  (replace-regexp-in-string "\033\\[[0-9;]*[a-zA-Z]" "" str))

(defun +iex--eval-process-filter (proc output)
  "Capture IEx output, pass to comint, show overlay on prompt."
  (when +iex--eval-orig-filter
    (funcall +iex--eval-orig-filter proc output))
  (setq +iex--eval-output (concat +iex--eval-output output))
  (let ((clean (+iex--strip-ansi +iex--eval-output)))
    (when (string-match "\niex([0-9]+)>[ \t]*\\'" clean)
      (let* ((without-prompt (substring clean 0 (match-beginning 0)))
             ;; Strip echoed input (first line) and \r
             (result (if (string-match "\\`[^\n]*\n" without-prompt)
                         (substring without-prompt (match-end 0))
                       without-prompt))
             (result (string-trim (replace-regexp-in-string "\r" "" result))))
        (setq +iex-last-result result)
        (when (and (buffer-live-p +iex--eval-src-buf)
                   (not (string-empty-p result)))
          (with-current-buffer +iex--eval-src-buf
            (let ((this-command '+iex-eval-overlay))
              (eros--make-result-overlay result
                :where +iex--eval-end-pos
                :duration eros-eval-result-duration))))
        (message "%s" result))
      (+iex--eval-cleanup))))

(defun +iex-eval-overlay ()
  "Eval region or current line in IEx and show result as inline overlay."
  (interactive)
  (unless (inf-iex--get-process)
    (user-error "No IEx process running for this project"))
  (+iex--eval-cleanup)
  (let* ((raw (inf-iex--get-code-to-eval))
         (code (inf-iex--format-eval-code raw))
         (proc (inf-iex--get-process)))
    (setq +iex--eval-proc proc
          +iex--eval-src-buf (current-buffer)
          +iex--eval-end-pos (if (region-active-p) (region-end) (line-end-position))
          +iex--eval-output ""
          +iex--eval-orig-filter (process-filter proc))
    (set-process-filter proc #'+iex--eval-process-filter)
    (setq +iex--eval-timeout-timer
          (run-at-time 5 nil (lambda ()
                               (message "IEx eval timed out")
                               (+iex--eval-cleanup))))
    (comint-send-string proc (format "%s\n" code))))

(defun +iex-inspect-last-result ()
  "Show the last IEx eval result in a dedicated buffer."
  (interactive)
  (unless +iex-last-result
    (user-error "No IEx result to inspect"))
  (let ((buf (get-buffer-create "*IEx Result*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert +iex-last-result)
        (goto-char (point-min)))
      (special-mode)
      (setq-local face-remapping-alist '((default . fixed-pitch))))
    (pop-to-buffer buf)))

(defun +iex-doc (symbol)
  "Fetch docs for SYMBOL from the running IEx REPL and display in a buffer."
  (interactive
   (list (let ((default (thing-at-point 'symbol)))
           (read-string (format "IEx doc (default %s): " default) nil nil default))))
  (unless (inf-iex--get-process)
    (user-error "No IEx process running for this project"))
  (let* ((cmd (format "h %s" symbol))
         (output (inf-iex--send-string-async cmd))
         (buf (get-buffer-create "*IEx Doc*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert (string-trim output))
        (goto-char (point-min)))
      (special-mode))
    (pop-to-buffer buf)))

(defun +iex-doc-lookup (identifier)
  "Lookup docs via IEx REPL for K binding. Returns non-nil if handled."
  (when (inf-iex--get-process)
    (+iex-doc identifier)
    t))

(add-hook 'elixir-ts-mode-hook
          (lambda () (add-hook '+lookup-documentation-functions #'+iex-doc-lookup -10 t)))

;; Embark integration
(defun +iex-embark-doc (sym)
  (interactive "sElixir symbol: ")
  (+iex-doc sym))

(defun +iex-embark-target ()
  (when (derived-mode-p 'elixir-ts-mode)
    (when-let ((bounds (bounds-of-thing-at-point 'symbol))
               (sym (thing-at-point 'symbol)))
      `(iex-elixir-symbol ,sym . ,bounds))))

(after! embark
  (add-to-list 'embark-target-finders #'+iex-embark-target)
  (defvar +iex-embark-symbol-map
    (let ((map (make-composed-keymap nil embark-identifier-map)))
      (define-key map "d" #'+iex-embark-doc)
      map))
  (add-to-list 'embark-keymap-alist '(iex-elixir-symbol . +iex-embark-symbol-map)))

(defun +copy-file-name ()
  (interactive)
  (kill-new (buffer-file-name)))

(use-package! exunit
  :hook (elixir-ts-mode . exunit-mode)
  :init
  (map! :after elixir-ts-mode
        :localleader
        :map elixir-ts-mode-map
        "m" #'exunit-transient)

  (map! :after elixir-ts-mode
        :localleader
        :map elixir-ts-mode-map
        :prefix ("t" . "test")
        "a" #'exunit-verify-all
        "r" #'exunit-rerun
        "v" #'exunit-verify
        "T" #'exunit-toggle-file-and-test
        "t" #'exunit-toggle-file-and-test-other-window
        "s" #'exunit-verify-single))

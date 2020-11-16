;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yucheng"
      user-mail-address "howard.eureka@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; (use-package lsp-mode
;;   :hook
;;   ((rust-mode c-mode elixir-mode) . lsp-deferred)
;;   :commands
;;   (lsp lsp-deferred)
;;   :custom
;;   (lsp-completion-provider :capf)
;;   (lsp-enable-file-watchers nil)
;;   (lsp-keymap-prefix "C-l")
;;   (lsp-enable-symbol-highlighting nil)
;;   (lsp-lens-enable nil)
;;   (lsp-headerline-breadcrumb-enable nil)
;;   (lsp-modeline-code-actions-enable nil)
;;   (lsp-signature-auto-activate t)
;;   (lsp-modeline-diagnostics-enable nil)
;;   (lsp-signature-render-documentation nil)
;;   (lsp-completion-show-detail nil)
;;   (lsp-completion-show-kind t)
;;   (lsp-clients-elixir-server-executable "/home/yucheng/projects/elixir-ls/release/language_server.sh"))

(use-package eglot
  :bind
  (:map eglot-mode-map ("M-." . '+lsp-xfind-or-dumb-jump))
  :hook
  ((rust-mode c-mode elixir-mode) . eglot-ensure)
  :custom
  (eglot-ignored-server-capabilites '(:documentHighlightProvider))
  :config
  (add-to-list 'eglot-server-programs '(elixir-mode "/home/yucheng/projects/elixir-ls/release/language_server.sh")))

(defun +copy-to-clipboard ()
  (interactive)
  (let ((s (buffer-substring-no-properties (region-beginning) (region-end))))
    (async-shell-command  (format "echo %s | clip.exe" (prin1-to-string s)))))

;; (use-package nox
;;   :hook
;;   ((rust-mode c-mode elixir-mode) . nox-ensure)
;;   :bind
;;   (:map nox-mode-map
;;    ("M-f" . nox-show-doc)
;;    ("M-h" . nox-show-signature))
;;   :custom-face
;;   (highlight . (((t (:background "red")))))

;;   :config
;;   (add-to-list 'nox-server-programs '(elixir-mode "/home/yucheng/projects/elixir-ls/release/language_server.sh")))


(setq eldoc-idle-delay most-positive-fixnum)
(global-set-key (kbd "C-c C-f") 'eldoc)

(defface +elixir-dim-face
  '((((class color) (background dark))
     (:foreground "grey60"))
    (((class color) (background light))
     (:foreground "grey40")))
    "Elixir dim face.")

;; paste code from external
;; https://stackoverflow.com/questions/18691973/is-there-a-set-paste-option-in-emacs-to-paste-paste-from-external-clipboard?spm=a2c4e.10696291.0.0.111219a4sTbBnB
(defvar ttypaste-mode nil)
(add-to-list 'minor-mode-alist '(ttypaste-mode " Paste"))

(defun ttypaste-mode ()
  (interactive)
  (let ((buf (current-buffer))
        (ttypaste-mode t))
    (with-temp-buffer
      (let ((stay t)
            (text (current-buffer)))
        (redisplay)
        (while stay
          (let ((char (let ((inhibit-redisplay t)) (read-event nil t 0.1))))
            (unless char
              (with-current-buffer buf (insert-buffer-substring text))
              (erase-buffer)
              (redisplay)
              (setq char (read-event nil t)))
            (cond
             ((not (characterp char)) (setq stay nil))
             ((eq char ?\r) (insert ?\n))
             ((eq char ?\e)
              (if (sit-for 0.1 'nodisp) (setq stay nil) (insert ?\e)))
             (t (insert char)))))
                (insert-buffer-substring text)))))

(use-package! elixir-mode
  :mode
  (("\\.eex\\'" . web-mode)
   ("\\.leex\\'" . web-mode))
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

  (modify-syntax-entry ?& "'" elixir-mode-syntax-table))

(use-package! company
  :bind
  (:map
   company-active-map
   ("<tab>" . 'company-complete-selection)
   ("TAB" . 'company-complete-selection)
   ("RET")
   ("<return>")
   ("SPC")
   :map
   company-template-nav-map
   ("RET" . 'company-template-forward-field)
   ("<return>" . 'company-template-forward-field)
   ("TAB")
   ("<tab>"))
  :init
  (require 'company-template)
  :hook
  ((prog-mode . company-mode)
   (conf-mode . company-mode)
   (eshell-mode . company-mode))
  :custom
  (company-tng-auto-configure nil)
  (company-frontends '(company-tng-frontend
                       company-pseudo-tooltip-frontend
                       company-echo-metadata-frontend))
  (company-begin-commands '(self-insert-command))
  (company-idle-delay 0.01)
  (company-tooltip-limit 10)
  (company-tooltip-align-annotations t)
  (company-tooltip-offset-display 'lines)
  (company-tooltip-width-grow-only t)
  (company-tooltip-idle-delay 0.1)
  (company-minimum-prefix-length 3)
  (company-dabbrev-downcase nil)
  (company-abort-manual-when-too-short t)
  (company-require-match nil)
  (company-global-modes '(not dired-mode dired-sidebar-mode))
  (company-tooltip-margin 0))

(use-package! inf-iex
  :hook
  (elixir-mode . inf-iex-minor-mode)
  :init
  (evil-set-initial-state 'inf-iex-tracer-mode 'motion))

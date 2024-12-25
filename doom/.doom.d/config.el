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
(setq doom-theme 'doom-zenburn)

;; (setq doom-font (font-spec :family "JetBrains Mono" :size 10)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 9))

;; (setq +my-cnfont-size 26)
;; (setq +my-ascii-size 22)

;; for thinkpad's screen
;; (setq +my-cnfont-size 44)
;; (setq +my-ascii-size 36)

(setq +my-cnfont-size 20)
(setq +my-ascii-size 16)
(setq +my-ascii-font "Jetbrains Mono")
(setq +my-cnfont "LXGW Wenkai Mono")

(setq doom-font                (font-spec :family +my-ascii-font :size +my-ascii-size)
      doom-variable-pitch-font (font-spec :family +my-ascii-font :size +my-ascii-size)
      doom-symbol-font         (font-spec :family +my-cnfont :size +my-cnfont-size)
      doom-serif-font          (font-spec :family +my-cnfont :size +my-cnfont-size)
      doom-big-font            (font-spec :family +my-ascii-font :size +my-ascii-size))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org")
(setq org-agenda-files (directory-files-recursively "~/org/" "\\.org$"))

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

(setq eldoc-idle-delay most-positive-fixnum)
(global-set-key (kbd "C-c C-f") 'eldoc)

(when (eq system-type 'darwin)
  (setq mac-option-modifier 'none))

(setq auto-save-default nil)
(setq auto-save-interval 5000)
(setq auto-save-timeout (* 10 60))

;; (load! "config-company")
(load! "config-elixir")
(load! "config-clojure")
(load! "config-lsp")
;; (load! "config-wsl")
(load! "config-ligature")
(load! "config-key-binding")
(load! "config-org")
(load! "config-prolog")
(load! "config-janet")

(use-package! rime
  :config
  (when (eq system-type 'darwin)
    (setq rime-share-data-dir "~/Library/Rime"))

  :custom
  (default-input-method "rime")
  (rime-show-candidate 'minibuffer)
  (rime-librime-root "~/.nix-profile")

  (map! :map rime-mode-map
        "C-`" #'rime-send-keybinding)
  )

;; (setq rime-disable-predicates '(rime-predicate-evil-mode-p))
;; (setq rime-inline-predicates '(rime-predicate-space-after-cc-p))

(use-package! web-mode
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-style-padding 2)
  (web-mode-script-padding 2)
  (web-mode-enable-current-element-highlight t)
  (web-mode-enable-current-column-highlight t))

(use-package! evil-snipe
  :custom
  (evil-snipe-spillover-scope 'buffer))

(use-package! dired
  :custom
  (dired-dwim-target t))

(use-package! projectile
  :config
  (setq projectile-project-root-files #'( ".projectile" ))
  (setq projectile-project-root-files-functions #'(projectile-root-top-down
                                                   projectile-root-top-down-recurring
                                                   projectile-root-bottom-up
                                                   projectile-root-local)))
;; (use-package! zig-mode
;;   :hook ((zig-mode . lsp-deferred))
;;   :custom (zig-format-on-save nil)
;;   :config
;;   (after! lsp-mode
;;     (add-to-list 'lsp-language-id-configuration '(zig-mode . "zig"))
;;     (lsp-register-client
;;       (make-lsp-client
;;         :new-connection (lsp-stdio-connection "/usr/bin/zls")
;;         :major-modes '(zig-mode)
;;         :server-id 'zls))))
(map! :i "<f9>" 'insert-parentheses)

(use-package! rime
  :config
  (setq rime-disable-predicates
        '(rime-predicate-evil-mode-p
          rime-predicate-space-after-cc-p
          rime-predicate-after-alphabet-char-p
          rime-predicate-prog-in-code-p)))


(set-formatter! 'sql '("pg_format") :modes '(sql-mode))
(set-formatter! 'protobuf '("clang-format" "-") :modes '(protobuf-mode))

(use-package! prolog
  :config
  (setq prolog-system 'swi
        prolog-program-switches '((swi ("-G128M" "-T128M" "-L128M" "-O"))
                                  (t nil))
        prolog-electric-if-then-else-flag t)
  )

(use-package! gptel
  :config
  (setq gptel-model   'deepseek-chat
        gptel-backend
        (gptel-make-openai "DeepSeek"
          :host "api.deepseek.com"
          :endpoint "/chat/completions"
          :stream t
          :key (getenv "DEEPSEEK_APIKEY")
          :models '(deepseek-chat deepseek-coder)))
  (map! :leader
        (:prefix ("a" . "gptel - AI")
         :desc "GPTel buffer" :n "a" #'gptel
         :desc "GPTel Send" :n "s" #'gptel-send
         :desc "GPTel Menu" :n "S" #'gptel-menu
         :desc "GPTel Abort" :n "b" #'gptel-abort)))

(use-package! smartparens
  :config
  (map! :map smartparens-mode-map
        :leader (:prefix ("l" . "Lisps")
                 :nvie "f" #'sp-slurp-hybrid-sexp
                 ;; :nvie "b" #'sp-backward-sexp
                 ;; :nvim "u" #'sp-unwrap-sexp
                 ;; :nie "k" #'sp-kill-sexp
                 ;; :nie "s" #'sp-split-sexp
                 ;; :nie "(" #'sp-wrap-round
                 ;; :nie "[" #'sp-wrap-square
                 ;; :nie "{" #'sp-wrap-curly
                 )))

(after! nix-mode
  (set-formatter! 'alejandra '("alejandra" "--quiet") :modes '(nix-mode)))

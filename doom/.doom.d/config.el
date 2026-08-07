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
(load! "config-modus-tonsky")
(setq doom-theme 'modus-tonsky-light)

;; Font sizes are glyph HEIGHTS, not widths.  What decides whether markdown
;; tables (e.g. in the pi-coding-agent chat buffer) line up is the drawn
;; ADVANCE width of each glyph versus the number of columns Emacs reserves:
;;
;;   JetBrains Mono at 16px height -> 10px advance width (it is a 0.6em-wide font)
;;   a CJK monospace font's advance == its height, so 20px -> 20px advance width
;;
;; How to measure the real drawn pixels?
;; (string-pixel-width "M")  => 10
;; (string-pixel-width "中") => 20   
;; (frame-char-width) => 10 ; (the width of one grid cell)
;; 
;; (pp (font-info (face-attribute 'default :font)) 
;; inspect the font at cursor C-u C-x = => what-cursor-position
;; 
(setq +my-cnfont-size 20) ;; height = 20px, width = 20px
(setq +my-ascii-size 16)  ;; height = 16px, width = 10px for Jetbrains Mono
(setq +my-ascii-font "Jetbrains Mono")
(setq +my-cnfont "LXGW WenKai Mono")

(setq doom-font                (font-spec :family +my-ascii-font :size +my-ascii-size)
      doom-variable-pitch-font (font-spec :family +my-ascii-font :size +my-ascii-size)
      ;; `doom-symbol-font' covers the `symbol' and `mathematical' charsets --
      ;; box drawing, arrows, dingbats.
      ;;
      ;; It cannot be JetBrains Mono either.  JetBrains Mono has no glyph for
      ;; some symbols (`\N{BLACK STAR}' U+2605 is missing -- check with
      ;; `fc-list ":charset=2605"'. Menlo ships those glyphs itself at a uniform
      ;; single-cell advance, so nothing falls back and nothing drifts.
      doom-symbol-font         (font-spec :family "Menlo" :size +my-ascii-size)
      ;; `doom-serif-font' is deliberately unset: it only styles the
      ;; `fixed-pitch-serif' face, which no Doom module or installed package
      ;; uses
      doom-big-font            (font-spec :family +my-ascii-font :size +my-ascii-size))

;; Doom has no `doom-cjk-font'.  `doom-symbol-font' does not cover Han/kana, so
;; without the explicit fontset entries below Chinese falls back to a macOS
;; system font sized to the DEFAULT font height (16px -> 16px advance), i.e. 4px
;; short of the 2 columns Emacs reserved.  That is what misaligns tables.
(defun +my/set-cjk-font ()
  "Render CJK glyphs at exactly twice the ASCII advance so tables align."
  (when (display-graphic-p)
    (dolist (charset '(han cjk-misc kana bopomofo))
      (set-fontset-font t charset
                        (font-spec :family +my-cnfont :size +my-cnfont-size)))))

;; Why `after-setting-font-hook' and not plain top-level call:
;;
;; - What must happen first is the APPLICATION of the fonts to the frame.  Doom
;;   does that in `doom-init-fonts-h', hooked at priority -100 onto
;;   `after-init-hook' (or `server-after-make-frame-hook' under a daemon), and
;;   that same function installs Doom's own `set-fontset-font' entries for the
;;   `symbol', `mathematical', `emoji' and Nerd Font ranges before ending with
;;   `(run-hooks 'after-setting-font-hook)'.
;; - Running after that hook therefore guarantees our CJK entries are not
;;   clobbered by Doom's, and they are re-applied on `doom/reload-font'.
;; - Under a daemon it fires when the first graphical frame exists, so
;;   `set-fontset-font' is never called from a frameless init.  The
;;   `display-graphic-p' guard keeps it a no-op in terminal/`-nox' sessions.
(add-hook 'after-setting-font-hook #'+my/set-cjk-font)

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

(setq auto-save-default nil)
(setq auto-save-interval 5000)
(setq auto-save-timeout (* 10 60))

(after! doom-ui
  (remove-hook 'doom-first-buffer-hook #'global-hl-line-mode))

;; (load! "config-company")
(when (eq system-type 'darwin)
  (load! "config-darwin"))

(load! "config-ai")
(load! "config-pi-agent")
(load! "config-key-binding")
(load! "config-treesit")
(load! "config-citre")
(load! "config-org")
(load! "config-completion")

(load! "config-elixir")
(load! "config-web")
(load! "config-clojure")
(load! "config-lsp")
(load! "config-ligature")
(load! "config-prolog")
(load! "config-janet")
(load! "config-markdown")
(load! "config-ghostel")

(use-package! rime
  :config
  (when (eq system-type 'darwin)
    (setq rime-share-data-dir "~/Library/Rime"))
  (map! :map rime-mode-map
        "C-`" #'rime-send-keybinding)

  ;; (setq rime-disable-predicates '(rime-predicate-evil-mode-p))
  ;; (setq rime-inline-predicates '(rime-predicate-space-after-cc-p))
  
  :custom
  (default-input-method "rime")
  (rime-show-candidate 'minibuffer)
  (rime-librime-root "~/.nix-profile"))


(use-package! evil-snipe
  :custom
  (evil-snipe-spillover-scope 'buffer))

(use-package! dired
  :custom
  (dired-dwim-target t))

(use-package! projectile
  :custom
  ;; manually run `projectile-discover-projects-in-search-path` to search the projects inside the following directory
  (projectile-project-search-path '(("~/projects" . 1)
                                    ("~/tubi" . 1)
                                    ("~/community/" . 1)
                                    ("~/expr" . 1)))
  (projectile-auto-discover t)
  (projectile-project-root-functions #'(projectile-root-top-down
                                        projectile-root-top-down-recurring
                                        projectile-root-bottom-up
                                        projectile-root-local)))
(after! projectile
  (add-to-list 'projectile-project-root-files ".projectile")
  (add-to-list 'projectile-project-root-files "mix.exs"))

(use-package! rime
  :config
  (setq rime-disable-predicates
        '(rime-predicate-evil-mode-p
          rime-predicate-space-after-cc-p
          rime-predicate-after-alphabet-char-p
          rime-predicate-prog-in-code-p)))


(after! nix-mode
  (set-formatter! 'alejandra '("alejandra" "--quiet") :modes '(nix-mode)))

(set-formatter! 'sql '("pg_format") :modes '(sql-mode))
(set-formatter! 'protobuf '("clang-format" "-") :modes '(protobuf-mode))

(use-package! prolog
  :config
  (setq prolog-system 'swi
        prolog-program-switches '((swi ("-G128M" "-T128M" "-L128M" "-O"))
                                  (t nil))
        prolog-electric-if-then-else-flag t))

(use-package! smartparens
  :config
  (map! :map smartparens-mode-map
        :leader (:prefix ("l" . "Lisps")
                 :nvie "f" #'sp-slurp-hybrid-sexp
                 :nie "k" #'sp-kill-sexp
                 :nvie "r" #'sp-raise-sexp
                 ;; :nvie "b" #'sp-backward-sexp
                 ;; :nvim "u" #'sp-unwrap-sexp
                 ;; :nie "s" #'sp-split-sexp
                 ;; :nie "(" #'sp-wrap-round
                 ;; :nie "[" #'sp-wrap-square
                 ;; :nie "{" #'sp-wrap-curly
                 )))

(use-package! keyfreq
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1)
  (setq keyfreq-excluded-commands '(self-insert-command
                                    forward-char
                                    backward-char
                                    previous-line
                                    next-line
                                    evil-previous-line
                                    evil-next-line)))
(use-package! magit
  :custom
  ;; NOTE: elixir's mix format in pre-commit hook contains terminal's ANSI colors.
  ;; use this to pretty print
  (magit-process-apply-ansi-colors 't))

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

(setq doom-font (font-spec :family "JetBrains Mono" :size 10)
      doom-variable-pitch-font (font-spec :family "sans" :size 9))

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

;; (load! "config-company")
(load! "config-elixir")
(load! "config-lsp")
(load! "config-wsl")
(load! "config-ligature")

(use-package! rime
  :custom
  (default-input-method "rime")
  (rime-show-candidate 'minibuffer)
  (rime-translate-keybindings '("C-`")))

(let ((font-family "Jetbrains Mono")
      (font-size 10))
  (when (member font-family (font-family-list))
    (set-face-attribute 'default nil :font (format "%s-%d" font-family font-size))))

(let ((cn-font-family "WenQuanYi Micro Hei Mono"))
  (when (member cn-font-family (font-family-list))
    (setq-default face-font-rescale-alist `((,cn-font-family . 1)))
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset
                        (font-spec :family cn-font-family)))))

(use-package! ob-elixir)

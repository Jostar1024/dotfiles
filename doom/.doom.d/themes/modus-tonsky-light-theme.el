;;; modus-tonsky-light-theme.el --- Modus derivative: Tonsky's syntax highlighting principles -*- lexical-binding: t; -*-

;; Author: Yucheng Cao
;; Based on: Tonsky's "A better syntax highlighting" + Modus Themes by Protesilaos
;; URL: https://tonsky.me/blog/syntax-highlighting/

;;; Commentary:

;; A light theme derived from `modus-operandi' that applies Tonsky's
;; minimalist syntax highlighting philosophy:
;;
;;   - Only 4 semantic colors for code (memorizable)
;;   - Green  = strings (with subtle background, per Tonsky's light-theme trick)
;;   - Purple = constants (numbers, booleans -- distinct from strings)
;;   - Yellow = comments (important! read them)
;;   - Warm   = function definitions (file structure at a glance)
;;   - Blue   = variable declarations (where things come from)
;;   - Everything else (keywords, builtins, types) = base text color
;;
;; "If everything is highlighted, nothing is highlighted."

;;; Code:

(require 'modus-themes)

(defvar modus-tonsky-light-palette
  '(;; Semantic mappings: the core of Tonsky's philosophy.
    ;; Keywords, builtins, types: DO NOT highlight.
    (keyword fg-main)
    (builtin fg-main)
    (type fg-main)
    (preprocessor fg-dim)

    ;; Function definitions: warm/bright (gives file structure)
    (fnname yellow-warmer)

    ;; Variable declarations: subtle blue (where does this come from?)
    (variable blue-cooler)

    ;; Strings: green with background (Tonsky's light-theme trick:
    ;; background colors make light themes work with vibrant color)
    (string yello-warmer)

    ;; Constants (numbers, booleans): purple (distinct from strings)
    (constant magenta-cooler)

    ;; Comments: HIGHLIGHTED, not hidden
    (comment yellow-cooler)
    (docstring yellow-faint)
    (docmarkup fg-dim)

    ;; Regex: green family (string-adjacent)
    (rx-construct green-warmer)
    (rx-backslash green-faint))
  "Palette overrides for `modus-tonsky-light'.
Implements Tonsky's 4-color minimalist syntax highlighting.")

(defcustom modus-tonsky-light-palette-overrides nil
  "User overrides for `modus-tonsky-light'.
See `modus-themes-common-palette-overrides' for usage."
  :type '(repeat (list symbol (choice symbol string)))
  :group 'modus-themes)

(defvar modus-tonsky-light-custom-faces
  '(`(font-lock-string-face ((,c :foreground ,string)))
    `(font-lock-comment-face ((,c :foreground ,comment :background ,bg-yellow-nuanced)))
    `(font-lock-comment-face ((,c :foreground ,comment :background ,bg-yellow-nuanced)))
    ;; the emacs-lisp's ;; need this face.
    `(font-lock-comment-delimiter-face ((,c :foreground ,comment :background ,bg-yellow-nuanced)))
    ;; elixir's func call use the following face
    `(font-lock-function-call-face ((,c :foreground ,fg-main)))
    )
  "Custom faces for `modus-tonsky-light'.")

(modus-themes-theme
 'modus-tonsky-light
 'modus-tonsky
 "Modus Operandi + Tonsky's minimalist syntax highlighting (light theme)."
 'light
 'modus-operandi-palette
 'modus-tonsky-light-palette
 'modus-tonsky-light-palette-overrides
 'modus-tonsky-light-custom-faces)

(provide-theme 'modus-tonsky-light)
;;; modus-tonsky-light-theme.el ends here

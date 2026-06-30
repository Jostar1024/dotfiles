;;; init.el --- init of emacs -*- lexical-binding: t; -*-
;;; Commentary:
;;;
;;; Code:

;; https://www.rahuljuliato.com/posts/emacs-cache-paths
(defcustom my/cache-directory
  (expand-file-name "cache/" user-emacs-directory)
  "Base directory for Emacs cache files.
All entries in `my/cache-paths' are resolved relative to this
directory.  Choose one of the presets or supply any custom path.
Changes take effect after restarting Emacs."
  :type `(choice
	  (const     :tag "Inside Emacs config  (cache/ in user-emacs-directory)"
		     ,(expand-file-name "cache/" user-emacs-directory))
	  (const     :tag "System temp          (/tmp/emacs-cache/)" "/tmp/emacs-cache/")
	  (directory :tag "Custom directory"))
  :group 'my)

;; custom-file is already set and loaded in early-init.el, but reload it here
;; so any M-x customize changes saved mid-session before restart also apply
;; to cache paths and other init.el settings.
(load custom-file 'noerror 'nomessage)

(defvar my/cache-paths
  '(;; Files:
    (bookmark-file               . "bookmarks")
    (ielm-history-file-name      . "ielm-history.eld")
    (project-list-file           . "projects")
    (recentf-save-file           . "recentf")
    (savehist-file               . "history")
    (save-place-file             . "saveplace")
    (transient-history-file      . "transient/history.el")
    (transient-levels-file       . "transient/levels.el")
    (transient-values-file       . "transient/values.el")
    (tramp-persistency-file-name . "tramp")
    (nsm-settings-file           . "network-security.data")
    ;; Directories:
    (auto-saves                  . "auto-saves/")
    (auto-saves-sessions         . "auto-saves/sessions/")
    (multisession-directory      . "multisession/")
    (url-configuration-directory . "url/")
    (image-dired-dir             . "image-dired/")
    (erc-log-channels-directory  . "erc/logs/")
    (erc-image-cache-directory   . "erc/images/")
    (rcirc-log-directory         . "rcirc/logs/"))
  "Alist of (KEY . RELATIVE-PATH) for cache locations.
RELATIVE-PATH is resolved against `my/cache-directory'.
A trailing slash on RELATIVE-PATH marks the entry as a directory.")

(defun my/cache--path (key)
  "Return the absolute path for KEY in `my/cache-paths'."
  (let ((rel (cdr (assq key my/cache-paths))))
    (unless rel
      (error "my/cache--path: Unknown key %S" key))
    (expand-file-name rel my/cache-directory)))

(defun my/cache--ensure-dirs ()
  "Create every directory referenced by `my/cache-paths'."
  (dolist (entry my/cache-paths)
    (let* ((abs (my/cache--path (car entry)))
	   (dir (if (directory-name-p abs)
		    abs
		  (file-name-directory abs))))
      (make-directory dir t))))

(my/cache--ensure-dirs)

(use-package emacs
  :ensure nil
  :init
  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)

  ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
  ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete)
  :custom
  (help-window-select t "Switch to help buffers automatically")
  ;; https://github.com/minad/vertico#configuration
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  ;; https://www.rahuljuliato.com/posts/emacs-cache-paths
  (bookmark-file               (my/cache--path 'bookmark-file))
  (ielm-history-file-name      (my/cache--path 'ielm-history-file-name))
  (project-list-file           (my/cache--path 'project-list-file))
  (recentf-save-file           (my/cache--path 'recentf-save-file))
  (savehist-file               (my/cache--path 'savehist-file))
  (save-place-file             (my/cache--path 'save-place-file))
  (transient-history-file      (my/cache--path 'transient-history-file))
  (transient-levels-file       (my/cache--path 'transient-levels-file))
  (transient-values-file       (my/cache--path 'transient-values-file))
  (nsm-settings-file           (my/cache--path 'nsm-settings-file))
  (multisession-directory      (my/cache--path 'multisession-directory))
  (url-configuration-directory (my/cache--path 'url-configuration-directory))
  (create-lockfiles            nil)
  (make-backup-files           nil)
  (auto-save-default           t)
  :config
  (setq auto-save-list-file-prefix (my/cache--path 'auto-saves-sessions)
	auto-save-file-name-transforms
	`((".*" ,(my/cache--path 'auto-saves) t)))
  (setopt tramp-persistency-file-name (my/cache--path 'tramp-persistency-file-name))
  :bind (("M-g TAB" . nil))
  )
(require 'init-ui)
(require 'init-straight)
(require 'init-meow)
(require 'init-modeline)
(require 'init-file)
(require 'init-completion)
(require 'init-minibuffer)
(require 'init-projectile)
(require 'init-elixir)
(require 'init-prolog)
(require 'init-clojure)

(defalias 'yes-or-no-p 'y-or-n-p)

;; (add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
;; (load-theme 'modus-vivendi)
(load-theme 'modus-operandi)

(use-package yasnippet
  :init
  (yas-global-mode))

(use-package smartparens
  :ensure t
  :hook (prog-mode text-mode markdown-mode) ;; add `smartparens-mode` to these hooks
  :config
  ;; load default config
  (require 'smartparens-config)
  (smartparens-global-strict-mode +1)
  :bind
  (:map smartparens-mode-map
	("]" . #'sp-up-sexp)))

(use-package eros
  :ensure t
  :hook
  ((emacs-lisp-mode . eros-mode)))

(use-package org
  :straight
  (:type built-in))

(use-package magit
  :straight (magit :type git :host github :repo "magit/magit" :branch "v4.4.0")
  :init
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :bind (:map magit-mode-map
	      ("x" . magit-discard)
	      ("p" . magit-push))
  )
(use-package apheleia
  :init
  (apheleia-global-mode +1))

(when (eq system-type 'darwin)
  (setq-default mac-option-modifier 'none
                mac-command-modifier 'meta)
  )

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(use-package treesit-langs
  :straight (treesit-langs :type git :host github :repo "emacs-tree-sitter/treesit-langs")
  :config
  (setq major-mode-remap-alist
        '((python-mode      . python-ts-mode)
          (c-mode           . c-ts-mode)
          (c++-mode         . c++-ts-mode)
          (java-mode        . java-ts-mode)
          (js-mode          . js-ts-mode)
          (typescript-mode  . typescript-ts-mode)
          (css-mode         . css-ts-mode)
          (json-mode        . json-ts-mode)
          (yaml-mode        . yaml-ts-mode)
          (bash-mode        . bash-ts-mode)
          (rust-mode        . rust-ts-mode)
          (elixir-mode      . elixir-ts-mode))))

(use-package dashboard
  :ensure t
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-center-content t)
  (dashboard-items '((recents . 10)
		     (projects . 10)
		     (agenda . 10)))
  (dashboard-icon-type 'nerd-icons)
  (dashboard-projects-backend 'projectile)
  :init
  (dashboard-setup-startup-hook))

(use-package embark)

(use-package embark-consult)

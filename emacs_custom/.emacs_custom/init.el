;;; init.el --- init of emacs -*- lexical-binding: t; -*-
;;; Commentary:
;;;
;;; Code:

(load-theme 'modus-vivendi)
;; (load-theme 'modus-operandi)

(require 'init-ui)
(require 'init-straight)
(require 'init-meow)
(require 'init-modeline)
(require 'init-elixir)
(require 'init-prolog)
(require 'init-files)
(require 'init-completion)
(require 'init-minibuffer)
(require 'init-projectile)

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package yasnippet
  :init
  (yas-global-mode))

(use-package paredit
  :hook
  ((emacs-lisp-mode . paredit-mode)))

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

(use-package dashboard
  :ensure t
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-center-content t)
  (dashboard-items '((recents . 10)
		     (projects . 10)
		     (agenda . 10)))
  (dashboard-icon-type 'nerd-icons)
  :init
  (dashboard-setup-startup-hook))

;;; init.el ends here


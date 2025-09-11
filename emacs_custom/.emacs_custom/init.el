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

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package ivy
  :diminish
  :config
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-ndhistory)))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

(use-package company)

(use-package yasnippet
  :init
  (yas-global-mode))

(use-package paredit
  :hook
  ((emacs-lisp-mode . paredit-mode)))

(use-package org)

(use-package magit
  :straight (magit :type git :host github :repo "magit/magit" :branch "v3.1.0")
  :init
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :bind (:map magit-mode-map
	      ("x" . magit-discard))
  ) 
(use-package apheleia
  :init
  (apheleia-global-mode +1))
;;; init.el ends here


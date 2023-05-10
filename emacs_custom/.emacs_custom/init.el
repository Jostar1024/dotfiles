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

(use-package ivy
  :diminish
  :config
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

(use-package company)

(use-package paredit
  :hook
  ((emacs-lisp-mode . paredit-mode)))

(use-package org)
(use-package magit)
;;; init.el ends here

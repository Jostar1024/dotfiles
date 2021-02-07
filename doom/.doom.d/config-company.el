;;; ../dotfiles/doom/config-company.el -*- lexical-binding: t; -*-

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

;;; init.el --- init of emacs -*- lexical-binding: t; -*-
;;; Commentary:
;;;
;;; Code:


;; Optional: ag is nice alternative to using grep with Projectile
(use-package ag
  :ensure t)

;; Optional: which-key will show you options for partially completed keybindings
;; It's extremely useful for packages with many keybindings like Projectile.
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package projectile
  :ensure t
  :custom
  (projectile-project-search-path '(("~/projects" . 1)
                                    ("~/community/" . 1)
                                    ("~/expr" . 1)))
  (projectile-auto-discover t)
  (projectile-project-root-functions #'(projectile-root-top-down
                                        projectile-root-top-down-recurring
                                        projectile-root-bottom-up
                                        projectile-root-local))

  :config
  (add-to-list 'projectile-project-root-files ".projectile")
  (add-to-list 'projectile-project-root-files "mix.exs")
  
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
  (global-set-key (kbd "C-c p") 'projectile-command-map)
  (projectile-mode))

(provide 'init-projectile)
;;; init-projectile.el ends here

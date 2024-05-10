;;; init-prolog.el --- init of emacs -*- lexical-binding: t; -*-

(use-package prolog
  :mode ("\\.pl$" . prolog-mode)
  :init
  (defun prolog-insert-comment-block ()
    (interactive)
    (let ((dashes "-"))
      (dotimes (_ 36) (setq dashes (concat "- " dashes)))
      (insert (format "/* %s\n\n%s */" dashes dashes))
      (forward-line -1)
      (indent-for-tab-command)))
  (defun prolog-insert-use-library ()
    (interactive)
    (insert ":- use_module(library()).")
    (forward-char -3))
  :config
  (setq prolog-system 'swi
        prolog-program-switches '((swi ("-G128M" "-T128M" "-L128M" "-O"))
                                  (t nil))
        prolog-electric-if-then-else-flag t)
  ;; (unbind-key "C-c C-l" 'prolog-mode-map)
  :bind (:map prolog-mode-map
	      ("C-c C-u" . 'prolog-insert-use-library)  
	      ("C-c C-q" . 'prolog-insert-comment-block)
	      ("C-c C-k" . 'ediprolog-remove-interactions)
	      ("C-c C-e" . 'ediprolog-dwim)
	      )
  )

(use-package ediprolog
  :init
  (setq ediprolog-system 'swi))

(provide 'init-prolog) 

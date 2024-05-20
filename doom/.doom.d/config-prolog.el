;;; ../.dotfiles/doom/.doom.d/config-prolog.el -*- lexical-binding: t; -*-

(use-package! prolog
  :init
  (map! :after prolog
        :map prolog-mode-map
        :localleader
        :n "u"  #'prolog-insert-use-library
        :n "q"  #'prolog-insert-comment-block
        :n "k"  #'ediprolog-remove-interactions
        :n "e"  #'ediprolog-dwim
        )
  :config
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

  :custom
  (prolog-system 'swi)
  (prolog-program-switches '((swi ("-G128M" "-T128M" "-L128M" "-O")) (t nil)))
  (prolog-electric-if-then-else-flag t)
  )

(use-package! ediprolog
  :custom
  (ediprolog-program "swipl")
  (ediprolog-system 'swi))

(setq-hook! 'prolog-mode-hook
  ;; HACK Fix #2081: Doom continues comments on RET, but coq-mode doesn't have a
  ;;      sane `comment-line-break-function', so...
  +evil-want-o/O-to-continue-comments nil)

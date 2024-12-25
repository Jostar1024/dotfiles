;;; ../.dotfiles/doom/.doom.d/config-janet.el -*- lexical-binding: t; -*-
;;;
(setq treesit-language-source-alist
      (if (eq 'windows-nt system-type)
          '((janet-simple
             . ("https://github.com/sogaiu/tree-sitter-janet-simple"
                nil nil "gcc.exe")))
        '((janet-simple
           . ("https://github.com/sogaiu/tree-sitter-janet-simple")))))

(when (not (treesit-language-available-p 'janet-simple))
  (treesit-install-language-grammar 'janet-simple))

(use-package! ajrepl
  :after janet-ts-mode
  :config
  (add-hook 'janet-ts-mode-hook
            #'ajrepl-interaction-mode))

(use-package! janet-ts-mode
  :custom
  (ajrepl--helper-path "/Users/yuchengcao/.emacs.d/.local/straight/repos/ajrepl/ajrepl/janet-last-expression/janet-last-expression/last-expression.janet")
  ;; NOTE: maybe should set ajrepl-prompt

  :config
  (map! :after janet-ts-mode
        :map janet-ts-mode-map
        :localleader
        :n "e" #'ajrepl-send-expression-at-point
        :n "r" #'ajrepl-send-region
        :n "q" #'ajrepl
        :n "b" #'ajrepl-send-buffer))


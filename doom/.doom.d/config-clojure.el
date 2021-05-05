;;; ../.dotfiles/doom/.doom.d/config-clojure.el -*- lexical-binding: t; -*-

(use-package! clojure-mode
  :config
  (add-hook 'clojure-mode-hook 'paredit-mode))

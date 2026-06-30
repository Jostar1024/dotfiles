;;; ../.dotfiles/doom/.doom.d/config-citre.el -*- lexical-binding: t; -*-

(use-package! citre
  :init
  (require 'citre-config)  ;; auto-enables citre in buffers with a tags file
  :config
  (setq citre-default-create-tags-file-location 'project-cache
        citre-use-project-root-when-creating-tags t
        citre-auto-enable-citre-mode-modes '(elixir-ts-mode)))

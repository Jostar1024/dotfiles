;;; ../.dotfiles/doom/.doom.d/config-tree-sitter.el -*- lexical-binding: t; -*-

(use-package! tree-sitter
  :hook (elixir-mode . tree-sitter-hl-mode))

(use-package! evil-textobj-tree-sitter :ensure t)

(require 'tree-sitter)

(defun tree-sitter-mark-bigger-node ()
  (interactive)
  (let* ((p (point))
         (m (or (mark) p))
         (beg (min p m))
         (end (max p m))
         (root (ts-root-node tree-sitter-tree))
         (node (ts-get-descendant-for-position-range root beg end))
         (node-beg (ts-node-start-position node))
         (node-end (ts-node-end-position node)))
    ;; Node fits the region exactly. Try its parent node instead.
    (when (and (= beg node-beg) (= end node-end))
      (when-let ((node (ts-get-parent node)))
        (setq node-beg (ts-node-start-position node)
              node-end (ts-node-end-position node))))
    (set-mark node-end)
    (goto-char node-beg)))

;; (after! er/expand-region (add-to-list 'er/try-expand-list 'tree-sitter-mark-bigger-node))

(after! er/expand-region (setq er/try-expand-list (append er/try-expand-list '(tree-sitter-mark-bigger-node))))

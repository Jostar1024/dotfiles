;;; ../.dotfiles/doom/.doom.d/config-markdown.el -*- lexical-binding: t; -*-

(use-package! markdown-mode
  :custom-face
  ;; default: Menlo, height 150, normal slant/weight/width
  (default ((t (:family "Menlo" :height 150 :slant normal :weight normal :width normal))))

  ;; variable-pitch: Optima, height 1.4 (相对 default 的缩放)
  (variable-pitch ((t (:family "Optima" :height 1.4 :slant normal :weight normal :width normal))))

  ;; markdown-header-face: Futura, height 1.1
  (markdown-header-face
   ((t (:family "Futura" :height 1.1 :slant normal :weight normal :width normal))))

  ;; 如果你还想保留分级标题的额外缩放，可以在 1.1 基础上继续叠加
  ;; (markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.0))))
  ;; (markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.0))))
  ;; (markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.0))))
  )

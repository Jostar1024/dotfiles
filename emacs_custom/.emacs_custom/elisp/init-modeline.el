;;; init-modeline.el --- Modeline -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Yucheng
;;
;; Author: Yucheng <https://github.com/yucheng>
;; Maintainer: Yucheng <howard.eureka@gmail.com>
;; Created: November 30, 2021
;; Modified: November 30, 2021
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/yucheng/init-modeline
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Modeline
;;
;;; Code:

(defun +format-mode-line ()
  (let* ((lhs '((:eval (when (fboundp 'meow-indicator)
                         (meow-indicator)))
                " L%l C%C "
                (:eval (when (fboundp 'rime-lighter)
                         (rime-lighter)))
                (:eval (when (bound-and-true-p flycheck-mode) flycheck-mode-line))
                (:eval (when (bound-and-true-p flymake-mode) flymake-mode-line-format))))
         (rhs '((:eval (+smart-file-name-cached))
                " "
                (:eval mode-name)
                (:eval (+vc-branch-name))))
         (ww (window-width))
         (lhs-str (format-mode-line lhs))
         (rhs-str (format-mode-line rhs))
         (rhs-w (string-width rhs-str)))
    (format "%s%s%s"
            lhs-str
            (propertize " " 'display `((space :align-to (- (+ right right-fringe right-margin) (+ 1 ,rhs-w)))))
            rhs-str)))

(setq-default mode-line-format '((:eval (+format-mode-line))))
(setq-default header-line-format nil)

(provide 'init-modeline)
;;; init-modeline.el ends here

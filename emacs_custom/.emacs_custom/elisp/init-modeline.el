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

(use-package nerd-icons
  :straight (nerd-icons :type git
			:host github
			:repo "rainstormstudio/nerd-icons.el")
  )

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(provide 'init-modeline)
;;; init-modeline.el ends here


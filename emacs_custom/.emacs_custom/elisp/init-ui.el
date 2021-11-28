;;; init-ui.el --- UI adjustments -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Yucheng
;;
;; Author: Yucheng <https://github.com/yucheng>
;; Maintainer: Yucheng <howard.eureka@gmail.com>
;; Created: Nov. 28, 2021
;; Modified: Nov. 28, 2021
;; Version: 0.0.1
;; Keywords: Symbol’s value as variable is void: finder-known-keywords
;; Homepage: https://github.com/yucheng/init-ui
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  UI adjustments
;;
;;; Code:

(scroll-bar-mode -1)        ; Disable visible scrollbar
(menu-bar-mode -1)          ; Disable the menu bar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(provide 'init-ui)
;;; init-ui.el ends here

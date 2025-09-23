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

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(menu-bar-mode -1)          ; Disable the menu bar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 5)         ; Give some breathing room

;; fonts
(set-face-attribute 'default nil :font "Jetbrains Mono" :height 100)

;; line number mode
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(global-set-key (kbd "C-=") 'global-text-scale-adjust)
;; (global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-q") 'start-kbd-macro)
(global-set-key (kbd "C-e") 'end-kbd-macro)

(provide 'init-ui)
;;; init-ui.el ends here

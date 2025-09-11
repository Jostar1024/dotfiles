;;; init-straight.el --- init package manager -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Yucheng
;;
;; Author: Yucheng <https://github.com/yucheng>
;; Maintainer: Yucheng <howard.eureka@gmail.com>
;; Created: Nov. 28, 2021
;; Modified: Nov. 28, 2021
;; Version: 0.0.1
;; Keywords: Symbol’s value as variable is void: finder-known-keywords
;; Homepage: https://github.com/yucheng/init-straight
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  init package manager
;;
;;; Code:

;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

;; Configure use-package to use straight.el by default
(use-package straight
  :custom
  (straight-use-package-by-default t)
  (straight-vc-git-default-clone-depth 1))

(setq use-package-always-ensure t)

(provide 'init-straight)
;;; init-straight.el ends here

;;; init-files.el --- init of emacs -*- lexical-binding: t; -*-

;; Put backup files neatly away
(let ((backup-dir "~/.tmp/emacs/backups")
      (auto-saves-dir "~/.tmp/emacs/auto-saves/"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))

(setq backup-by-copying t    ; Don't delink hardlinks
      delete-old-versions t  ; Clean up the backups
      version-control t      ; Use version numbers on backups,
      kept-new-versions 5    ; keep some new versions
      kept-old-versions 2)   ; and some old ones, too

;; remember and restore the last cursor location of opened files
(save-place-mode 1)

;; revert the buffer when the file is changed on the disk
(global-auto-revert-mode 1)

(use-package dired
  ;; NOTE:  https://www.reddit.com/r/emacs/comments/m9j4a9/usepackage_dired_ensure_nil_does_not_work_for_me/
  :straight (:type built-in)
  :config
  ;; Revert Dired and other buffers
  (setq global-auto-revert-non-file-buffers t)
  
  :bind
  (:map dired-mode-map
	("-" . #'dired-up-directory)))

(provide 'init-files)

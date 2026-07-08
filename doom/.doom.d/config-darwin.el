;;; ../.dotfiles/doom/.doom.d/config-darwin.el -*- lexical-binding: t; -*-
(setq-default mac-option-modifier 'super
              mac-command-modifier 'meta)

;; https://github.com/d12frosted/homebrew-emacs-plus/issues/383#issuecomment-4364362944
;; NOTE: this requires coreutils installed in nix-home-manager 
(let* ((nix-home-manager-path (expand-file-name "~/.nix-profile/bin/ls"))
       (nix-darwin-path "/etc/profiles/per-user/yucheng/bin/ls")
       (final-ls-path (cond ((file-exists-p nix-home-manager-path) nix-home-manager-path)
                            ((file-exists-p nix-darwin-path) nix-darwin-path))))
  (setq insert-directory-program final-ls-path))

;; (bind-key "M-v" #'clipboard-yank)
;; NOTE: To not have conflict with Mac's Aerospace.
(evil-define-key 'normal evil-normal-state-map
  (kbd "s-1") nil
  (kbd "s-2") nil
  (kbd "s-3") nil
  (kbd "s-4") nil
  (kbd "s-5") nil
  (kbd "s-6") nil
  (kbd "s-7") nil
  (kbd "s-8") nil
  (kbd "s-9") nil)

;; Index macOS SDK man pages for gman so that section 3 pages (e.g. printf(3))
;; appear in M-x man completion.
(require 'xdg)

;; A user-local man_db.conf adds a MANDB_MAP for
;; the SDK path, and a wrapper script makes man.el pass -C to gman.
(let* ((sdk (string-trim
             (shell-command-to-string "xcrun --show-sdk-path")))
       (sdk-man (concat sdk "/usr/share/man"))
       (user-conf (expand-file-name "man_db.conf" (xdg-config-home)))
       (cache-dir (expand-file-name "man/macos-sdk" (xdg-cache-home)))
       (wrapper (expand-file-name "gman-emacs" (xdg-cache-home))))
  (setenv "MANPATH"
          (concat sdk-man ":" (or (getenv "MANPATH") "")))
  ;; Write user config: system config + SDK MANDB_MAP
  (make-directory (file-name-directory user-conf) t)
  (make-directory cache-dir t)
  (with-temp-file user-conf
    (insert-file-contents "/opt/homebrew/etc/man_db.conf")
    (goto-char (point-max))
    (insert "\nMANDB_MAP\t" sdk-man "\t" cache-dir "\n"))
  ;; Write wrapper script so man.el passes -C to gman
  (with-temp-file wrapper
    (insert "#!/bin/sh\nexec gman -C " (shell-quote-argument user-conf) " \"$@\"\n"))
  (set-file-modes wrapper #o755)
  ;; Rebuild index with user config
  (call-process "gmandb" nil nil nil "-C" user-conf)
  (setq manual-program wrapper)
  (message "Rebuilt the man index"))

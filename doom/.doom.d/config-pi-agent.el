;;; config-pi-agent.el --- Pi coding agent workspace -*- lexical-binding: t; -*-

(defun my/pi-workspace ()
  "Switch to the dedicated 'pi' workspace, creating it if needed."
  (interactive)
  (+workspace/switch-to "pi"))

(defun my/pi-new-session (name)
  "Create a new named pi-coding-agent session in the 'pi' workspace.
With prefix arg, prompt for PI_CODING_AGENT_DIR before starting."
  (interactive
   (list (read-string "Session name: "
                       (format "%s-%s" (projectile-project-name) (format-time-string "%H%M%S")))))
  (my/pi-workspace)
  (let ((process-environment
         (if current-prefix-arg
             (cons (format "PI_CODING_AGENT_DIR=%s"
                           (read-directory-name "PI_CODING_AGENT_DIR: " "~/.pi-personal"))
                   process-environment)
           process-environment)))
    (delete-other-windows)
    (pi-coding-agent name)))

(defun my/pi-switch-session ()
  "Switch to another pi-coding-agent session by name."
  (interactive)
  (my/pi-workspace)
  (let* ((chat-bufs (cl-remove-if-not
                     (lambda (buf)
                       (with-current-buffer buf
                         (derived-mode-p 'pi-coding-agent-chat-mode)))
                     (buffer-list)))
         (raw-names (mapcar (lambda (buf)
                              (let ((name (buffer-name buf)))
                                (cons (if (string-match "<\\(.+\\)>\\*$" name)
                                          (match-string 1 name)
                                        "default")
                                      buf)))
                            chat-bufs))
         ;; Disambiguate duplicate names by appending project dir
         (name-counts (let ((ht (make-hash-table :test 'equal)))
                        (dolist (entry raw-names ht)
                          (puthash (car entry) (1+ (gethash (car entry) ht 0)) ht))))
         (names (mapcar (lambda (entry)
                          (let ((n (car entry))
                                (buf (cdr entry)))
                            (if (> (gethash n name-counts) 1)
                                (cons (format "%s [%s]" n
                                              (file-name-nondirectory
                                               (directory-file-name
                                                (buffer-local-value 'default-directory buf))))
                                      buf)
                              (cons n buf))))
                        raw-names)))
    (if (null names)
        (user-error "No pi sessions active")
      (let* ((choice (completing-read "Pi session: " (mapcar #'car names) nil t))
             (buf (cdr (assoc choice names)))
             (input-buf (buffer-local-value 'pi-coding-agent--input-buffer buf)))
        (delete-other-windows)
        (pi-coding-agent--display-buffers buf input-buf)))))


(defun my/pi-rename-session (new-name)
  "Rename the current pi-coding-agent session."
  (interactive
   (let* ((buf-name (buffer-name))
          (current-name (when (string-match "<\\(.+\\)>\\*$" buf-name)
                          (match-string 1 buf-name))))
     (list (read-string "New session name: " current-name))))
  (let ((chat-buf (cond
                   ((derived-mode-p 'pi-coding-agent-chat-mode)
                    (current-buffer))
                   ((derived-mode-p 'pi-coding-agent-input-mode)
                    (buffer-local-value 'pi-coding-agent--chat-buffer (current-buffer)))
                   (t (user-error "Not in a pi session buffer")))))
    (unless (buffer-live-p chat-buf)
      (user-error "No active pi session found"))
    (with-current-buffer chat-buf
      (rename-buffer (format "*pi-coding-agent<%s>*" new-name))
      (let ((input-buf (bound-and-true-p pi-coding-agent--input-buffer)))
        (when (buffer-live-p input-buf)
          (with-current-buffer input-buf
            (rename-buffer (format "*pi-coding-agent-input<%s>*" new-name)))))
      (message "Pi session renamed to: %s" new-name))))

(defun my/pi-copy-file-path-with-line-number ()
  (interactive)
  (let ((file-path-with-line-number (format "@%s:%d" (buffer-file-name) (line-number-at-pos))))
    (kill-new file-path-with-line-number)
    (message "Copy to clipboard: %s" file-path-with-line-number)
    ))

(defvar my/pi-session-dump-file
  (expand-file-name "pi-sessions.el" doom-cache-dir)
  "File to store active pi session metadata for restore.")

(defun my/pi-dump-sessions ()
  "Save metadata of all active pi sessions to `my/pi-session-dump-file'."  (interactive)
  (let (entries)
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (derived-mode-p 'pi-coding-agent-chat-mode)
          (let* ((state pi-coding-agent--state)
                 (session-file (and state (plist-get state :session-file)))
                 (dir default-directory)
                 (buf-name (buffer-name))
                 (session-name
                  (when (string-match "<\\(.+\\)>\\*$" buf-name)
                    (match-string 1 buf-name))))
            (when session-file
              (push (list :name session-name
                          :dir dir
                          :session-file session-file)
                    entries))))))
    (if (null entries)
        (message "No active pi sessions to dump.")
      (with-temp-file my/pi-session-dump-file
        (insert ";; Pi session dump\n")
        (prin1 entries (current-buffer))
        (insert "\n"))
      (message "Dumped %d pi session(s) to %s" (length entries) my/pi-session-dump-file))))

(defun my/pi-restore-sessions ()
  "Restore pi sessions from `my/pi-session-dump-file'."  (interactive)
  (unless (file-exists-p my/pi-session-dump-file)
    (user-error "No dump file found at %s" my/pi-session-dump-file))
  (let ((entries (with-temp-buffer
                   (insert-file-contents my/pi-session-dump-file)
                   (goto-char (point-min))
                   (forward-line 1)
                   (read (current-buffer)))))
    (when (null entries)
      (user-error "Dump file is empty"))
    (my/pi-workspace)
    (dolist (entry entries)
      (let* ((name (plist-get entry :name))
             (dir (plist-get entry :dir))
             (session-file (plist-get entry :session-file))
             (default-directory dir))
        (pi-coding-agent (or name nil))
        (let* ((chat-buf (pi-coding-agent--get-chat-buffer))
               (proc (and chat-buf
                          (buffer-local-value 'pi-coding-agent--process chat-buf))))
          (when (and proc (process-live-p proc) chat-buf)
            (pi-coding-agent--rpc-async
             proc
             (list :type "switch_session" :sessionPath session-file)
             (lambda (response)
               (let* ((data (plist-get response :data))
                      (cancelled (plist-get data :cancelled)))
                 (if (and (plist-get response :success)
                          (pi-coding-agent--json-false-p cancelled))
                     (progn
                       (pi-coding-agent--refresh-session-state proc chat-buf session-file)
                       (pi-coding-agent--load-session-history
                        proc
                        (lambda (count)
                          (message "Pi: Restored session %s (%d messages)"
                                   (or name "default") count))
                        chat-buf))
                   (message "Pi: Failed to restore session %s" (or name "default")))))))))))
    (message "Restoring %d pi session(s)..." (length entries)))

(map! :leader
      (:prefix ("j" . "Pi Agent")
       :n "c" #'my/pi-copy-file-path-with-line-number
       :n "P" #'my/pi-workspace
       :n "n" #'my/pi-new-session
       :n "s" #'my/pi-switch-session
       :n "r" #'my/pi-rename-session
       :n "t" #'pi-coding-agent-toggle
       :n "d" #'my/pi-dump-sessions
       :n "R" #'my/pi-restore-sessions
       :n "q" #'pi-coding-agent-quit))

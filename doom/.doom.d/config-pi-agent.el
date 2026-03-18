;;; config-pi-agent.el --- Pi coding agent workspace -*- lexical-binding: t; -*-

(defun my/pi-workspace ()
  "Switch to the dedicated 'pi' workspace, creating it if needed."
  (interactive)
  (+workspace/switch-to "pi"))

(defun my/pi-new-session (name)
  "Create a new named pi-coding-agent session in the 'pi' workspace."
  (interactive "sSession name: ")
  (my/pi-workspace)
  (pi-coding-agent name))

(defun my/pi-switch-session ()
  "Switch to another pi-coding-agent session by name."
  (interactive)
  (my/pi-workspace)
  (let* ((chat-bufs (cl-remove-if-not
                     (lambda (buf)
                       (with-current-buffer buf
                         (derived-mode-p 'pi-coding-agent-chat-mode)))
                     (buffer-list)))
         (names (mapcar (lambda (buf)
                          (let ((name (buffer-name buf)))
                            (if (string-match "<\\(.+\\)>\\*$" name)
                                (cons (match-string 1 name) buf)
                              (cons "default" buf))))
                        chat-bufs)))
    (if (null names)
        (user-error "No pi sessions active")
      (let* ((choice (completing-read "Pi session: " (mapcar #'car names) nil t))
             (buf (cdr (assoc choice names)))
             (input-buf (buffer-local-value 'pi-coding-agent--input-buffer buf)))
        (delete-other-windows)
        (pi-coding-agent--display-buffers buf input-buf)))))


(defun my/pi-copy-file-path-with-line-number ()
  (interactive)
  (let ((file-path-with-line-number (format "@%s:%d" (buffer-file-name) (line-number-at-pos))))
    (kill-new file-path-with-line-number)
    (message "Copy to clipboard: %s" file-path-with-line-number)
    ))

(map! :leader
      (:prefix ("j" . "Pi Agent")
       :n "c" #'my/pi-copy-file-path-with-line-number
       :n "P" #'my/pi-workspace
       :n "n" #'my/pi-new-session
       :n "s" #'my/pi-switch-session
       :n "t" #'pi-coding-agent-toggle
       :n "q" #'pi-coding-agent-quit))

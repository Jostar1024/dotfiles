;;; ../dotfiles/doom/config-wsl.el -*- lexical-binding: t; -*-

;; paste code from external
;; https://stackoverflow.com/questions/18691973/is-there-a-set-paste-option-in-emacs-to-paste-paste-from-external-clipboard?spm=a2c4e.10696291.0.0.111219a4sTbBnB
(defvar ttypaste-mode nil)
(add-to-list 'minor-mode-alist '(ttypaste-mode " Paste"))

(defun ttypaste-mode ()
  (interactive)
  (let ((buf (current-buffer))
        (ttypaste-mode t))
    (with-temp-buffer
      (let ((stay t)
            (text (current-buffer)))
        (redisplay)
        (while stay
          (let ((char (let ((inhibit-redisplay t)) (read-event nil t 0.1))))
            (unless char
              (with-current-buffer buf (insert-buffer-substring text))
              (erase-buffer)
              (redisplay)
              (setq char (read-event nil t)))
            (cond
             ((not (characterp char)) (setq stay nil))
             ((eq char ?\r) (insert ?\n))
             ((eq char ?\e)
              (if (sit-for 0.1 'nodisp) (setq stay nil) (insert ?\e)))
             (t (insert char)))))
                (insert-buffer-substring text)))))

(defun +copy-to-clipboard ()
  (interactive)
  (let ((s (buffer-substring-no-properties (region-beginning) (region-end)))
        (display-buffer-alist '(("*Async Shell Command*"
                               (actions . display-buffer-no-window)))))
    (async-shell-command  (format "echo %s | clip.exe" (prin1-to-string s)))))

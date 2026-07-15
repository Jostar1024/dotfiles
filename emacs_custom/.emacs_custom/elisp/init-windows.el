;;; init-windows.el --- Window & buffer management (Doom-style) -*- lexical-binding: t; -*-
;;; Commentary:
;;
;; Provides Doom-like window and buffer management with:
;; - SPC w ... for window operations
;; - SPC b ... for buffer operations
;; - ace-window for fast window switching
;; - Display rules for popup-style buffers
;;
;;; Code:

;;; --- Packages ---

(use-package ace-window
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-scope 'frame)
  (aw-background t))

;;; --- Buffer helpers ---

(defun my/kill-current-buffer ()
  "Kill the current buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(defun my/switch-to-messages-buffer ()
  "Switch to *Messages* buffer."
  (interactive)
  (switch-to-buffer "*Messages*"))

(defun my/switch-to-scratch-buffer ()
  "Switch to *scratch* buffer, creating it if needed."
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*")))

(defun my/new-empty-buffer ()
  "Create a new empty buffer and switch to it."
  (interactive)
  (let ((buf (generate-new-buffer "untitled")))
    (switch-to-buffer buf)
    (setq buffer-offer-save t)))

(defun my/kill-other-buffers ()
  "Kill all buffers except the current one."
  (interactive)
  (mapc #'kill-buffer
        (delq (current-buffer)
              (seq-filter #'buffer-file-name (buffer-list))))
  (message "Killed other file-visiting buffers"))

;;; --- Window helpers ---

(defun my/split-window-right-and-focus ()
  "Split window right and move focus to the new window."
  (interactive)
  (split-window-right)
  (other-window 1))

(defun my/split-window-below-and-focus ()
  "Split window below and move focus to the new window."
  (interactive)
  (split-window-below)
  (other-window 1))

(defun my/window-swap ()
  "Swap the current window with the next one."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win (selected-window))
             (next-win (next-window))
             (this-buf (window-buffer this-win))
             (next-buf (window-buffer next-win))
             (this-start (window-start this-win))
             (next-start (window-start next-win)))
        (set-window-buffer this-win next-buf)
        (set-window-buffer next-win this-buf)
        (set-window-start this-win next-start)
        (set-window-start next-win this-start))
    (ace-swap-window)))

;;; --- Keymaps ---

(defvar my/buffer-map (make-sparse-keymap)
  "Keymap for buffer commands under SPC b.")

(define-key my/buffer-map (kbd "b") #'consult-buffer)
(define-key my/buffer-map (kbd "B") #'consult-buffer-other-window)
(define-key my/buffer-map (kbd "d") #'my/kill-current-buffer)
(define-key my/buffer-map (kbd "k") #'my/kill-current-buffer)
(define-key my/buffer-map (kbd "K") #'my/kill-other-buffers)
(define-key my/buffer-map (kbd "m") #'my/switch-to-messages-buffer)
(define-key my/buffer-map (kbd "n") #'next-buffer)
(define-key my/buffer-map (kbd "N") #'my/new-empty-buffer)
(define-key my/buffer-map (kbd "p") #'previous-buffer)
(define-key my/buffer-map (kbd "s") #'save-buffer)
(define-key my/buffer-map (kbd "S") #'evil-write-all)
(define-key my/buffer-map (kbd "x") #'my/switch-to-scratch-buffer)
(define-key my/buffer-map (kbd "[") #'previous-buffer)
(define-key my/buffer-map (kbd "]") #'next-buffer)

;; save-some-buffers instead of evil-write-all (we don't use evil)
(define-key my/buffer-map (kbd "S") (lambda () (interactive) (save-some-buffers t)))

(defvar my/window-map (make-sparse-keymap)
  "Keymap for window commands under SPC w.")

(define-key my/window-map (kbd "w") #'ace-window)
(define-key my/window-map (kbd "W") #'ace-swap-window)
(define-key my/window-map (kbd "d") #'delete-window)
(define-key my/window-map (kbd "c") #'delete-window)
(define-key my/window-map (kbd "D") #'ace-delete-window)
(define-key my/window-map (kbd "s") #'my/split-window-below-and-focus)
(define-key my/window-map (kbd "v") #'my/split-window-right-and-focus)
(define-key my/window-map (kbd "-") #'my/split-window-below-and-focus)
(define-key my/window-map (kbd "/") #'my/split-window-right-and-focus)
(define-key my/window-map (kbd "h") #'windmove-left)
(define-key my/window-map (kbd "j") #'windmove-down)
(define-key my/window-map (kbd "k") #'windmove-up)
(define-key my/window-map (kbd "l") #'windmove-right)
(define-key my/window-map (kbd "H") #'windmove-swap-states-left)
(define-key my/window-map (kbd "J") #'windmove-swap-states-down)
(define-key my/window-map (kbd "K") #'windmove-swap-states-up)
(define-key my/window-map (kbd "L") #'windmove-swap-states-right)
(define-key my/window-map (kbd "=") #'balance-windows)
(define-key my/window-map (kbd "m") #'toggle-delete-other-windows)
(define-key my/window-map (kbd "o") #'other-window)
(define-key my/window-map (kbd "u") #'winner-undo)
(define-key my/window-map (kbd "r") #'winner-redo)
(define-key my/window-map (kbd "x") #'my/window-swap)
(define-key my/window-map (kbd "+") #'enlarge-window)
(define-key my/window-map (kbd ">") #'enlarge-window-horizontally)
(define-key my/window-map (kbd "<") #'shrink-window-horizontally)

;;; --- Display buffer rules (popup-style) ---

(setq display-buffer-alist
      `(;; Help, compilation, grep - bottom side window
        (,(rx bos (or "*Help" "*Compile" "*compilation" "*grep" "*Occur"
                      "*Backtrace" "*Warnings" "*Messages"))
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom)
         (slot . 0)
         (window-height . 0.33)
         (reusable-frames . visible))
        ;; Shell/eshell/vterm - bottom
        (,(rx bos (or "*shell" "*eshell" "*vterm" "*term" "*ansi-term"))
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom)
         (slot . 1)
         (window-height . 0.33))
        ;; Magit process/log - bottom
        (,(rx bos "*magit" (* anything) "process")
         (display-buffer-reuse-window display-buffer-in-side-window)
         (side . bottom)
         (slot . 2)
         (window-height . 0.25))))

;;; --- Register keymaps with meow leader ---

(with-eval-after-load 'meow
  (meow-leader-define-key
   '("b" . my/buffer-map)
   '("w" . my/window-map)))

(provide 'init-windows)
;;; init-windows.el ends here

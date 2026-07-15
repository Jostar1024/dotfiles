;;; ../.dotfiles/doom/.doom.d/config-citre.el -*- lexical-binding: t; -*-

;; insert module name when select the candidate from the popup
;; if it's the current module, skip the insertion.
(defun my/elixir-citre-completion-at-point ()
  "Citre capf for Elixir that inserts module prefix on completion."
  (when-let* ((result (if citre-capf-optimize-for-popup
                          (pcase (while-no-input (citre-get-completions))
                            ('t nil)
                            (val val))
                        (citre-get-completions)))
              (beg (nth 0 result))
              (end (nth 1 result))
              (tags (nth 2 result)))
    (let* ((candidates
            (mapcar (lambda (tag)
                      (let ((cand (citre-capf--make-candidate tag)))
                        (when-let* ((kind (citre-get-tag-field 'ext-kind-full tag))
                                    ((member kind '("function" "macro")))
                                    (scope (citre-get-tag-field 'scope tag 'after-colon)))
                          (citre-put-property cand 'scope scope))
                        cand))
                    tags))
           (collection
            (lambda (str pred action)
              (if (eq action 'metadata)
                  '(metadata
                    (category . citre-completion)
                    (cycle-sort-function . identity)
                    (display-sort-function . identity))
                (complete-with-action action candidates str pred)))))
      (list beg end collection
            :annotation-function (lambda (cand) (citre-get-property 'annotation cand))
            :company-docsig (lambda (cand) (citre-get-property 'signature cand))
            :company-kind (lambda (cand) (citre-get-property 'kind cand))
            :exit-function (lambda (cand status)
                             (when (eq status 'finished)
                               (when-let* ((scope (citre-get-property 'scope cand)))
                                 (let ((current-module
                                        (save-excursion
                                          (when (re-search-backward
                                                 "defmodule\\s-+\\([A-Z][A-Za-z0-9_.]*\\)" nil t)
                                            (match-string-no-properties 1)))))
                                   (unless (equal scope current-module)
                                     (let ((prefix (concat scope ".")))
                                       (unless (save-excursion
                                                 (backward-char (+ (length cand) (length prefix)))
                                                 (looking-at-p (regexp-quote prefix)))
                                         (save-excursion
                                           (backward-char (length cand))
                                           (insert prefix)))))))))))))

;; Some notes for playing around citre.
;; 
;; 1. you could edit the tags file updating recipe by `citre-edit-tags-file-recipe.'
;; 
;; 2. after the installation and restarting emacs, the `citre-xref-backend' function is added to `xref-backend-functions'.
;; To test it in doom emacs, use SPC u g d, then select `+lookup-xref-definitions-backend-fn' to test the backend
;; 
;; 3. I prefer global cache and set the custom to `(citre-default-create-tags-file-location 'global-cache)`
;;  
(use-package! citre
  :init
  (require 'citre-config)  ;; auto-enables citre in buffers with a tags file
  :hook
  (citre-mode-hook . (lambda ()
                       (when (derived-mode-p 'elixir-ts-mode)
                         (setq-local completion-at-point-functions
                                     (cl-substitute #'my/elixir-citre-completion-at-point
                                                    #'citre-completion-at-point
                                                    completion-at-point-functions)))))
  :custom
  (citre-default-create-tags-file-location 'global-cache)
  :config
  (setq citre-use-project-root-when-creating-tags t
        citre-auto-enable-citre-mode-modes '(elixir-ts-mode))

  ;; Elixir language support: cursor-position-aware symbol lookup.
  ;; Cursor on uppercase segment (module) -> lookup full module path up to that segment.
  ;; Cursor on lowercase segment (function) -> lookup just the function name.
  ;; This works with `modify-syntax-entry ?. "_"` making . a symbol constituent.
  (citre-tags-register-language-support
   'elixir-ts-mode
   (list :get-symbol (lambda ()
                       (when-let* ((bounds (bounds-of-thing-at-point 'symbol)))
                         (let* ((full (buffer-substring-no-properties (car bounds) (cdr bounds)))
                                (pos-in-str (- (point) (car bounds)))
                                (before-cursor (substring full 0 pos-in-str))
                                (seg-start (if-let* ((last-dot (cl-position ?. before-cursor :from-end t)))
                                               (1+ last-dot)
                                             0))
                                (seg-end (or (cl-position ?. full :start pos-in-str)
                                             (length full)))
                                (segment (substring full seg-start seg-end))
                                (is-func (let ((c (aref segment 0)))
                                           (or (<= ?a c ?z) (= c ?_))))
                                (name (if is-func segment
                                        (substring full 0 seg-end)))
                                (new-beg (if is-func
                                             (+ (car bounds) seg-start)
                                           (car bounds)))
                                (new-end (+ (car bounds) seg-end)))
                           (citre-put-property name 'bounds (cons new-beg new-end))))))))


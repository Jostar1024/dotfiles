;;; ../.dotfiles/doom/.doom.d/config-citre.el -*- lexical-binding: t; -*-

;; Elixir-aware completion-at-point function for citre.
;;
;; Handles two patterns:
;; 1. Qualified function call: `Repo.ge` -> splits into module filter + function prefix,
;;    queries tags by function name, builds qualified candidates for orderless to match.
;; 2. Module/plain: `Content` -> standard prefix match against module/function tags.
;;
;; Candidates are always fully qualified (e.g. `ContentAvail.Repo.get`) so that
;; orderless can fuzzy-match across the whole path. The exit-function strips the
;; current module prefix when the selected function belongs to the enclosing module.

(defun my/elixir--current-module ()
  "Return the full module name of the enclosing defmodule, or nil."
  (save-excursion
    (when (re-search-backward
           "defmodule\\s-+\\([A-Z][A-Za-z0-9_.]*\\)" nil t)
      (match-string-no-properties 1))))

(defun my/elixir-citre-completion-at-point ()
  "Citre capf for Elixir with qualified-name fuzzy completion.

When the symbol at point contains a dot and ends with a lowercase
segment (e.g. `Repo.ge'), search for function tags whose name
starts with the last segment, filter by scope matching the module
part, and return qualified candidates. Orderless then lets the
user type any fragment of the full path.

For plain lowercase input (e.g. `ge'), return all matching
functions qualified with their scope so the user can see context.

For uppercase input (e.g. `Content'), match against module tags."
  (when-let* ((tagsfile (citre-tags-file-path))
              (bounds (bounds-of-thing-at-point 'symbol)))
    (let* ((beg (car bounds))
           (end (cdr bounds))
           (input (buffer-substring-no-properties beg end))
           (parts (split-string input "\\."))
           (last-part (car (last parts)))
           (is-qualified (> (length parts) 1))
           ;; Last segment lowercase or empty (trailing dot) = function pattern
           (func-pattern (or (string-empty-p last-part)
                             (let ((c (aref last-part 0)))
                               (or (<= ?a c ?z) (= c ?_)))))
           (current-module (my/elixir--current-module)))
      (cond
       ;; --- Case 1: Qualified function call (Repo.ge, ContentAvail.Repo.) ---
       ((and is-qualified func-pattern)
        (let* ((module-filter (string-join (butlast parts) "."))
               (func-prefix last-part)
               ;; Build a symbol for readtags query on the function prefix
               (symbol (citre-put-property
                        (if (string-empty-p func-prefix) "" func-prefix)
                        'bounds (cons (- end (length func-prefix)) end)))
               (tags (let ((inhibit-quit t))
                       (citre-tags-get-tags
                        tagsfile symbol
                        (if (string-empty-p func-prefix) nil 'prefix)
                        :filter `(and
                                  (not (or ,(citre-tags-filter-extra-tags '("anonymous" "reference"))
                                           ,citre-tags-filter-file-tags))
                                  ;; Only functions/macros/callbacks/delegates
                                  (or ,(citre-readtags-filter-kind "function")
                                      ,(citre-readtags-filter-kind "macro")
                                      ,(citre-readtags-filter-kind "callback")
                                      ,(citre-readtags-filter-kind "delegate")))
                        :sorter (citre-readtags-sorter '(length name +) 'name)
                        :require '(name)
                        :optional '(ext-kind-full signature scope))))
               ;; Build qualified candidates, filtering by module-filter in scope
               (candidates
                (let (result seen)
                  (dolist (tag tags)
                    (when-let* ((name (citre-get-tag-field 'name tag))
                                (scope (citre-get-tag-field 'scope tag 'after-colon)))
                      (when (string-match-p (regexp-quote module-filter) scope)
                        (let ((qualified (concat scope "." name)))
                          (unless (member qualified seen)
                            (push qualified seen)
                            (push (propertize
                                   qualified
                                   'citre-scope scope
                                   'citre-kind (or (citre-get-tag-field 'ext-kind-full tag) "")
                                   'citre-signature (or (citre-get-tag-field 'signature tag) ""))
                                  result))))))
                  (nreverse result))))
          (when candidates
            (list beg end
                  (lambda (str pred action)
                    (if (eq action 'metadata)
                        '(metadata (category . citre-completion)
                                   (cycle-sort-function . identity)
                                   (display-sort-function . identity))
                      (complete-with-action action candidates str pred)))
                  :annotation-function
                  (lambda (cand)
                    (let ((sig (get-text-property 0 'citre-signature cand)))
                      (if (and sig (not (string-empty-p sig)))
                          (concat " " sig) "")))
                  :company-kind
                  (lambda (cand)
                    (pcase (get-text-property 0 'citre-kind cand)
                      ("function" 'function) ("macro" 'macro) (_ 'function)))
                  :exit-function
                  (lambda (cand status)
                    (when (eq status 'finished)
                      ;; If the function belongs to current module, replace with just the name
                      (when-let* ((scope (get-text-property 0 'citre-scope cand)))
                        (when (and current-module (equal scope current-module))
                          (let* ((name (substring cand (1+ (length scope))))
                                 (pt (point)))
                            (delete-region (- pt (length cand)) pt)
                            (insert name))))))))))

       ;; --- Case 2: Plain function prefix (ge, get_b) ---
       ((and (not is-qualified) func-pattern (not (string-empty-p input)))
        (let* ((symbol (citre-put-property input 'bounds (cons beg end)))
               (tags (let ((inhibit-quit t))
                       (citre-tags-get-tags
                        tagsfile symbol 'prefix
                        :filter `(and
                                  (not (or ,(citre-tags-filter-extra-tags '("anonymous" "reference"))
                                           ,citre-tags-filter-file-tags))
                                  (or ,(citre-readtags-filter-kind "function")
                                      ,(citre-readtags-filter-kind "macro")
                                      ,(citre-readtags-filter-kind "callback")
                                      ,(citre-readtags-filter-kind "delegate")))
                        :sorter (citre-readtags-sorter '(length name +) 'name)
                        :require '(name)
                        :optional '(ext-kind-full signature scope))))
               ;; Build qualified candidates
               (candidates
                (let (result seen)
                  (dolist (tag tags)
                    (when-let* ((name (citre-get-tag-field 'name tag)))
                      (let* ((scope (citre-get-tag-field 'scope tag 'after-colon))
                             (qualified (if scope (concat scope "." name) name)))
                        (unless (member qualified seen)
                          (push qualified seen)
                          (push (propertize
                                 qualified
                                 'citre-scope (or scope "")
                                 'citre-kind (or (citre-get-tag-field 'ext-kind-full tag) "")
                                 'citre-signature (or (citre-get-tag-field 'signature tag) ""))
                                result)))))
                  (nreverse result))))
          (when candidates
            (list beg end
                  (lambda (str pred action)
                    (if (eq action 'metadata)
                        '(metadata (category . citre-completion)
                                   (cycle-sort-function . identity)
                                   (display-sort-function . identity))
                      (complete-with-action action candidates str pred)))
                  :annotation-function
                  (lambda (cand)
                    (let ((sig (get-text-property 0 'citre-signature cand)))
                      (if (and sig (not (string-empty-p sig)))
                          (concat " " sig) "")))
                  :company-kind
                  (lambda (cand)
                    (pcase (get-text-property 0 'citre-kind cand)
                      ("function" 'function) ("macro" 'macro) (_ 'function)))
                  :exit-function
                  (lambda (cand status)
                    (when (eq status 'finished)
                      (when-let* ((scope (get-text-property 0 'citre-scope cand)))
                        (when (and current-module
                                   (not (string-empty-p scope))
                                   (equal scope current-module))
                          ;; Strip module prefix for same-module functions
                          (let* ((name (substring cand (1+ (length scope))))
                                 (pt (point)))
                            (delete-region (- pt (length cand)) pt)
                            (insert name))))))))))

       ;; --- Case 3: Module prefix (Content, ContentAvail.As) ---
       (t
        (let* ((symbol (citre-put-property input 'bounds (cons beg end)))
               (tags (let ((inhibit-quit t))
                       (citre-tags-get-tags
                        tagsfile symbol 'prefix
                        :filter `(and
                                  (not (or ,(citre-tags-filter-extra-tags '("anonymous" "reference"))
                                           ,citre-tags-filter-file-tags))
                                  ,(citre-readtags-filter-kind "module"))
                        :sorter (citre-readtags-sorter '(length name +) 'name)
                        :require '(name)
                        :optional '(ext-kind-full))))
               (candidates
                (let (result seen)
                  (dolist (tag tags)
                    (when-let* ((name (citre-get-tag-field 'name tag)))
                      (unless (member name seen)
                        (push name seen)
                        (push (propertize name 'citre-kind "module") result))))
                  (nreverse result))))
          (when candidates
            (list beg end
                  (lambda (str pred action)
                    (if (eq action 'metadata)
                        '(metadata (category . citre-completion)
                                   (cycle-sort-function . identity)
                                   (display-sort-function . identity))
                      (complete-with-action action candidates str pred)))
                  :company-kind (lambda (_cand) 'module)))))))))

;; Find references using ripgrep (ctags doesn't generate reference tags for Elixir)
(defun my/elixir-citre-find-references ()
  "Find references of symbol at point using ripgrep in the project."
  (interactive)
  (when-let* ((bounds (bounds-of-thing-at-point 'symbol))
              (sym (buffer-substring-no-properties (car bounds) (cdr bounds)))
              (root (or (citre-project-root) (doom-project-root))))
    (let* ((parts (split-string sym "\\."))
           (last-part (car (last parts)))
           (is-func (and (> (length last-part) 0)
                         (let ((c (aref last-part 0)))
                           (or (<= ?a c ?z) (= c ?_)))))
           (search-pattern (if (and is-func (> (length parts) 1))
                               sym
                             (if is-func
                                 (format "\\b%s\\b" last-part)
                               sym))))
      (xref--show-xrefs
       (xref-matches-in-directory search-pattern "*.ex" root nil)
       nil))))

;; Register as a Doom lookup handler for elixir-ts-mode
(after! elixir-ts-mode
  (set-lookup-handlers! 'elixir-ts-mode
    :references #'my/elixir-citre-find-references))

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

  ;; Elixir language support: cursor-position-aware symbol lookup for go-to-definition.
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
                           (citre-put-property name 'bounds (cons new-beg new-end)))))
         ;; Definition filter: exclude anonymous and file-scoped-in-other-file tags.
         ;; This ensures go-to-definition works for both modules and functions.
         :definition-filter
         (lambda (symbol)
           (let ((file-path (citre-get-property 'file-path symbol))
                 (tags-file (citre-get-property 'tags-file symbol)))
             `(not
               (or
                ,(citre-tags-filter-extra-tags '("anonymous"))
                ,(if file-path
                     (citre-tags-filter-local-symbol-in-other-file file-path tags-file)
                   'false))))))))

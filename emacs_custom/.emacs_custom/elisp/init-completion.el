;;; init-completion.el --- init of emacs -*- lexical-binding: t; -*-

;; A few more useful configurations...
(use-package emacs
  :init
  ;; TAB cycle if there are only few candidates
  (setq completion-cycle-threshold 3)

  ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
  ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete))

(use-package no-littering)

(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

(use-package corfu
  :after orderless
  :straight (corfu :files (:defaults "extensions/*"))
  :custom
  (corfu-cycle nil)			;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)			;; Enable auto completion
  (corfu-auto-delay 0)
  (corfu-auto-prefix 2)
  (corfu-popupinfo-delay 0.2)
  
  (corfu-separator ?\s)			;; Orderless field separator
  (corfu-quit-at-boundary nil)		;; Never quit at completion boundary
  (corfu-quit-no-match t)		
  (corfu-preview-current nil)	;; Disable current candidate preview
  (corfu-preselect 'first)		;; Preselect the prompt
  (corfu-on-exact-match nil)		;; Configure handling of exact matches
  (corfu-scroll-margin 5)		;; set scroll margin
    
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  )

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-use-icons t)
  (kind-icon-default-face 'corfu-default) ; Have background color be the same as `corfu' face background
  (kind-icon-blend-background nil)  ; Use midpoint color between foreground and background colors ("blended")?
  (kind-icon-blend-frac 0.08)

  ;; NOTE 2022-02-05: `kind-icon' depends `svg-lib' which creates a cache
  ;; directory that defaults to the `user-emacs-directory'. Here, I change that
  ;; directory to a location appropriate to `no-littering' conventions, a
  ;; package which moves directories of other packages to sane locations.
  (svg-lib-icons-dir (no-littering-expand-var-file-name "svg-lib/cache/")) ; Change cache dir
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter) ; Enable `kind-icon'
  (setq kind-icon-default-style '(:padding -1 :stroke 0 :margin 0 :radius 0 :height 0.4 :scale 1.0))
  ;; Add hook to reset cache so the icon colors match my theme
  ;; NOTE 2022-02-05: This is a hook which resets the cache whenever I switch
  ;; the theme using my custom defined command for switching themes. If I don't
  ;; do this, then the backgound color will remain the same, meaning it will not
  ;; match the background color corresponding to the current theme. Important
  ;; since I have a light theme and dark theme I switch between. This has no
  ;; function unless you use something similar
  (add-hook 'kb/themes-hooks #'(lambda () (interactive) (kind-icon-reset-cache))))
(use-package elixir-mode
  :config
  (font-lock-add-keywords 'elixir-mode
                          '(("\\([_a-zA-Z0-9!?]+\\):" 1 'default)
                            (":[_a-zA-Z0-9\"!?]+" . font-lock-constant-face)
                            ("defmacro \\([a-zA-Z0-9!?_]+\\)" 1 font-lock-function-name-face)
                            ("\\_<@[_a-zA-Z0-9!?]+\\_>" . 'default)
                            ("\\_<true\\_>" . font-lock-constant-face)
                            ("\\_<false\\_>" . font-lock-constant-face)
                            ("\\_<nil\\_>" . font-lock-constant-face)
                            ("\\_<_[a-zA-Z0-9]*\\_>" . '+elixir-dim-face)))

  (modify-syntax-entry ?& "'" elixir-mode-syntax-table)
  )

(provide 'init-completion)

;;; ../.dotfiles/doom/.doom.d/config-key-binding.el -*- lexical-binding: t; -*-

(map! (:after evil
       :m "M" nil))

(map! :nm "m" #'expreg-expand)
;; (map! :m "M" #'expreg-contract)


(map! :leader
      :desc "Switch to last buffer"
      "ESC" #'evil-switch-to-windows-last-buffer)

;; (map! :leader
;;       :desc "Capture something"
;;       "x" #'org-capture)

;; (map! :leader
;;       :desc "pop up a persisitent buffer"
;;       "X" #'doom/open-scratch-buffer)

(map! :leader
      (:prefix ("d" . "smerge")
               "n"  #'smerge-next
               "a"  #'smerge-keep-all
               "u"  #'smerge-keep-upper
               "l"  #'smerge-keep-lower
               ))

(after! vterm
  (map! :map vterm-mode-map
        :i "M-1" #'+workspace/switch-to-0
        :i "M-2" #'+workspace/switch-to-1
        :i "M-3" #'+workspace/switch-to-2
        :i "M-4" #'+workspace/switch-to-3
        :i "M-5" #'+workspace/switch-to-4
        :i "M-6" #'+workspace/switch-to-5
        :i "M-7" #'+workspace/switch-to-6
        :i "M-8" #'+workspace/switch-to-7
        :i "M-9" #'+workspace/switch-to-final
        :i "M-`" #'+workspace/other
        :i "M-n" #'+workspace/new
        :i "M-TAB" #'+workspace/display))

;; (map! :after elixir-mode
;;       :map elixir-mode-map
;;       :leader
;;       :n "c f" #'lsp-format-buffer
;;       :n "m c" #'+elixir-test-current-file)

;;; ../.dotfiles/doom/.doom.d/config-key-binding.el -*- lexical-binding: t; -*-

(map! :nv
      "m" #'er/expand-region)

(map! :leader
      :desc "Capture something"
      "x" #'org-capture)

(map! :leader
      :desc "pop up a persisitent buffer"
      "X" #'doom/open-scratch-buffer)

(map! :leader
      (:prefix ("d" . "smerge")
       "n"  #'smerge-next
       "a"  #'smerge-keep-all
       "u"  #'smerge-keep-upper
       "l"  #'smerge-keep-lower
       ))

;; (map! :after elixir-mode
;;       :map elixir-mode-map
;;       :leader
;;       :n "c f" #'lsp-format-buffer
;;       :n "m c" #'+elixir-test-current-file)

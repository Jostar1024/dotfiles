;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;; (package! another-package
;;   :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;;(package! this-package
;;  :recipe (:host github :repo "username/repo"
;;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;; (package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;; (package! builtin-package :recipe (:nonrecursive t))
;; (package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;; (package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;; (package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;; (unpin! pinned-package)
;; ...or multiple packages
;; (unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;; (unpin! t)

(package! elixir-mode)
(package! elixir-ts-mode)
(package! exunit)
(package! inf-iex
  :recipe (:host github :repo "DogLooksGood/inf-iex"))

(package! protobuf-mode)

(package! lsp-mode
  :recipe (:host github :repo "emacs-lsp/lsp-mode"))

(package! rime
  :recipe (:host github :repo "DogLooksGood/emacs-rime"))

(package! ligature
  :recipe (:host github :repo "mickeynp/ligature.el"))

;; org-mode
(package! ob-elixir)
(package! ob-restclient)
(package! org-appear :pin "ffbd742267ff81ba8433177fac5d7fe22b6d68a9")
(package! restclient)

(package! grpclient
  :pin "2104a89f81ccfefd7a3adb434336bf0887e513f6"
  :recipe (:host github :repo "Prikaz98/grpclient.el"))
(package! treesit-langs
  :recipe (:host github :repo "emacs-tree-sitter/treesit-langs")
  :pin "2594bd9fe8e640c7431f152cf789ad67b58e0be3")

(package! treesit-fold
  :recipe (:host github :repo "emacs-tree-sitter/treesit-fold")
  :pin "0e21e12560f0977d390e3d4af45020f0f6db1c15")

(package! expreg
  :recipe (:host github :repo "casouri/expreg")
  :pin "9950c07ec90293964baa33603f4a80e764b0a847")

(package! sqlite3)

(package! ediprolog)

(package! gptel :recipe (:nonrecursive t))

;; Janet
(package! janet-ts-mode
  :recipe (:host github :repo "sogaiu/janet-ts-mode"))

(package! ajrepl
  :recipe (:host github :repo "sogaiu/ajrepl" :files ("*.el" "ajrepl")))

(package! transpose-frame)

(package! mermaid-mode
  :recipe (:host github :repo "abrochard/mermaid-mode"))

(package! keyfreq)

(package! eat
  :recipe (:host codeberg :repo "akib/emacs-eat")
  :pin "c8d54d649872bfe7b2b9f49ae5c2addbf12d3b99")

(package! claude-code
  :recipe (:host github :repo "stevemolitor/claude-code.el" :branch "main" :depth 1
           :files ("*.el" (:exclude "images/*"))))

(package! stimmung-themes
  :recipe (:host github :repo "motform/stimmung-themes" :branch "master" :depth 1))

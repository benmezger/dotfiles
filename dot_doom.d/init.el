(doom! :completion
       (company
        +auto +tng)
       (ivy +fuzzy)

       :ui
       deft
       doom
       doom-quit
       hl-todo
       modeline
       nav-flash
       ophints
       doom-dashboard
       (popup
        +all
        +defaults)
       vc-gutter
       vi-tilde-fringe
       window-select
       workspaces
       zen
       (treemacs +lsp)

       :editor
       (evil +everywhere)
       file-templates
       (format +onsave)
       rotate-text
       snippets

       :emacs
       (undo +tree)
       dired
       electric
       ibuffer
       vc

       :term
       eshell

       :checkers
       spell
       grammar
       syntax

       :tools
       debugger
       (docker +lsp)
       editorconfig
       (eval +overlay)
       (lookup
        +docsets +dictionary)
       (lsp)
       (magit +forge)
       make
       biblio
       terraform

       :lang
       (cc +lsp)
       (yaml +lsp)
       data
       emacs-lisp
       (go +lsp)
       latex
       markdown
       (org
        +roam2
        +hugo
        +journal
        +gnuplot
        +pancoc
        +dragndrop
        +journal)
       plantuml
       (python +pyenv +lsp +pyright +poetry)
       rest
       (rust +eglot)
       (sh +lsp)
       (javascript +lsp +tree-sitter)
       (ledger)

       :email
       (notmuch +org)

       :app
       (rss +org)
       irc

       :config
       (default +bindings +smartparens))

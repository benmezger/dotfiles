(doom! :completion
       (company
        +auto +tng)
       (ivy +fuzzy)

       :ui
       deft
       doom
       doom-quit
       fill-column
       hl-todo
       modeline
       nav-flash
       ophints
       (popup
        +all
        +defaults)
       vc-gutter
       vi-tilde-fringe
       window-select
       workspaces

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
        +docsets)
       (lsp)
       (magit +forge)
       make
       terraform
       biblio

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
       (python +pyenv +lsp)
       rest
       (rust +eglot)
       (sh +lsp)

       :email
       (mu4e +gmail)

       :app
       (rss +org)

       :config
       (default +bindings +smartparens))

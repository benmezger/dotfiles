(use-package evil
    :ensure t
    :defer .1 ;; don't block emacs when starting, load evil immediately after startup
    :init
        (setq evil-want-integration nil) ;; required by evil-collection
        (setq evil-search-module 'evil-search)
        (setq evil-ex-complete-emacs-commands nil)
        (setq evil-vsplit-window-right t) ;; like vim's 'splitright'
        (setq evil-split-window-below t) ;; like vim's 'splitbelow'
        (setq evil-shift-round nil)
        (setq evil-want-C-u-scroll t)
        (setq evil-want-keybinding nil)
    :config
        (evil-mode)

    ;; vim-like keybindings everywhere in emacs
    (use-package evil-collection
        :after evil
        :ensure t
        :config
            (evil-collection-init))

    ;; * operator in vusual mode
    (use-package evil-visualstar
        :ensure t
        :bind (:map evil-visual-state-map
            ("*" . evil-visualstar/begin-search-forward)
            ("#" . evil-visualstar/begin-search-backward)))

    ;; ex commands, which a vim user is likely to be familiar with
    (use-package evil-expat
        :ensure t
        :defer t)

    ;; visual hints while editing
    (use-package evil-goggles
        :ensure t
        :config
            (evil-goggles-use-diff-faces)
            (evil-goggles-mode))
            (message "Loading evil-mode...done"))


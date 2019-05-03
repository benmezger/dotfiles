(use-package evil
  :ensure t
  :defer .1 ;; don't block emacs when starting, load evil immediately after startup
  :init
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t) ;; like vim's 'splitright'
  (setq evil-split-window-below t) ;; like vim's 'splitbelow'
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)
  (setq evil-emacs-state-modes nil)
  (setq evil-insert-state-modes nil)
  (setq evil-motion-state-modes nil)
  (setq evil-emacs-state-cursor '("red" hbar))
  (setq evil-normal-state-cursor '("green" hbar))
  (setq evil-visual-state-cursor '("orange" hbar))
  (setq evil-insert-state-cursor '("red" hbar))
  (setq evil-replace-state-cursor '("red" hbar))
  (setq evil-operator-state-cursor '("red" hbar))
  (add-hook 'after-save-hook #'evil-normal-state)
  :config
  (evil-mode)

  ;; vim-like keybindings everywhere in emacs
  (use-package evil-collection
    :after evil
    :ensure t
    :config
    :custom (evil-collection-setup-minibuffer t)
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

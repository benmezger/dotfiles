(use-package evil-expat
  :ensure t
  :defer t
  :init
  ;; Set want-keybinding to nil before loading evil or evil collection.
  ;; See https://github.com/emacs-evil/evil-collection/issues/60 for more details.
  (setq evil-want-keybinding nil)
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC> ,")
  (evil-leader/set-key "e" 'find-file)
  (evil-leader/set-key "g" 'helm-do-grep-ag)
  (evil-leader/set-key "f" 'helm-projectile)
  (evil-leader/set-key "b" 'bookmark-jump)
  (evil-leader/set-key "w" 'elpy-goto-definition))

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
  (setq evil-want-keybinding t)
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

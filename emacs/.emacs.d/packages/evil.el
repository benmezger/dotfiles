(use-package evil-expat
  :ensure t
  :defer .1
  :init
  ;; Set want-keybinding to nil before loading evil or evil collection.
  ;; See https://github.com/emacs-evil/evil-collection/issues/60 for more details.
  (setq evil-want-keybinding nil)
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC> ,")
 ;; (evil-leader/set-key "e" 'find-file)
 ;; (evil-leader/set-key "g" 'helm-do-grep-ag)
 ;; (evil-leader/set-key "f" 'helm-projectile)
 ;; (evil-leader/set-key "b" 'bookmark-jump)
 ;; (evil-leader/set-key "w" 'elpy-goto-definition))

  ; general
  (evil-leader/set-key "e" 'find-file)
  (evil-leader/set-key "r" 'counsel-rg)
  (evil-leader/set-key "f" 'counsel-projectile)
  (evil-leader/set-key "d" 'counsel-bookmark)
  (evil-leader/set-key "v" 'ivy-resume)
  (evil-leader/set-key "i" 'counsel-imenu)
  (evil-leader/set-key "y" 'counsel-yank-pop)
  (evil-leader/set-key "c" 'counsel-git-checkout)
  (evil-leader/set-key "<SPC>" 'counsel-M-x)

  ;; window
  (evil-leader/set-key "w v" 'split-window-vertically)
  (evil-leader/set-key "w h" 'split-window-horizontally)
  (evil-leader/set-key "w d" 'delete-window)
  (evil-leader/set-key "w o" 'delete-other-windows)
  (evil-leader/set-key "w d" 'kill-buffer-and-window)

  ;; buffers
  (evil-leader/set-key "b" 'counsel-switch-buffer)
  (evil-leader/set-key "k b" 'kill-buffer)

  ;; lists
  (evil-leader/set-key "l l" 'counsel-locate)

  ;; git
  (evil-leader/set-key "g b c" 'magit-branch-checkout)
  ;; g b n of git create new branch and checkout, due to c belonging to magit-checkout
  (evil-leader/set-key "g b n" 'magit-branch-and-checkout)
  (evil-leader/set-key "g s" 'magit-status)
  (evil-leader/set-key "g l" 'magit-log-current)
  (evil-leader/set-key "g d u" 'magit-diff-unstaged)
  (evil-leader/set-key "g c" 'magit-commit)
  (evil-leader/set-key "g p" 'magit-push-current-to-upstream)
   ;; g g as of "git get", due to the use of p for magit-push-current-to-upstream
  (evil-leader/set-key "g g" 'magit-pull-from-upstream)
  ;; g a of "git add modified/buffer/untracked due to g s which is for magit-status
  (evil-leader/set-key "g a m" 'magit-stage-modified)
  (evil-leader/set-key "g a b" 'magit-stage-file)
  (evil-leader/set-key "g a u" 'magit-stage-untracked)

  (evil-leader/set-key "g m m" 'magit-merge-plain)
  (evil-leader/set-key "g m p" 'magit-merge-preview)

  (evil-leader/set-key "p p" 'counsel-projectile-switch-project)
  (evil-leader/set-key "p k" 'projectile-kill-buffers)

  ;; m = mode
  ;; d = definition
  ;; m w = mode go to definition
  ;; (evil-leader/set-key-for-mode 'c-mode "m g" 'counsel-etags-find-tag-at-point)
  ;; (evil-leader/set-key-for-mode 'python-mode "m d" 'elpy-goto-definition-other-window)

  (evil-leader/set-key-for-mode 'c-mode "m f d" 'xref-find-definitions)
  (evil-leader/set-key-for-mode 'python-mode "m f d" 'xref-find-definitions))

(use-package evil
  :ensure t
  :defer .1 ;; don't block emacs when starting, load evil immediately after startup
  :init
  (setq-default search-invisible t)
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
  (defun evil-normalize-all-buffers ()
    "Force a drop to normal state."
    (unless (eq evil-state 'normal)
      (dolist (buffer (buffer-list))
        (set-buffer buffer)
        (unless (or (minibufferp)
                  (eq evil-state 'emacs))
          (evil-force-normal-state)))))

  (defvar evil-normal-timer
    (run-with-idle-timer 30 t #'evil-normalize-all-buffers)
    "Drop back to normal state after idle for 30 seconds.")

  ;; vim-like keybindings everywhere in emacs
  (use-package evil-collection
    :after evil
    :defer .1
    :ensure t
    :custom (evil-collection-setup-minibuffer t))

  ;; * operator in vusual mode
  (use-package evil-visualstar
    :ensure t
    :defer .1
    :bind (:map evil-visual-state-map
                ("*" . evil-visualstar/begin-search-forward)
                ("#" . evil-visualstar/begin-search-backward)))

  ;; ex commands, which a vim user is likely to be familiar with
  (use-package evil-expat
    :ensure t
    :defer .1)

  ;; visual hints while editing
  (use-package evil-goggles
    :ensure t
    :defer .1
    :config
    (evil-goggles-use-diff-faces)
    (evil-goggles-mode))

  (use-package evil-magit
    :ensure t
    :defer .1)

  (use-package evil-leader
    :ensure t))

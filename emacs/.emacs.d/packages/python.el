(use-package pyenv-mode
    :init
    :ensure t
    :config (pyenv-mode)

    (setenv "WORKON_HOME" "~/.pyenv/versions/")
    (add-to-list 'exec-path "~/.pyenv/shims")
    (add-hook 'projectile-switch-project-hook 'projectile-pyenv-mode-set)
    (add-hook 'python-mode-hook 'pyenv-mode))

(use-package pyenv-mode-auto
   :ensure t)

(use-package elpy
    :ensure t
    :defer t
    :init
    (advice-add 'python-mode :before 'elpy-enable))


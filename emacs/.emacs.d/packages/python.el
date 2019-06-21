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
  :config
  (setq elpy-modules (delete 'elpy-module-highlight-indentation elpy-modules))
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  (add-hook 'elpy-mode-hook
    (lambda ()
      (add-hook 'before-save-hook 'elpy-black-fix-code nil 'local)))) ;

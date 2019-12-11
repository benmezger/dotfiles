(use-package pyenv-mode
  :ensure t
  :defer 1
  :config (pyenv-mode)
  :init
  (setenv "WORKON_HOME" "~/.pyenv/versions/")
  (add-to-list 'exec-path "~/.pyenv/shims")
  (add-hook 'projectile-switch-project-hook 'projectile-pyenv-mode-set)
  (add-hook 'python-mode-hook 'pyenv-mode))
;;
(use-package pyenv-mode-auto
  :ensure t)

(use-package blacken
  :ensure t
  :config
  (add-hook 'python-mode-hook 'blacken-mode))

;;(use-package elpy
;;  :ensure t
;;  :after (pyenv-mode pyenv-mode-auto)
;;  :defer t
;;  :config
;;  (setq elpy-modules (delete 'elpy-module-highlight-indentation elpy-modules))
;;  :init
;;  (advice-add 'python-mode :before 'elpy-enable)
;;  (add-hook 'elpy-mode-hook
;;    (lambda ()
;;      (add-hook 'before-save-hook 'elpy-black-fix-code nil 'local)))) ;

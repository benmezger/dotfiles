(use-package projectile
  :ensure t
  :defer 2
  :bind (("C-c p" . projectile-command-map))
  :init
  (setq projectile-completion-system 'ivy)
  (setq projectile-indexing-method 'alien)
  (setq projectile-cache-file (concat emacs-cache-directory
                                "projectile.cache"))
  (setq projectile-enable-caching t)
  (setq projectile-sort-order 'recently-active)
  (setq projectile-project-search-path '("~/workspace/"))
  ;; (setq projectile-completion-system 'helm)
  (projectile-mode 1)

  (setq projectile-known-projects-file (concat emacs-cache-directory
                                         "projectile-bookmarks.eld")))

  ;; switch python version together with current project
  ;; (require 'pyenv-mode)
  ;; (defun projectile-pyenv-mode-set ()
  ;;   "Set pyenv version matching project name."
  ;;   (let ((project (projectile-project-name)))
  ;;     (if (member project (pyenv-mode-versions))
  ;;       (pyenv-mode-set project)
  ;;       (pyenv-mode-unset))))
  ;; (add-hook 'projectile-after-switch-project-hook 'projectile-pyenv-mode-set))

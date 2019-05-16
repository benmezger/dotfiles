(use-package projectile
  :ensure t
  :defer t
  :bind (("C-c p" . projectile-command-map))
  :init
  (setq projectile-indexing-method 'alien)
  (setq projectile-enable-caching t)
  (setq projectile-project-search-path '("~/workspace/"))
  (setq projectile-completion-system 'helm)
  (projectile-mode 1))

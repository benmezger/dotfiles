(use-package projectile
  :ensure t
  :defer t
  :bind (("C-c p" . projectile-command-map))
  :init
  (setq projectile-indexing-method 'native)
  (setq projectile-enable-caching t)
  (setq projectile-project-search-path '("~/workspace/"))
  (projectile-mode 1))

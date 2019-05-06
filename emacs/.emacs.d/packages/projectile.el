(use-package projectile
  :ensure t
  :defer t
  :bind (("C-c p" . projectile-command-map))
  :init
  (projectile-mode 1))

(use-package centaur-tabs
  :demand
  :defer .1
  :config
  (setq centaur-tabs-set-modified-marker t)
  (setq centaur-tabs-modified-marker "*")
  (setq centaur-tabs-style "bar")
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-gray-out-icons 'buffer)
  (setq centaur-tabs-set-bar 'over)
  (setq centaur-tabs-set-close-button nil)
  (centaur-tabs-inherit-tabbar-faces)

  (centaur-tabs-enable-buffer-reordering)
  (centaur-tabs-group-by-projectile-project)

  (centaur-tabs-mode t)
  :bind
  (:map evil-normal-state-map
    ("g t" . centaur-tabs-forward)
    ("g T" . centaur-tabs-backward)))

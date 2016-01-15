;; projectile

(projectile-global-mode)

(setq projectile-indexing-method 'native)
(setq projectile-enable-caching t)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

(provide 'setup-projectile)

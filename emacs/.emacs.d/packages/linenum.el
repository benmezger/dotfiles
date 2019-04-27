(use-package linum-relative
  :ensure t
  :config
  (setq linum-relative-backend 'display-line-numbers-mode)
  (global-linum-mode)
  (linum-relative-mode))

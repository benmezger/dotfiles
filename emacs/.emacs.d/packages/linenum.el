(use-package linum-relative
  :ensure t
  :config
  (require 'linum-relative)
  (global-linum-mode)
  (linum-relative-mode)
  (setq linum-relative-backend 'display-line-numbers-mode)
  (setq linum-relative-current-symbol ""))

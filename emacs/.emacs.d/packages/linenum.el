(use-package linum-relative
  :ensure t
  :config
  (require 'linum-relative)
  (global-linum-mode)
  (linum-relative-mode)
  (set-face-attribute 'linum nil :height 115)
  (setq linum-relative-backend 'display-line-numbers-mode)
  (setq linum-relative-current-symbol ""))

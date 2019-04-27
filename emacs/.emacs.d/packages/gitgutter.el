(use-package git-gutter-fringe+
  :ensure t
  :config
  (use-package fringe-helper)
  (require 'git-gutter-fringe+)

  (setq-default left-fringe-width  15)
  (global-git-gutter+-mode))

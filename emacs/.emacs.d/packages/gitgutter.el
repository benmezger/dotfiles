(use-package git-gutter-fringe+
  :ensure t
  :config
  (use-package fringe-helper)
  (require 'git-gutter-fringe+)
  (setq git-gutter-fr+-side 'right-fringe)
  (setq-default right-fringe-width 15)
  (global-git-gutter+-mode))

(use-package undo-tree
  :diminish undo-tree-mode
  :defer 2
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

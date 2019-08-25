(use-package undo-tree
  :diminish undo-tree-mode
  :defer 2
  :config
  (progn
    (global-undo-tree-mode t)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)
    (setq undo-tree-history-directory-alist
      `((".*" . ,(concat emacs-cache-directory "undo"))))))

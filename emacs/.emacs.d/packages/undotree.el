(use-package undo-tree
  :diminish undo-tree-mode
  :defer 2
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)
    (setq undo-tree-auto-save-history t
      undo-tree-history-directory-alist
      `(("." . ,(concat emacs-cache-directory "undo"))))
    (unless (file-exists-p (concat emacs-cache-directory "undo"))
      (make-directory (concat emacs-cache-directory "undo")))))

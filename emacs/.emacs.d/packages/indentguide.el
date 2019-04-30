(use-package highlight-indent-guides
  :ensure t
  :defer 2
  :config
  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-responsive 'stack)
  :init
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

(use-package flycheck
  :ensure t
  :defer 5
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enable))
  (global-flycheck-mode 1))

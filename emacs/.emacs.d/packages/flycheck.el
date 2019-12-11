(use-package flycheck
  :ensure t
  :defer 5
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enable))
  (global-flycheck-mode 1))

(use-package flycheck-irony
  :ensure t
  :requires flycheck
  :defer 5
  :config
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup)))

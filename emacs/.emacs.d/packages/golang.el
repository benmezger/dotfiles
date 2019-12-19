(use-package go-mode
  :ensure t
  :defer 1
  :config
  (add-hook 'before-save-hook #'gofmt-before-save))

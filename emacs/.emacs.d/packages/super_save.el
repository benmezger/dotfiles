(use-package super-save
  :ensure t
  :config
  (setq super-save-auto-save-when-idle t)
  (add-to-list 'super-save-hook-triggers 'find-file-hook)
  (super-save-mode +1))

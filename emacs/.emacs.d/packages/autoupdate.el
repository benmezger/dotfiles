(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t
    auto-package-update-interval 4)
  (auto-package-update-maybe))

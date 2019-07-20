(use-package all-the-icons-dired
  :defer .1
  :init
  (unless (member "all-the-icons" (font-family-list))
    (all-the-icons-install-fonts t))
  :hook (dired-mode . all-the-icons-dired-mode))

;;(use-package mode-icons
;;  :config
;;  (mode-icons-mode))

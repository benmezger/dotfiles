(use-package all-the-icons-dired
  :init
  (unless (member "all-the-icons" (font-family-list))
    (all-the-icons-install-fonts t))
  :hook (dired-mode . all-the-icons-dired-mode))

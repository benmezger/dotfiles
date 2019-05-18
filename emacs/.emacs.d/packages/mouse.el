(use-package disable-mouse
  :ensure t
  :config
  (global-disable-mouse-mode)

  (mapc #'disable-mouse-in-keymap
  (list evil-motion-state-map
        evil-normal-state-map
        evil-visual-state-map
        evil-insert-state-map)))

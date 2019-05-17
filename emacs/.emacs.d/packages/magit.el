;; magit for git
(use-package magit
  :ensure t
  :defer 2
  :config
  (require 'evil-magit)
  (setq magit-completing-read-function 'ivy-completing-read)

  :bind (("C-x g" . magit-status)))

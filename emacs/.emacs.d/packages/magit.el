;; magit for git
(use-package magit
  :ensure t
  :defer 2
  :config
  (require 'evil-magit)
  :bind (("C-x g" . magit-status)))

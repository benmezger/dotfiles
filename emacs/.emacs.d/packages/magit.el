;; magit for git
(use-package magit
  :ensure t
  :defer 2
  :config
  (require 'evil-magit)
  (setq magit-completing-read-function 'ivy-completing-read)

  (defun mu-magit-kill-buffers ()
    "Restore window configuration and kill all Magit buffers."
    (interactive)
    (let ((buffers (magit-mode-get-buffers)))
      (magit-restore-window-configuration)
      (mapc #'kill-buffer buffers)))

  (bind-key "q" #'mu-magit-kill-buffers magit-status-mode-map)

  :bind (("C-x g" . magit-status)))

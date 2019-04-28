;; rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t
  :init
  (show-paren-mode t)
  (progn
    (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)))

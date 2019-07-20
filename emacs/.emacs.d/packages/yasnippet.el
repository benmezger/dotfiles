(use-package yasnippet
  :ensure t
  :defer 2
  :init
  (setq yas-snippet-dirs
        '("~/.emacs.d/snippets"))
  (yas-global-mode 1))

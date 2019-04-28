;; (use-package smart-mode-line-atom-one-dark-theme
;; :ensure t)

(use-package smart-mode-line
  :ensure t
  :config
  ;; (setq sml/theme 'atom-one-dark)
  (setq sml/no-confirm-load-theme t)
  (add-to-list 'sml/replacer-regexp-list '("^~/workspace/" " :WP: ") t)
  (sml/setup))

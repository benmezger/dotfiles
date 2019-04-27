
;; orgmode
(use-package org
  :ensure t
  :mode ("\\.org\\'" . org-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda))
  :config
  (progn
    (setq org-directory "~/org")
    (setq org-log-done t)
    (setq org-todo-keywords
          '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))))

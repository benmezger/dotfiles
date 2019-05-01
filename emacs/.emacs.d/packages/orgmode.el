
;; orgmode
(use-package org
  :ensure t
  :mode ("\\.org\\'" . org-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  (progn
    (setq org-directory "~/orgs")
    (setq org-default-notes-file "~/orgs/todos.org")
    (setq org-log-done t)
    (setq org-todo-keywords
          '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))))


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
    (setq org-agenda-files '("~/orgs"))
    (setq org-default-notes-file "~/orgs/todos.org")
    (setq org-log-done t)
    (setq org-todo-keywords
          '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
    (setq org-agenda-include-diary t)
    (setq org-agenda-include-all-todo t)))

(use-package org-journal
  :ensure t
  :defer t
  :custom
  (org-journal-dir "~/orgs/journal/")
  (org-journal-date-format "%A, %d %B %Y"))

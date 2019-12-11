
;; orgmode
(use-package org
  :defer 2
  :ensure t
  :mode (("\\.org\\'" . org-mode)
          ("\\.text\\'" . org-mode)
          ("\\.text\\'" . org-mode)
          ("\\.org.\\gpg'" . org-mode))
  :bind (("C-c l" . org-store-link)
          ("C-c a" . org-agenda)
          ("C-c c" . org-capture))
  :config
  (progn
    (setq org-directory "~/orgs")
    (setq org-agenda-files '("~/orgs/inbox.org.gpg"
                              "~/orgs/gtd.org.gpg"
                              "~/orgs/tickler.org.gpg"))
    (setq org-capture-templates '(("t" "Todo [inbox]" entry
                                    (file+headline "~/orgs/inbox.org.gpg" "Tasks")
                                    "* TODO %i%?")
                                   ("T" "Tickler" entry
                                     (file+headline "~/orgs/tickler.org.gpg" "\nTickler")
                                     "* %i%? \n %U")
                                   ("G" "GTD" entry
                                     (file+headline "~/orgs/gtd.org.gpg" "\nGet things done (GTD)")
                                     "* %i%? \n %U")
                                   ))
    (setq org-agenda-custom-commands
      '(("w" "At work" tags-todo "@work"
          ((org-agenda-overriding-header "Work")
            (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
         ("h" "At home" tags-todo "@home"
           ((org-agenda-overriding-header "Home")
             (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
         ))
    (setq org-refile-targets '(("~/orgs/gtd.org.gpg" :maxlevel . 3)
                                ("~/orgs/someday.org.gpg" :level . 1)
                                ("~/orgs/tickler.org.gpg" :maxlevel . 2)))
    (setq org-log-done t)
    (setq-default org-display-custom-times t)
    (setq org-time-stamp-custom-formats '("<%a %b %e %Y>" . "<%a %b %e %Y %H:%M>"))
    (setq org-src-fontify-natively t)
    (setq org-todo-keywords
      '((sequence "☛ TODO(t)" " ⚑ WAITING(w)" "|" "✔ DONE(d)" "✘ CANCELLED(c)")))

    (add-hook 'org-mode-hook 'org-indent-mode)
    (defun my-org-agenda-skip-all-siblings-but-first ()
      "Skip all but the first non-done entry."
      (let (should-skip-entry)
        (unless (org-current-is-todo)
          (setq should-skip-entry t))
        (save-excursion
          (while (and (not should-skip-entry) (org-goto-sibling t))
            (when (org-current-is-todo)
              (setq should-skip-entry t))))
        (when should-skip-entry
          (or (outline-next-heading)
            (goto-char (point-max))))))
    (defun org-current-is-todo ()
      (or (string= "TODO" (org-get-todo-state))
        (string= "WAITING" (org-get-todo-state))
        (string= "SCHEDULED" (org-get-todo-state))))))

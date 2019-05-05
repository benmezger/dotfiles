
;; orgmode
(use-package org
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
    (setq org-agenda-files '("~/orgs"))
    (setq org-agenda-include-diary t)
    (setq org-agenda-include-all-todo t)
    (setq org-default-notes-file "~/orgs/todos.org.gpg")
    (setq org-log-done t)
    (setq-default org-display-custom-times t)
    (setq org-time-stamp-custom-formats '("<%a %b %e %Y>" . "<%a %b %e %Y %H:%M>"))
    (setq org-src-fontify-natively t)
    (add-hook 'org-mode-hook 'org-indent-mode)
    (setq org-todo-keywords
      '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))))

(use-package org-journal
  :ensure t
  :defer t
  :bind (("C-c C-j" . org-journal-new-entry))
  :custom
  (org-journal-dir "~/orgs/journal/")
  (org-journal-date-format "%A, %d %B %Y")
  :config
  (setq org-journal-enable-agenda-integration t)
  (setq org-agenda-file-regexp "\\`\\\([^.].*\\.org\\\|[0-9]\\\{8\\\}\\\(\\.gpg\\\)?\\\)\\'")
  (setq org-journal-enable-encryption t)
  (setq org-journal-file-format "%Y%m%d.org")
  (setq org-journal-encrypt-journal t)
  (setq org-journal-time-prefix "* ")
  (setq org-crypt-key "0xAC7A30843ADC0D65")
  (add-to-list 'org-modules 'org-crypt)
  (add-to-list 'org-agenda-files org-journal-dir)
  (require 'org-crypt)
  (defun org-journal-save-entry-and-exit()
    "Simple convenience function.
  Saves the buffer of the current day's entry and kills the window
  Similar to org-capture like behavior"
    (interactive)
    (save-buffer)
    (kill-buffer-and-window))
  (define-key org-journal-mode-map (kbd "C-x C-s") 'org-journal-save-entry-and-exit))

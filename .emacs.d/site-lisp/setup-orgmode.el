;; Org mode package configuration
(require 'org)

(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on

;; keybindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(define-key global-map "\C-cc" 'org-capture)

(setq org-log-done t)

;; org-mode directory
(setq org-directory "~/Documents/org")
(setq org-agenda-files '("~/Documents/org"))
(setq org-src-fontify-natively t)

;; indent hook
(add-hook 'org-mode-hook
          (lambda ()
            (org-indent-mode t))
          t)

; quick notes
(setq org-default-notes-file (expand-file-name "~/Documents/org/refile.org"))

;; custom todo-keywords
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
        (sequence "FEEDBACK(e)" "|" "VERIFY(v)")
        (sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")
        (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELED(c@/!)")))

;;  changing from any task todo state to any other state directly
(setq org-use-fast-todo-selection t)

;;  The tags are used to filter tasks in the agenda views conveniently.
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

;; show all agenda headings
(setq org-refile-targets '((org-agenda-files . (:maxlevel . 6))))

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/Documents/org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/Documents/org/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/Documents/org/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/Documents/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/Documents/org/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/Documents/org/refile.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/Documents/org/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/Documents/org/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

;; Remove empty LOGBOOK drawers on clock out
(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at (point))))

(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

;; keep agenda fast
(setq org-agenda-span 'day)

;; custom date format
(setq-default org-display-custom-times t)
(setq org-time-stamp-custom-formats '("<%d-%m-%Y %a>" . "<%d-%m-%Y %a %H:%M>"))

;; active Org-babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (C . t)
   (java . t)
   (makefile . t)
   (perl . t)
   (ruby . t)
   (R . t)
   (sh . t)
   (sql . t)
   (latex . t)
   (plantuml . t)))

;; plantuml support for UML
(setq org-plantuml-jar-path
      (expand-file-name "~/workspace/plantuml.jar"))

(add-hook 'org-mode-hook
          '(lambda ()
             (setq org-file-apps
                   '((auto-mode . emacs)
                     ("\\.mm\\'" . default)
                     ("\\.x?html?\\'" . default)
                     ("\\.pdf\\'" . "zathura %s")))))

;; set default major mode :)
(setq-default major-mode 'org-mode)

(provide 'setup-orgmode)

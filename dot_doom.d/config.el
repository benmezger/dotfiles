;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-monokai-spectrum
      display-line-numbers-type t
      default-directory "~/"
      command-line-default-directory "~/")

(display-time-mode 1)
(display-battery-mode 1)
(toggle-frame-maximized)
(setq auth-sources '("~/.authinfo" "~/.authinfo.gpg" "~/.netrc"))
(setq-default enable-local-variables t)

(after! (:or lsp-mode lsp)
  :config
  (setq lsp-response-timeout 90000))

(after! company-lsp
  :config
  (push 'company-lsp company-backends)
  (setq company-lsp-async t)
  (setq company-lsp-cache-candidates t)
  (setq company-lsp-enable-recompletion t))

(after! company
  :config
  (setq company-selection-wrap-around t)
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0))

(after! doom-modeline
  :config

  ;;(set-face-attribute 'mode-line nil :family "Hack" :height 125)
  ;;(set-face-attribute 'mode-line-inactive nil :family "Hack" :height 125)

  (setq doom-modeline-buffer-file-name-style 'truncate-upto-project)

  (setq doom-modeline-icon (display-graphic-p))
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)

  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-buffer-modification-icon t)

  (setq doom-modeline-enable-word-count t)
  (setq doom-modeline-buffer-encoding t)
  (setq doom-modeline-indent-info t)

  (setq doom-modeline-mu4e t)
  (setq doom-modeline-irc t)

  (setq doom-modeline-env-version t)
  (setq doom-modeline-env-load-string "...")

  ;; Don’t compact font caches during GC.
  (setq inhibit-compacting-font-caches t))

(after! flycheck
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enable))
  (setq flycheck-tidyrc "~/.config/tidyrc"))

(after! ivy
  :config
  (setq enable-recursive-minibuffers t)

  ;; enable this if you want `swiper' to use it
  (setq search-default-mode #'char-fold-to-regexp)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (counsel-rg . ivy--regex-plus)
          (t      . ivy--regex-fuzzy)))

  (setq ivy-bibtex-default-action 'ivy-bibtex-insert-key)

  (defun eh-ivy-return-recentf-index (dir)
    (when (and (boundp 'recentf-list)
               recentf-list)
      (let ((files-list
             (cl-subseq recentf-list
                        0 (min (- (length recentf-list) 1) 20)))
            (index 0))
        (while files-list
          (if (string-match-p dir (car files-list))
              (setq files-list nil)
            (setq index (+ index 1))
            (setq files-list (cdr files-list))))
        index)))

  (defun eh-ivy-sort-file-function (x y)
    (let* ((x (concat ivy--directory x))
           (y (concat ivy--directory y))
           (x-mtime (nth 5 (file-attributes x)))
           (y-mtime (nth 5 (file-attributes y))))
      (if (file-directory-p x)
          (if (file-directory-p y)
              (let ((x-recentf-index (eh-ivy-return-recentf-index x))
                    (y-recentf-index (eh-ivy-return-recentf-index y)))
                (if (and x-recentf-index y-recentf-index)
                    ;; Directories is sorted by `recentf-list' index
                    (< x-recentf-index y-recentf-index)
                  (string< x y)))
            t)
        (if (file-directory-p y)
            nil
          ;; Files is sorted by mtime
          (time-less-p y-mtime x-mtime)))))

  (add-to-list 'ivy-sort-functions-alist
               '(read-file-name-internal . eh-ivy-sort-file-function)))


(after! org
  :config

  (setq
   org-log-done 'time
   org-clock-persist 'history
   org-directory "~/workspace/org"
   org-archive-location ".archives/%s_archive::"
   org-agenda-files (list org-directory)
   org-log-into-drawer t
   org-agenda-inhibit-startup t
   bibtex-completion-bibliography (concat org-directory "/bibliography.bib")
   org-todo-keywords '((sequence "TODO(t!)" "CURRENT(u!)" "WAIT(w@/!)" "NEXT(n!)" "PROJ(o!)" "|")
                       (sequence "READ(!)")
                       (sequence "|" "DONE(d!)" "CANCELED(c!)"))
   org-todo-keyword-faces '(("CURRENT"  . "orange")
                            ("TODO" . "systemRedColor")
                            ("READ" . "systemOrangeColor")
                            ("HOLD"  . "indianRed")
                            ("WAIT" . "salmon1")
                            ("PROJ" . "systemYellowColor"))
   org-capture-template-dir (concat doom-private-dir "org-captures/")
   org-capture-templates
   `(
     ("c" "Code" entry (file "~/workspace/org/code.org")
      (file ,(concat org-capture-template-dir "code-snippet.capture")))
     ("i" "Inbox" entry (file+datetree "~/workspace/org/inbox.org")
      (file ,(concat org-capture-template-dir "inbox-snippet.capture")))
     ("j" "Journal" entry (file+datetree "~/workspace/org/journal.org")
      (file ,(concat org-capture-template-dir "journal.capture")))
     ("b" "Blog post" entry (file+olp "~/workspace/org/blog.org" "Posts")
      (file ,(concat org-capture-template-dir "blog-post.capture")))
     ("n" "Note" entry (file+olp "~/workspace/org/notes.org" "Inbox")
      "* %?\nEntered on %U\n  %i\n  %a")
     ("t" "Todo" entry (file "~/workspace/org/todos.org")
      "* TODO %?\n %i\n  %a")
     ("r" "Register new book" entry (file+olp "~/workspace/org/notes.org" "Books")
      (file ,(concat org-capture-template-dir "new-book.capture")))
     ("d" "Decision note" entry (file "~/workspace/org/decisions.org")
      (file ,(concat org-capture-template-dir "decision.capture")))
     ("w" "Weekly journal" entry (file+olp+datetree "~/workspace/org/journal/weekly.org" "Weekly notes")
      (file ,(concat org-capture-template-dir "weekly-journal.capture")) :tree-type week)
     ("e" "RRR" entry (file "~/workspace/org/rrr.org")
      (file ,(concat org-capture-template-dir "rrr.capture"))))
   ob-async-no-async-languages-alist '("gnuplot" "mermaid"))
  (setq-default org-catch-invisible-edits 'smart)

  (defun benmezger/org-mode-hook()
    (when (featurep! :completion company)
      (message "Disabling company-mode while in org-capture...")
      (company-mode -1)))
  (add-hook! org-capture-mode #'benmezger/org-mode-hook)

  ;; from: https://xenodium.com/emacs-dwim-do-what-i-mean/
  (defun benmezger/org-insert-link-dwim ()
    "Like `org-insert-link' but with personal dwim preferences."
    (interactive)
    (let* ((point-in-link (org-in-regexp org-link-any-re 1))
           (clipboard-url (when (string-match-p "^http" (current-kill 0))
                            (current-kill 0)))
           (region-content (when (region-active-p)
                             (buffer-substring-no-properties (region-beginning)
                                                             (region-end)))))
      (cond ((and region-content clipboard-url (not point-in-link))
             (delete-region (region-beginning) (region-end))
             (insert (org-make-link-string clipboard-url region-content)))
            ((and clipboard-url (not point-in-link))
             (insert (org-make-link-string
                      clipboard-url
                      (read-string
                       "title: "
                       (with-current-buffer (url-retrieve-synchronously clipboard-url)
                         (dom-text
                          (car (dom-by-tag (libxml-parse-html-region
                                            (point-min)
                                            (point-max))
                                           'title))))))))
            (t (call-interactively 'org-insert-link))))))

(after! (:or org-roam roam2)
  :defer t
  :config
  (setq
   org-roam-directory "~/workspace/org/roam"
   org-roam-index-file (concat org-roam-directory "/" "index.org")
   benmezger/org-roam-private-directory (concat org-roam-directory "/private")
   org-roam-capture-templates
   '(("d" "default" plain "%?"
      :if-new (file+head "%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                         "#+TITLE: ${title}
#+DATE: %T
#+FILETAGS: %^G
#+SETUPFILE: %(concat (file-name-as-directory org-directory) \"hugo.setup\")
#+HUGO_SLUG: ${slug}
#+HUGO_TAGS: %^{Hugo tags}
#+EXPORT_FILE_NAME: exports/%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}\" (current-time) t)

- Related pages
  -

------ ")
      :unnarrowed t)
     ("p" "private" plain "%?"
      :if-new (file+head "private/%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                         "#+TITLE: ${title}
#+DATE: %T
#+FILETAGS: :personal:%^G
#+HUGO_SLUG: ${slug}
#+EXPORT_FILE_NAME: exports/%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}\" (current-time) t)
")
      :unnarrowed t)))

  (defun custom-org-protocol-focus-advice (orig &rest args)
    (x-focus-frame nil)
    (apply orig args))

  (advice-add 'org-roam-protocol-open-ref :around
              #'custom-org-protocol-focus-advice)
  (advice-add 'org-roam-protocol-open-file :around
              #'custom-org-protocol-focus-advice)

  (defun benmezger/org-roam-node-insert-immediate (arg &rest args)
    (interactive "P")
    (let ((args (cons arg args))
          (org-roam-capture-templates
           (list (append (car org-roam-capture-templates)
                         '(:immediate-finish t)))))
      (apply #'org-roam-node-insert args)))
  (setq org-roam-dailies-directory "../journal/")
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry
           "* %?"
           :target (file+head "%<%Y-%m-%d>.org"
                              "#+TITLE: %<%Y-%m-%d>\n")))))

(after! (:or org org-roam)
  :defer t
  :config
  (push org-roam-directory org-agenda-files)
  (push benmezger/org-roam-private-directory org-agenda-files)

  (defun benmezger/org-roam-export-all ()
    "Re-exports all Org-roam files to Hugo markdown."
    (interactive)
    (dolist (f (org-roam--list-all-files))
      (with-current-buffer (find-file f)
        (when (s-contains? "SETUPFILE" (buffer-string))
          (org-hugo-export-wim-to-md)))))

  (setq org-hugo-external-file-extensions-allowed-for-copying
        '("jpg" "jpeg" "tiff" "png" "svg" "gif"
          "mp4" "pdf" "odt" "doc" "ppt" "xls"
          "docx" "pptx" "xlsx" "zip"))

  (remove-hook! 'find-file-hook #'+org-roam-open-buffer-maybe-h))

(after! (org-journal org)
  :defer t
  :config
  (setq org-journal-dir "~/workspace/org/journal")
  (push org-journal-dir org-agenda-files)
  (setq org-journal-enable-agenda-integration t)
  (setq org-journal-file-format "%Y%m%d.org"))

(after! deft
  :defer t
  :config
  (setq deft-directory "~/workspace/org"
        deft-extensions '("org" "md" "txt")
        deft-default-extension "org"
        deft-recursive t
        deft-use-filename-as-title nil
        deft-use-filter-string-for-filename t
        deft-file-naming-rules '((nospace . "-"))))

(after! doom-modeline
  :config
  (setq doom-modeline-continuous-word-count-modes
        '(markdown-mode gfm-mod)))

(use-package! py-isort
  :defer t
  :after python-mode
  :mode ("[./]flake8\\'" . conf-mode)
  :config
  (add-hook 'before-save-hook 'py-isort-before-save))

(after! poetry
  :defer t
  :config
  (setq poetry-tracking-strategy 'projectile)
  (remove-hook! 'python-mode-hook #'poetry-tracking-mode))

(after! (:or org elfeed-org)
  :defer t
  :init
  (setq rmh-elfeed-org-files (list "~/workspace/org/urls.org")))

(after! (:or org-ref org)
  :config
  (setq org-ref-default-bibliography `,(list (concat org-directory "/bibliography.bib")))
  (setq bibtex-completion-library-path (concat org-directory "/pdfs/"))
  (setq bibtex-completion-notes-path (concat org-directory "/bibnotes.org"))
  (setq bibtex-completion-bibliography org-ref-default-bibliography)

  (require 'org-ref-ivy)
  (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
        org-ref-insert-cite-function 'org-ref-cite-insert-ivy
        org-ref-insert-label-function 'org-ref-insert-label-link
        org-ref-insert-ref-function 'org-ref-insert-ref-link
        org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body))))


(after! (:org bibtex-completion org-ref org)
  :config
  (setq bibtex-completion-format-citation-functions
        '((org-mode      . bibtex-completion-format-citation-org-link-to-PDF)
          (latex-mode    . bibtex-completion-format-citation-cite)
          (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
          (default       . bibtex-completion-format-citation-default))))

(use-package! citeproc-org
  :after org
  :config
  (map! :map org-mode-map
        :localleader
        (:prefix ("-" . "bibliography")
                 "i" #'org-ref-insert-link
                 "r" #'org-ref-insert-ref-link
                 "l" #'org-ref-insert-bibliography-link
                 "c" #'org-ref-insert-cite-with-completion))

  (citeproc-org-setup))

(after! plantuml
  :config
  (setq plantuml-default-exec-mode 'executable)
  (cond ((string-equal system-type "gnu/linux")
         (setq plantum-executable-path "/usr/bin/plantuml"))
        ((string-equal system-type "darwin")
         (setq plantuml-executable-path "/usr/local/bin/plantuml"))))

(defadvice! +editorconfig--inhibit-in-org-exports-a (orig-fn &rest args)
  :around '(org-export-to-file org-babel-tangle)
  (let ((editorconfig-exclude-regexps '(".")))
    (apply orig-fn args)))

(after! (:or org org-msg)
  :config
  (setq org-msg-default-alternatives '(text)))

(after! (:or org-id org roam2 org-roam)
  :defer t
  :config
  (setq org-id-locations-file (concat org-directory "/.orgid"))

  (defun benmezger/org-update-org-ids ()
    "Update all org ids."
    (interactive)
    (org-id-update-id-locations
     (directory-files-recursively
      org-roam-directory ".org$\\|.org.gpg$"))))

(set-formatter! 'html-tidy
  "tidy -config ~/.config/tidyrc"
  :modes '(html-mode web-mode))

(use-package! org-mime
  :after (:any mu4e org roam2 notmuch)
  :config
  (defun benmezger/message-mode-hook()
    (when (featurep! :email (:or mu4e neomutt))
      (message "Enabling enabling local org-mime hooks...")
      (local-set-key (kbd "C-c M-o") 'org-mime-htmlize)))

  (if (featurep! :email mu4e)
      (add-hook 'mu4e-compose-mode-hook 'benmezger/message-mode-hook)
    (add-hook 'notmuch-message-mode-hook 'benmezger/message-mode-hook))

  (add-hook 'org-mode-hook
            (lambda ()
              (local-set-key (kbd"C-c M-o") 'org-mime-org-buffer-htmlize)))

  (add-hook 'message-send-hook 'org-mime-confirm-when-no-multipart)
  (add-hook 'org-mime-html-hook
            (lambda ()
              (org-mime-change-element-style
               "pre" (format "color: %s; background-color: %s; padding: 0.5em;"
                             "#E6E1DC" "#232323"))))

  (setq org-mime-export-options '(:section-numbers nil
                                  :with-author nil
                                  :with-toc nil)))

(defun doom-dashboard-widget-footer ()
  (insert
   "\n"
   (+doom-dashboard--center
    (- +doom-dashboard--width 2)
    (with-temp-buffer
      (insert-text-button
       (or (all-the-icons-octicon
            "octoface"
            :face 'doom-dashboard-footer-icon
            :height 1.3
            :v-adjust -0.15)
           (propertize
            "github"
            'face 'doom-dashboard-footer))
       'action (lambda (_) (browse-url "https://github.com/benmezger"))
       'follow-link t
       'help-echo "Personal github")
      (buffer-string)))
   "\n"))

(use-package! mu4e-thread-folding
  :requires mu4e
  :after mu4e
  :config
  (setq mu4e-thread-folding-root-folded-prefix-string (propertize "▶ " 'face 'shadow)
        mu4e-thread-folding-root-unfolded-prefix-string (propertize "▼ " 'face 'shadow))
  (custom-set-faces!
    '(mu4e-thread-folding-root-unfolded-face :weight bold :slant italic :inherit hl-line :extend t)
    '(mu4e-thread-folding-child-face :inherit hl-line :extend t))
  (map! :map mu4e-headers-mode-map
        :ne "<tab>" #'mu4e-headers-toggle-at-point
        :ne "<left>" #'mu4e-headers-fold-at-point
        :ne "<S-left>" #'mu4e-headers-fold-all
        :ne "<right>" #'mu4e-headers-unfold-at-point
        :ne "<S-right>" #'mu4e-headers-unfold-all)

  (when (featurep! :editor evil)
    (defadvice! +mu4e-thread-folding-move-to-column-1-a (&rest _)
      "Move the point to column 1.
When using evil, having the cursor at column 0 causes issues,
so we make sure that it's put a column 1 so everything works nicely."
      :before #'mu4e-headers-toggle-at-point
      :before #'mu4e-headers-fold-at-point
      :before #'mu4e-headers-unfold-at-point
      :before #'mu4e-headers-view-message
      :before #'mu4e-compose-reply
      :before #'mu4e-compose-forward
      (unless (= (current-column) 1)
        (move-to-column 1 t))))

  (mu4e-thread-folding-load))

(load "~/.doom.d/chezmoi")
(load "~/.doom.d/elisp/chezmoi.el")

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after (:or org org-roam)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(defun benmezger/dotfile-script-run()
  "Edit a chezmoi file."
  (interactive)
  (ivy-read "script: "
            (directory-files "~/dotfiles/scripts")
            :require-match t
            :action
            (lambda (n)
              (async-shell-command
               (format "bash ~/dotfiles/scripts/%s" n)
               "*dotfiles*" "*dotfiles-stderr"))))

(use-package! protobuf-mode
  :defer t
  :mode ("[./]proto\\'" . protobuf-mode))

(use-package! just-mode
  :defer t
  :mode ("[./]just\\'" . just-mode))

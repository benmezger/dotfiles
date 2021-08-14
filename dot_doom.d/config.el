;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Hack" :size 14)
      doom-theme 'doom-monokai-spectrum
      display-line-numbers-type t
      default-directory "~/"
      command-line-default-directory "~/")

(display-time-mode 1)
(display-battery-mode 1)
(toggle-frame-maximized)
(setq auth-sources '("~/.authinfo" "~/.authinfo.gpg" "~/.netrc"))

(after! lsp-mode
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

  (set-face-attribute 'mode-line nil :family "Hack" :height 125)
  (set-face-attribute 'mode-line-inactive nil :family "Hack" :height 125)

  (setq doom-modeline-buffer-file-name-style 'truncate-upto-project)

  (setq doom-modeline-icon (display-graphic-p))
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)

  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-buffer-modification-icon t)

  (setq doom-modeline-enable-word-count t)
  (setq doom-modeline-buffer-encoding t)
  (setq doom-modeline-indent-info t)

  (setq doom-modeline-mu4e nil)
  (setq doom-modeline-irc nil)

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
  (setq org-log-done 'time)
  (setq org-clock-persist 'history)
  (setq org-directory "~/workspace/org")
  (setq org-archive-location "archives/%s_archive::")
  (setq org-agenda-files (list org-directory))
  (org-clock-persistence-insinuate)
  (setq-default org-catch-invisible-edits 'smart)
  (setq org-log-into-drawer t)
  (setq org-agenda-inhibit-startup t)
  (add-hook! 'org-mode-hook #'turn-on-auto-fill)
  (setq bibtex-completion-bibliography (concat org-directory "/bibliography.bib"))

  (setq org-todo-keywords
        '((sequence "TODO(t!)" "CURRENT(u!)" "WAIT(w@/!)" "NEXT(n!)" "PROJ(o!)" "|")
          (sequence "READ(!)")
          (sequence "|" "DONE(d!)" "CANCELED(c!)"))
        org-todo-keyword-faces
        '(("CURRENT"  . "orange")
          ("TODO" . "systemRedColor")
          ("READ" . "systemOrangeColor")
          ("HOLD"  . "indianRed")
          ("WAIT" . "salmon1")
          ("PROJ" . "systemYellowColor")))

  (setq org-capture-template-dir (concat doom-private-dir "org-captures/"))
  (setq org-capture-templates
        `(
          ("c" "Code" entry (file "~/workspace/org/code.org")
           (file ,(concat org-capture-template-dir "code-snippet.capture")))
          ("i" "Inbox" entry (file "~/workspace/org/inbox.org")
           (file ,(concat org-capture-template-dir "inbox-snippet.capture")))
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
           (file ,(concat org-capture-template-dir "weekly-journal.capture")) :tree-type week)))


  (setq ob-async-no-async-languages-alist '("gnuplot" "mermaid")))

(after! org-roam
  :defer t
  (setq org-roam-directory "~/workspace/org/roam")
  (setq org-roam-index-file (concat org-roam-directory "/" "index.org"))

  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :if-new (file+head "%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                              "#+TITLE: ${title}
#+DATE: %T
#+FILETAGS: %^G
#+SETUPFILE: %(concat (file-name-as-directory org-directory) \"hugo.setup\")
#+HUGO_SLUG: ${slug}
#+HUGO_TAGS: %^{Hugo tags}

- tags :: ")
           :unnarrowed t)
          ("p" "private" plain "%?"
           :if-new (file+head "private/%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                              "#+TITLE: ${title}
#+DATE: %T
#+FILETAGS: :personal:%^G
#+HUGO_SLUG: ${slug}
")
           :unnarrowed t)))

  (defun custom-org-protocol-focus-advice (orig &rest args)
    (x-focus-frame nil)
    (apply orig args))

  (advice-add 'org-roam-protocol-open-ref :around
              #'custom-org-protocol-focus-advice)
  (advice-add 'org-roam-protocol-open-file :around
              #'custom-org-protocol-focus-advice))

(after! (org org-roam)
  :defer t
  (push org-roam-directory org-agenda-files)
  (defun benmezger/org-roam-export-all ()
    "Re-exports all Org-roam files to Hugo markdown."
    (interactive)
    (dolist (f (org-roam--list-all-files))
      (with-current-buffer (find-file f)
        (when (s-contains? "SETUPFILE" (buffer-string))
          (org-hugo-export-wim-to-md)))))

  (remove-hook! 'find-file-hook #'+org-roam-open-buffer-maybe-h))

(use-package! org-roam-server
  :defer t)

(after! org-journal
  :defer t
  :config
  (setq org-journal-dir "~/workspace/org/journal")
  (push org-journal-dir org-agenda-files)
  (setq org-journal-file-format "%Y%m%d.org"))

(after! deft
  :defer t
  :config
  (setq deft-directory "~/workspace/org")
  (setq deft-extensions '("org" "md" "txt"))
  (setq deft-default-extension "org")
  (setq deft-recursive t)
  (setq deft-use-filename-as-title nil)
  (setq deft-use-filter-string-for-filename t)
  (setq deft-file-naming-rules '((nospace . "-"))))

(after! doom-modeline
  :config
  (setq doom-modeline-continuous-word-count-modes
        '(markdown-mode gfm-mod)))

(use-package! py-isort
  :defer t
  :init
  (add-hook 'before-save-hook 'py-isort-before-save))

(after! elfeed-org
  :defer t
  :init
  (setq rmh-elfeed-org-files (list "~/workspace/org/urls.org")))

(after! ob-mermaid
  :defer t
  :init
  (setq ob-mermaid-cli-path "/usr/local/bin/mmdc"))

(after! org-ref
  :config
  (setq org-ref-completion-library 'org-ref-ivy-cite)
  (setq org-ref-default-bibliography `,(list (concat org-directory "/bibliography.bib")))
  (setq org-ref-pdf-directory (concat org-directory "/pdfs/"))
  (setq org-ref-bibliography-notes (concat org-directory "/bibnotes.org"))
  (setq reftex-default-bibliography org-ref-default-bibliography))


(after! bibtex-completion
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

(after! org-msg
  :config
  (setq org-msg-default-alternatives '(text)))

(after! org-id
  :defer t
  :config
  (setq org-id-locations-file (concat org-directory "/.orgid"))

  (defun benmezger/org-update-org-ids ()
    "Update all org ids."
    (interactive)
    (org-id-update-id-locations
     (directory-files-recursively
      org-roam-directory ".org$\\|.org.gpg$")))
  )

(set-formatter! 'html-tidy
  "tidy -config ~/.config/tidyrc"
  :modes '(html-mode web-mode))

(load "~/.doom.d/chezmoi")

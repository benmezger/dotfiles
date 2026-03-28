(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(require 'package)
(setopt package-archives
        '(("melpa" . "http://melpa.org/packages/")
          ("org" . "http://orgmode.org/elpa/")
          ("gnu" . "https://elpa.gnu.org/packages/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package straight
  :custom (straight-use-package-by-default t))

(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package general
  :ensure t
  :config
  (general-evil-setup t)

  (general-create-definer my/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC"))

(use-package marginalia
  :after vertico
  :ensure t
  :init (marginalia-mode))

(use-package savehist
  :ensure t
  :init (savehist-mode))

(use-package goto-chg
  :ensure t)

(use-package evil
  :ensure t
  :requires goto-chg
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode))

(use-package evil-collection
  :ensure t
  :after evil
  :config (evil-collection-init))

(use-package gruvbox-theme
  :ensure t
  :init (load-theme 'gruvbox-dark-hard t))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package counsel
  :diminish (ivy-mode . "")
  :init (ivy-mode 1)
  :requires general
  :ensure t
  :bind*
  (("M-x"     . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   ("C-x C-r" . counsel-recentf)
   ("C-c g"   . counsel-git)
   ("C-x l"   . counsel-locate))
  :general
  (my/leader-keys
   "SPC" '(counsel-find-file :which-key "find file")
   "f"   '(:ignore t :which-key "files")
   "f r" '(counsel-recentf :which-key "find recent files")
   "f g" '(counsel-git :which-key "find git file")
   "f k" '(counsel-locate :which-key "locate file"))
  :config
  (setq ivy-use-virtual-buffers t
	ivy-height 20
	ivy-count-format "%d/%d "
	enable-recursive-minibuffers t
	search-default-mode #'char-fold-to-regexp
	ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (counsel-rg . ivy--regex-plus)
          (t      . ivy--regex-fuzzy)))

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


(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :ensure t
  :config
  (which-key-setup-minibuffer)
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-side-window-max-width 0.333
        which-key-idle-delay 1.0))

(use-package magit
  :ensure t
  :requires general
  :general
  (my/leader-keys
   "g"   '(:ignore t :which-key "git")
   "g g" '(magit-status :which-key "magit buffer"))
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1
        magit-save-repository-buffers 'dontask))

(use-package pyenv-mode
  :ensure t
  :config
  (when (executable-find "pyenv")
    (pyenv-mode +1)
    (add-to-list 'exec-path (expand-file-name "shims" (or (getenv "PYENV_ROOT") "~/.pyenv")))))

(use-package pyvenv :ensure t)

(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode +1)
  ;; make ruff the priority
  (add-to-list 'apheleia-mode-alist '(python-mode . ruff)))

(use-package company
  :ensure t
  :requires general
  :init (global-company-mode)
  :general
  (company-active-map
   "TAB"     'company-complete-selection
   "<tab>"   'company-complete-selection)
  :config
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1))

(use-package lsp-mode
  :ensure t
  :after company
  :requires (which-key company general)
  :hook ((python-mode . lsp-deferred)
         (lsp-mode    . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred)
  :general
  (my/leader-keys
   "c"   '(:ignore t :which-key "code")
   "c f" '(lsp-format-buffer :which-key "format")
   "c r" '(lsp-rename :which-key "rename")
   "c a" '(lsp-execute-code-action :which-key "code action")
   "c d" '(lsp-find-definition :which-key "find definition")
   "c i" '(lsp-find-implementation :which-key "find implementation")
   "c t" '(lsp-find-type-definition :which-key "find type definition")
   "c h" '(lsp-describe-thing-at-point :which-key "hover doc")
   "c e" '(flymake-show-buffer-diagnostics :which-key "errors list"))
  :config
  (setq lsp-completion-provider :capf))

(use-package lsp-ivy
  :ensure t
  :requires (lsp-mode counsel)
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-ui
  :ensure t
  :requires lsp-mode
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-pyright
  :ensure t
  :after lsp-mode)

(use-package org
  :ensure t
  :hook (org-mode . auto-fill-mode)
  :requires general
  :general
  (my/leader-keys
   "o"   '(:ignore t :which-key "org")
   "o a" '(org-agenda :which-key "agenda")
   "o c" '(org-capture :which-key "capture")
   "o l" '(org-store-link :which-key "store link")
   "o i" '(benmezger/org-insert-link-dwim :which-key "insert link")
   "o f" '((lambda () (interactive) (require 'org) (counsel-find-file org-directory)) :which-key "find file")
   "o t" '(org-todo-list :which-key "todo list")
   "o j" '(org-journal-new-entry :which-key "new journal entry")
   "o v" '((lambda () (interactive) (require 'org) (find-file (expand-file-name "cv/cv.org" org-directory))) :which-key "cv"))
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
                            ("TODO"     . "systemRedColor")
                            ("READ"     . "systemOrangeColor")
                            ("HOLD"     . "indianRed")
                            ("WAIT"     . "salmon1")
                            ("PROJ"     . "systemYellowColor"))
   ob-async-no-async-languages-alist '("gnuplot" "mermaid"))
  (setq-default org-catch-invisible-edits 'smart)

  (let ((capture-dir (concat user-emacs-directory "org-captures/")))
    (setq org-capture-templates
          `(("c" "Code" entry (file "~/workspace/org/code.org")
             (file ,(concat capture-dir "code-snippet.capture")))
            ("i" "Inbox" entry (file+datetree "~/workspace/org/inbox.org")
             (file ,(concat capture-dir "inbox-snippet.capture")))
            ("j" "Journal" entry (file+datetree "~/workspace/org/journal.org")
             (file ,(concat capture-dir "journal.capture")))
            ("b" "Blog post" entry (file+olp "~/workspace/org/blog.org" "Posts")
             (file ,(concat capture-dir "blog-post.capture")))
            ("n" "Note" entry (file+olp "~/workspace/org/notes.org" "Inbox")
             "* %?\nEntered on %U\n  %i\n  %a")
            ("t" "Todo" entry (file "~/workspace/org/todos.org")
             "* TODO %?\n %i\n  %a")
            ("r" "Register new book" entry (file+olp "~/workspace/org/notes.org" "Books")
             (file ,(concat capture-dir "new-book.capture")))
            ("d" "Decision note" entry (file "~/workspace/org/decisions.org")
             (file ,(concat capture-dir "decision.capture")))
            ("w" "Weekly journal" entry (file+olp+datetree "~/workspace/org/journal/weekly.org" "Weekly notes")
             (file ,(concat capture-dir "weekly-journal.capture")) :tree-type week)
            ("e" "RRR" entry (file "~/workspace/org/rrr.org")
             (file ,(concat capture-dir "rrr.capture"))))))

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

(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))

(use-package org-roam
  :ensure t
  :demand t
  :general
  (my/leader-keys
   "o r"   '(:ignore t :which-key "roam")
   "o r f" '(org-roam-node-find :which-key "find node")
   "o r i" '(org-roam-node-insert :which-key "insert node")
   "o r b" '(org-roam-buffer-toggle :which-key "backlinks")
   "o r c" '(org-roam-capture :which-key "capture")
   "o r d" '(org-roam-dailies-goto-today :which-key "today's daily")
   "o r D" '(org-roam-dailies-find-date :which-key "find daily"))
  :config
  (setq org-roam-directory "~/workspace/org/roam"
        org-roam-index-file (concat org-roam-directory "/" "index.org"))
  (defvar benmezger/org-roam-private-directory
    (concat org-roam-directory "/private"))

  (push org-roam-directory org-agenda-files)
  (push benmezger/org-roam-private-directory org-agenda-files)

  (setq org-roam-capture-templates
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
           :if-new (file+head "roam/private/%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                              "#+TITLE: ${title}
#+DATE: %T
#+FILETAGS: :personal:%^G
#+HUGO_SLUG: ${slug}
#+EXPORT_FILE_NAME: exports/%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}\" (current-time) t)
")
           :unnarrowed t)
          ("e" "encrypted private" plain "%?"
           :if-new (file+head "private/%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org.gpg\" (current-time) t)"
                              "#+TITLE: ${title}
#+DATE: %T
#+FILETAGS: :personal:gpg:%^G
#+HUGO_SLUG: ${slug}
#+EXPORT_FILE_NAME: exports/%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}\" (current-time) t)
")
           :unnarrowed t)))

  (setq org-roam-dailies-directory "../journal/"
        org-roam-dailies-capture-templates
        '(("d" "default" entry
           "* %?"
           :target (file+head "%<%Y-%m-%d>.org"
                              "#+TITLE: %<%Y-%m-%d>\n"))))

  (defun benmezger/org-roam-node-insert-immediate (arg &rest args)
    (interactive "P")
    (let ((args (cons arg args))
          (org-roam-capture-templates
           (list (append (car org-roam-capture-templates)
                         '(:immediate-finish t)))))
      (apply #'org-roam-node-insert args)))

  (defun custom-org-protocol-focus-advice (orig &rest args)
    (x-focus-frame nil)
    (apply orig args))
  (advice-add 'org-roam-protocol-open-ref :around #'custom-org-protocol-focus-advice)
  (advice-add 'org-roam-protocol-open-file :around #'custom-org-protocol-focus-advice)

  (setq org-id-locations-file (concat org-directory "/.orgid"))
  (defun benmezger/org-update-org-ids ()
    "Update all org ids."
    (interactive)
    (org-id-update-id-locations
     (directory-files-recursively
      org-roam-directory ".org$\\|.org.gpg$")))

  (org-roam-db-autosync-mode))

(use-package org-roam-ui
  :ensure t
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package org-contrib
  :ensure t
  :after org
  :config (require 'ox-extra))

(use-package ox-hugo
  :ensure t
  :after org
  :config
  (setq org-hugo-external-file-extensions-allowed-for-copying
        '("jpg" "jpeg" "tiff" "png" "svg" "gif"
          "mp4" "pdf" "odt" "doc" "ppt" "xls"
          "docx" "pptx" "xlsx" "zip"))

  (defun benmezger/org-roam-export-all ()
    "Re-exports all Org-roam files to Hugo markdown."
    (interactive)
    (dolist (f (org-roam--list-all-files))
      (with-current-buffer (find-file f)
        (when (s-contains? "SETUPFILE" (buffer-string))
          (org-hugo-export-wim-to-md))))))

(use-package org-journal
  :ensure t
  :after org
  :config
  (setq org-journal-dir "~/workspace/org/journal"
        org-journal-encrypt-journal t
        org-journal-file-format "%Y%m%d.org"))

(use-package emacs
  :ensure nil
  :requires general
  :bind
  ("C-w" . backward-kill-word)
  :general
  (my/leader-keys
   "b"   '(:ignore t :which-key "buffers")
   "b b" '(switch-to-buffer :which-key "switch buffer")
   "b k" '(kill-buffer :which-key "kill buffer")
   "b s" '(save-buffer :which-key "save buffer")
   "b l" '(list-buffers :which-key "list buffers")
   "w"   '(:ignore t :which-key "windows")
   "w s" '(split-window-below :which-key "split horizontal")
   "w v" '(split-window-right :which-key "split vertical")
   "w k" '(delete-window :which-key "close window")
   "p"   '(:ignore t :which-key "project")
   "p p" '(project-find-file :which-key "find files")
   "p g" '(project-find-regexp :which-key "grep files")
   "p k" '(project-kill-buffers :which-key "kill buffers"))
  :config
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (toggle-frame-maximized)

  (global-display-line-numbers-mode)
  (global-auto-revert-mode t)

  (require 'uniquify)

  (setq epa-armor t
        display-line-numbers-type t
        gc-cons-threshold 100000000 ; 100 mb
        read-process-output-max (* 1024 1024) ; 1mb
        ;; Place backups in a separate folder.
        backup-directory-alist `(("." . "~/.saves"))
        auto-save-file-name-transforms `((".*" "~/.saves/" t))
        ;; I store automatic customization options in a gitignored file,
        ;; but this is definitely a personal preference.
        custom-file (locate-user-emacs-file "custom.el")
        ;; Ensure unique names when matching files exist in the buffer.
        ;; It will add a "myproj/main.rs" prefix when it detects matching
        ;; names.
        uniquify-buffer-name-style 'forward)

  (when (file-exists-p custom-file)
    (load custom-file)))

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

(load (expand-file-name "chezmoi.el" user-emacs-directory) t)


(use-package straight
  :custom
  (straight-use-package-by-default t)
  (straight-recipe-repositories '(org-elpa melpa gnu-elpa-mirror nongnu-elpa el-get emacsmirror-mirror)))

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package general
  :ensure t
  :config
  (general-evil-setup t)
  (general-override-mode 1)

  (general-create-definer my/leader-keys
    :states '(normal insert visual emacs motion)
    :keymaps 'override
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

(use-package undo-fu)

(use-package undo-fu-session
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  (undo-fu-session-global-mode))

(use-package evil
  :ensure t
  :requires goto-chg
  :init
  (setq evil-want-keybinding nil
	evil-undo-system 'undo-fu
        evil-insert-state-cursor 'bar)
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
  :init
  ;; Disable icons to prevent a crash on macOS ARM64 (GNU Emacs bug#68940).
  ;; During init, nsterm.m's `layoutSublayersOfLayer:' fires `redisplay()'
  ;; before the face cache is fully initialised.  doom-modeline's battery
  ;; status update then calls `char-displayable-p', which reaches
  ;; `font_find_for_lface' and dereferences the corrupted cache → SIGABRT.
  ;; Keeping icons off prevents any `char-displayable-p' calls at startup.
  (setq doom-modeline-icon nil)
  (doom-modeline-mode 1))

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
	ivy-height 10
	ivy-fixed-height-minibuffer t
	ivy-count-format "%d/%d "
	enable-recursive-minibuffers t
	search-default-mode #'char-fold-to-regexp
	ivy-wrap t
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
  :defer t
  :requires general
  :general
  (my/leader-keys
    "g"   '(:ignore t :which-key "git")
    "g g" '(magit-status :which-key "magit buffer"))
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1
        magit-save-repository-buffers nil))

(use-package pyenv-mode
  :ensure t
  :defer t
  :hook (python-mode . pyenv-mode)
  :config
  (when (executable-find "pyenv")
    (add-to-list 'exec-path (expand-file-name "shims" (or (getenv "PYENV_ROOT") "~/.pyenv")))))

(use-package pyvenv :ensure t :defer t)

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
  :hook
  (git-commit-mode . (lambda () (company-mode -1)))
  :config
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1))

(use-package treesit-auto
  :ensure t
  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode))

(use-package lsp-mode
  :ensure t
  :after company
  :requires (which-key company general)
  :hook ((python-mode    . lsp-deferred)
         (python-ts-mode . lsp-deferred)
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
  (setq lsp-completion-provider :capf
        lsp-idle-delay 0.5
        lsp-log-io nil
        lsp-ruff-ruff-args '("--preview")))

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
  :init
  ;; Set before org loads so keybindings referencing this variable never see it void.
  (setq org-directory "~/workspace/org")
  :hook (org-mode . auto-fill-mode)
  :requires general
  :general
  (my/leader-keys
    "o"   '(:ignore t :which-key "org")
    "o a" '(org-agenda :which-key "agenda")
    "o c" '(org-capture :which-key "capture")
    "o l" '(org-store-link :which-key "store link")
    "o i" '(benmezger/org-insert-link-dwim :which-key "insert link")
    "o f" '((lambda () (interactive) (counsel-find-file org-directory)) :which-key "find file")
    "o t" '(org-todo-list :which-key "todo list")
    "o j" '(org-journal-new-entry :which-key "new journal entry")
    "o v" '((lambda () (interactive) (find-file (expand-file-name "cv/cv.org" org-directory))) :which-key "cv"))
  :config
  (setq
   org-log-done 'time
   org-clock-persist 'history
   org-directory "~/workspace/org"
   org-archive-location ".archives/%s_archive::"
   org-agenda-files (list org-directory)
   org-log-into-drawer t
   org-startup-indented t
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

(use-package org-roam
  :ensure t
  :defer t
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
#+FILETAGS: %^{Filetags}
#+SETUPFILE: ../hugo.setup
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
#+FILETAGS: :personal:%^{Filetags}
#+HUGO_SLUG: ${slug}
#+EXPORT_FILE_NAME: exports/%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}\" (current-time) t)
")
           :unnarrowed t)
          ("e" "encrypted private" plain "%?"
           :if-new (file+head "private/%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org.gpg\" (current-time) t)"
                              "#+TITLE: ${title}
#+DATE: %T
#+FILETAGS: :personal:gpg:%^{Filetags}
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
      org-roam-directory ".org$\\|.org.gpg$"))))

(use-package org-roam-ui
  :ensure t
  :requires org
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil))

(use-package org-contrib
  :straight t
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

(use-package direnv
  :defer t
  :hook (after-init . direnv-mode))

(use-package restart-emacs
  :ensure t
  :requires general
  :general
  (my/leader-keys
    "e R" '(restart-emacs :which-key "restart emacs")))

(use-package code-stats
  :defer t
  :ensure t
  :hook (kill-emacs . (lambda () (code-stats-sync :wait)))
  :config
  (setq code-stats-token (auth-source-pick-first-password :host "codestats.net"))
  (define-globalized-minor-mode my-global-code-stats-mode code-stats-mode
    (lambda () (code-stats-mode 1)))
  (my-global-code-stats-mode)
  (run-with-idle-timer 30 t #'code-stats-sync))

(use-package emacs
  :ensure nil
  :requires general
  :bind (("C-w" . backward-kill-word)
	 ("C-c C-x k" . (lambda () (interactive) (kill-buffer (current-buffer))))
	 ("<escape>" . keyboard-quit))
  :hook
  (emacs-startup . (lambda ()
                     (message
		      "Emacs loaded in %s with %d garbage collections."
                      (format "%.2f seconds"
                              (float-time (time-subtract after-init-time before-init-time)))
                      gcs-done)))
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
    "p p" '(project-switch-project :which-key "switch project")
    "p f" '(project-find-file :which-key "find file")
    "p g" '(project-find-regexp :which-key "grep files")
    "p k" '(project-kill-buffers :which-key "kill buffers")
    "p s" '(my/counsel-rg-project :which-key "search project")
    "s"   '(:ignore t :which-key "search")
    "s p" '(counsel-rg :which-key "rg project")
    "s d" '((lambda () (interactive) (counsel-rg nil default-directory)) :which-key "rg directory")
    "t"   '(:ignore t :which-key "toggle")
    "t b" '(my/big-font-mode :which-key "big font")
    "q"   '(:ignore t :which-key "quit")
    "e r" '(my/reload-init :which-key "reload config")
    "h"   '(:ignore t :which-key "help")
    "h k" '(describe-key :which-key "describe key")
    "h v" '(describe-variable :which-key "describe variable")
    "h m" '(describe-mode :which-key "describe mode")
    "h M" '(describe-minor-mode :which-key "describe minor mode")
    "h i" '(info :which-key "info"))
  :config
  (fset 'yes-or-no-p 'y-or-n-p)
  (global-display-line-numbers-mode)
  (global-auto-revert-mode t)
  (toggle-frame-maximized)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (display-time-mode 1)
  (display-battery-mode 1)
  (hl-line-mode 1)

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
	uniquify-buffer-name-style 'forward
	ring-bell-function 'ignore
	inhibit-compacting-font-caches t
	inhibit-startup-screen t
	cursor-type 'bar
	auth-sources '("~/.authinfo" "~/.authinfo.gpg" "~/.netrc")
	enable-recursive-minibuffers t
	undo-limit 67108864 ; 64mb
	undo-strong-limit 100663296 ; 96mb.
	undo-outer-limit 1006632960) ; 960mb

  (when (file-exists-p custom-file)
    (load custom-file))

  (defvar my/big-font-mode nil "Non-nil when big font mode is active.")
  (defvar my/normal-font-height 140 "Default font height.")
  (defvar my/big-font-height 200 "Font height for big font mode.")

  (defun my/big-font-mode ()
    "Toggle between normal and big font size."
    (interactive)
    (setq my/big-font-mode (not my/big-font-mode))
    (set-face-attribute 'default nil
                        :height (if my/big-font-mode
                                    my/big-font-height
                                  my/normal-font-height))
    (message "Big font mode %s" (if my/big-font-mode "enabled" "disabled")))

  (defvar my/hack-local-variables-running nil)
  (advice-add 'hack-local-variables :around
              (lambda (orig &rest args)
		(unless my/hack-local-variables-running
                  (let ((my/hack-local-variables-running t))
                    (apply orig args)))))

  (defun benmezger/python-fmt ()
    (interactive)
    (let ((default-directory (or (when-let ((proj (project-current)))
                                   (project-root proj))
                                 default-directory)))
      (async-shell-command "uv run task fmt" "*python-fmt*" "*python-fmt-stderr*")))

  (defun benmezger/python-test ()
    (interactive)
    (let ((default-directory (or (when-let ((proj (project-current)))
                                   (project-root proj))
                                 default-directory)))
      (async-shell-command "uv run task test" "*python-test*" "*python-test-stderr*")))

  (defun benmezger/python-types ()
    (interactive)
    (let ((default-directory (or (when-let ((proj (project-current)))
                                   (project-root proj))
                                 default-directory)))
      (async-shell-command "uv run task check_types" "*python-types*" "*python-test-stderr*")))

  (defun benmezger/python-activate-venv ()
    (interactive)
    (let* ((root (or (when-let ((proj (project-current)))
                       (project-root proj))
                     default-directory))
           (venv (expand-file-name ".venv" root)))
      (pyvenv-activate venv)))

  (defvar benmezger/python-last-project nil
    "Project root for which a venv was last activated.")

  (defun benmezger/python-maybe-activate-venv (&optional _frame)
    "Activate .venv when the current buffer belongs to a new Python project."
    (when-let* ((proj (project-current))
                (root (project-root proj))
                (venv (expand-file-name ".venv" root)))
      (when (and (not (equal root benmezger/python-last-project))
                 (file-exists-p (expand-file-name "pyproject.toml" root))
                 (file-directory-p venv))
        (setq benmezger/python-last-project root)
        (pyvenv-activate venv))))

  (add-hook 'window-buffer-change-functions #'benmezger/python-maybe-activate-venv)

  (defun my/reload-init ()
    "Reload init.el in the current Emacs session."
    (interactive)
    (load-file user-init-file)
    (message "init.el reloaded"))

  (defun my/counsel-rg-project ()
    "Run counsel-rg from the current project root."
    (interactive)
    (counsel-rg nil (project-root (project-current t))))
  )

;; -*- lexical-binding: t -*-

(use-package straight
  :custom
  (straight-use-package-by-default t)
  (straight-recipe-repositories '(org-elpa melpa gnu-elpa-mirror nongnu-elpa el-get emacsmirror-mirror)))

(use-package vertico
  :straight t
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode)
  (setq enable-recursive-minibuffers t))

(use-package general
  :straight t
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
  :straight t
  :init (marginalia-mode))

(use-package savehist
  :straight t
  :init (savehist-mode)
  :hook (savehist-save . my/savehist-sanitize-kill-ring)
  :config
  ;; kill ring can accumulate text properties (fonts, overlays, etc.)
  ;; that bloat the savehist file, so strip them before saving
  (defun my/savehist-sanitize-kill-ring ()
    "Strip text properties from kill-ring entries before saving."
    (setq kill-ring
          (mapcar #'substring-no-properties
                  (cl-remove-if-not #'stringp kill-ring)))))

(use-package goto-chg
  :straight t)

(use-package undo-fu)

(use-package undo-fu-session
  :requires undo-fu
  :custom
  (undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  :config
  (undo-fu-session-global-mode))

(use-package evil
  :straight t
  :requires (goto-chg undo-fu)
  :init
  (setq evil-want-keybinding nil
	evil-undo-system 'undo-fu
        evil-insert-state-cursor 'bar)
  :config
  (evil-mode))

(use-package evil-collection
  :requires (evil)
  :straight t
  :after evil
  :config (evil-collection-init))

(use-package gruvbox-theme
  :straight t
  :init
  ;; gruvbox defines gnus-group-news-low and gnus-group-news-low-empty with
  ;; mutually circular inheritance.  When Circe is running it pre-loads those
  ;; faces, so reloading the theme triggers "Face inheritance results in
  ;; inheritance cycle".  Reset them first to break the cycle.
  (mapc (lambda (f) (when (facep f) (face-spec-reset-face f)))
        '(gnus-group-news-low gnus-group-news-low-empty))
  (load-theme 'gruvbox-dark-hard t)
  :config
  (custom-set-faces
   '(vertico-current ((t (:background "#3c3836" :foreground "#ebdbb2" :extend t))))))

(use-package doom-modeline
  :straight t
  :init
  ;; Disable icons to prevent a crash on macOS ARM64 (GNU Emacs bug#68940).
  ;; During init, nsterm.m's `layoutSublayersOfLayer:' fires `redisplay()'
  ;; before the face cache is fully initialised.  doom-modeline's battery
  ;; status update then calls `char-displayable-p', which reaches
  ;; `font_find_for_lface' and dereferences the corrupted cache → SIGABRT.
  ;; Keeping icons off prevents any `char-displayable-p' calls at startup.
  (when (eq system-type 'darwin)
    (setq doom-modeline-icon nil))

  (setq doom-modeline-irc-stylize #'identity
        doom-modeline-irc t)
  (doom-modeline-mode 1))

(use-package consult
  :straight t
  :demand t
  :requires general
  :bind*
  (("C-x C-r" . consult-recent-file)
   ("C-x l"   . consult-locate))
  :general
  (my/leader-keys
    "f r" '(consult-recent-file :which-key "find recent files")
    "f f" '(consult-fd :which-key "find file")
    "f l" '(consult-locate :which-key "locate file")
    "s p" '(consult-ripgrep :which-key "rg project")
    "s b" '(consult-line :which-key "find in buffer")
    "s d" '(my/consult-rg-directory :which-key "rg directory")
    "s i" '(consult-imenu :which-key "imenu")
    "p g" '(consult-ripgrep :which-key "grep files")
    "p s" '(my/consult-rg-project :which-key "search project")
    "g g" '(consult-git-grep :which-key "git grep")
    "p b" '(consult-project-buffer :which-key "project buffers"))
  :custom
  (consult-async-min-input 0)
  :config
  (defun my/consult-rg-directory ()
    "Run consult-ripgrep from the current directory."
    (interactive)
    (consult-ripgrep default-directory nil))
  (consult-customize
   consult-ripgrep consult-grep consult-git-grep
   consult-buffer consult-project-buffer consult-recent-file
   consult-imenu my/consult-rg-directory
   :group nil
   :preview-key "M-.")
  (consult-customize my/consult-rg-directory :preview-key nil)
  (setq completion-in-region-function #'consult-completion-in-region))

(use-package embark
  :straight t
  :bind*
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :config
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :straight t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package wgrep
  :straight t
  :hook (grep-mode . wgrep-setup)
  :custom
  (wgrep-auto-save-buffer t))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t)
  (orderless-matching-styles '(orderless-literal orderless-flex orderless-regexp)))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :straight t
  :custom
  (which-key-sort-order 'which-key-key-order-alpha)
  (which-key-side-window-max-width 0.333)
  (which-key-idle-delay 1.0)
  :config
  (which-key-setup-minibuffer))

(use-package magit
  :straight t
  :defer t
  :requires general
  :general
  (my/leader-keys
    "g s" '(magit-status :which-key "git status"))
  :custom
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  (magit-save-repository-buffers nil)
  (magit-refresh-status-buffer nil)
  :config
  (remove-hook 'server-switch-hook 'magit-commit-diff)
  (remove-hook 'with-editor-filter-visit-hook 'magit-commit-diff))

(use-package pyenv-mode
  :straight t
  :defer t
  :hook (python-ts-mode . pyenv-mode)
  :config
  (when (executable-find "pyenv")
    (add-to-list 'exec-path (expand-file-name "shims" (or (getenv "PYENV_ROOT") "~/.pyenv")))))

(use-package pyvenv :straight t :defer t)

(use-package apheleia
  :straight t
  :config
  (apheleia-global-mode +1)
  ;; make ruff the priority
  (add-to-list 'apheleia-mode-alist '(python-ts-mode . ruff)))

(use-package company
  :straight t
  :requires general
  :init (global-company-mode)
  :general
  (company-active-map
   "TAB"     'company-complete-selection
   "<tab>"   'company-complete-selection
   "C-w"     'backward-kill-word)
  :hook
  (git-commit-mode    . (lambda () (company-mode -1)))
  (circe-channel-mode . (lambda () (company-mode -1)))
  (circe-query-mode   . (lambda () (company-mode -1)))
  :custom
  (company-idle-delay 0.0)
  (company-minimum-prefix-length 1))

(use-package treesit-auto
  :straight t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode)
  ;; Cache treesit-auto--build-major-mode-remap-alist so emacsclient openings
  ;; (e.g. git commit) don't re-run treesit-language-available-p for every grammar.
  ;; Uses :unset sentinel so a nil return value is still cached correctly.
  ;; NOTE: cache is never invalidated during the session — if you install a new
  ;; grammar mid-session, reset it with (setq my/treesit-auto-remap-cache :unset).
  (defvar my/treesit-auto-remap-cache :unset)
  (advice-add 'treesit-auto--build-major-mode-remap-alist :around
              (lambda (orig &rest args)
                (if (eq my/treesit-auto-remap-cache :unset)
                    (setq my/treesit-auto-remap-cache (apply orig args))
                  my/treesit-auto-remap-cache)))
  ;; Pre-warm the cache shortly after startup so the first emacsclient hit is fast.
  (run-with-idle-timer 2 nil #'treesit-auto--build-major-mode-remap-alist))

(use-package lsp-mode
  :straight t
  :after company
  :requires (which-key company general)
  :hook ((python-ts-mode . lsp-deferred)
         (bash-ts-mode   . lsp-deferred)
         (go-ts-mode   . lsp-deferred)
         (lsp-mode    . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred)
  :general
  (my/leader-keys
    "c f" '(lsp-format-buffer :which-key "format")
    "c r" '(lsp-rename :which-key "rename")
    "c a" '(lsp-execute-code-action :which-key "code action")
    "c d" '(lsp-find-definition :which-key "find definition")
    "c i" '(lsp-find-implementation :which-key "find implementation")
    "c t" '(lsp-find-type-definition :which-key "find type definition")
    "c h" '(lsp-describe-thing-at-point :which-key "hover doc")
    "c e" '(flymake-show-buffer-diagnostics :which-key "errors list"))
  :custom
  (lsp-completion-provider :capf)
  (lsp-idle-delay 0.5)
  (lsp-log-io nil)
  (lsp-ruff-ruff-args '("--preview")))

(use-package consult-lsp
  :straight t
  :requires (lsp-mode consult)
  :after lsp-mode
  :commands (consult-lsp-symbols consult-lsp-diagnostics consult-lsp-file-symbols))

(use-package lsp-ui
  :straight t
  :requires lsp-mode
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-pyright
  :straight t
  :requires lsp
  :hook (python-ts-mode . (lambda () (require 'lsp-pyright)))
  :after lsp-mode)

(use-package org
  :straight t
  :init
  ;; Set before org loads so keybindings referencing this variable never see it void.
  (setq org-directory (expand-file-name "~/workspace/org/"))
  :hook (org-mode . auto-fill-mode)
  :requires general
  :custom
  (org-log-done 'time)
  (org-clock-persist 'history)
  (org-archive-location ".archives/%s_archive::")
  (org-log-into-drawer t)
  (org-startup-indented t)
  (org-agenda-inhibit-startup t)
  (org-todo-keywords '((sequence "TODO(t!)" "CURRENT(u!)" "WAIT(w@/!)" "NEXT(n!)" "PROJ(o!)" "|")
                       (sequence "READ(!)")
                       (sequence "|" "DONE(d!)" "CANCELED(c!)")))
  (org-todo-keyword-faces '(("CURRENT"  . "orange")
                            ("TODO"     . "systemRedColor")
                            ("READ"     . "systemOrangeColor")
                            ("HOLD"     . "indianRed")
                            ("WAIT"     . "salmon1")
                            ("PROJ"     . "systemYellowColor")))
  :general
  (my/leader-keys
    "n a" '(org-agenda :which-key "agenda")
    "n c" '(org-capture :which-key "capture")
    "n l" '(org-store-link :which-key "store link")
    "n i" '(my/org-insert-link-dwim :which-key "insert link")
    "n f" '(my/org-find-file :which-key "find file")
    "n t" '(org-todo-list :which-key "todo list")
    "n v" '(my/org-open-cv :which-key "cv"))
  :config
  (setq org-confirm-babel-evaluate nil)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)))

  (setq org-directory "~/workspace/org"
        org-agenda-files (list org-directory)
        bibtex-completion-bibliography (concat org-directory "/bibliography.bib")
        org-id-locations-file (concat org-directory "/.orgid")
        ob-async-no-async-languages-alist '("gnuplot" "mermaid"))
  (setq-default org-catch-invisible-edits 'smart)

  (defun my/org-find-file ()
    "Find a file in `org-directory'."
    (interactive)
    (let ((default-directory (file-name-as-directory (expand-file-name org-directory))))
      (call-interactively #'find-file)))

  (defun my/org-open-cv ()
    "Open the org CV file."
    (interactive)
    (find-file (expand-file-name "cv/cv.org" org-directory)))

  (let ((capture-dir (concat user-emacs-directory "org-captures/")))
    (setq org-capture-templates
          `(("c" "Code" entry (file "~/workspace/org/refs/code.org")
             (file ,(concat capture-dir "code-snippet.capture")))
            ("i" "Inbox" entry (file+olp+datetree "~/workspace/org/refs/inbox.org")
             (file ,(concat capture-dir "inbox-snippet.capture")))
            ("b" "Blog post" entry (file+olp "~/workspace/org/refs/blog.org" "Posts")
             (file ,(concat capture-dir "blog-post.capture")))
            ("n" "Note" entry (file+olp "~/workspace/org/refs/notes.org" "Inbox")
             "* %?\nEntered on %U\n  %i\n  %a")
            ("t" "Todo" entry (file "~/workspace/org/refs/todos.org")
             "* TODO %?\n %i\n  %a")
            ("r" "Register new book" entry (file+olp "~/workspace/org/refs/notes.org" "Books")
             (file ,(concat capture-dir "new-book.capture")))
            ("d" "Decision note" entry (file "~/workspace/org/refs/decisions.org")
             (file ,(concat capture-dir "decision.capture"))))))

  (defun my/org-insert-link-dwim ()
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
  :straight t
  :hook (org-mode . org-roam-db-autosync-mode)
  :general
  (my/leader-keys
    "n r f" '(org-roam-node-find :which-key "find node")
    "n r i" '(org-roam-node-insert :which-key "insert node")
    "n r b" '(org-roam-buffer-toggle :which-key "backlinks")
    "n r c" '(org-roam-capture :which-key "capture")
    "n r d" '(org-roam-dailies-goto-today :which-key "today's daily")
    "n r D" '(org-roam-dailies-find-date :which-key "find daily"))
  :custom
  (org-roam-directory (expand-file-name "roam/" org-directory))
  (org-roam-file-exclude-regexp "journal/\\|\.org\.gpg$")
  :config

  (let ((roam-capture-dir (concat user-emacs-directory "org-captures/")))
    (setq org-roam-capture-templates
          `(("d" "default" plain "%?"
             :if-new (file+head "%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}.org\" (current-time) t)"
                                ,(with-temp-buffer
                                   (insert-file-contents (concat roam-capture-dir "roam-default-head.capture"))
                                   (buffer-string)))
             :unnarrowed t))))

  (defun my/org-roam-node-insert-immediate (arg &rest args)
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

  (defun my/org-update-org-ids ()
    "Update all org ids."
    (interactive)
    (org-id-update-id-locations
     (directory-files-recursively
      org-roam-directory "\\.org$"))))

(use-package org-roam-ui
  :straight t
  :requires org-roam
  :after org-roam
  :custom
  (org-roam-ui-sync-theme t)
  (org-roam-ui-follow t)
  (org-roam-ui-update-on-save t)
  (org-roam-ui-open-on-start nil))

(use-package org-contrib
  :requires org
  :after org
  :straight (:host github :repo "emacsmirror/org-contrib")
  :config (require 'ox-extra))

(use-package ox-hugo
  :straight t
  :after org
  :custom
  (org-hugo-external-file-extensions-allowed-for-copying
   '("jpg" "jpeg" "tiff" "png" "svg" "gif"
     "mp4" "pdf" "odt" "doc" "ppt" "xls"
     "docx" "pptx" "xlsx" "zip"))
  :config

  (defun my/org-roam-export-all ()
    "Re-exports all Org-roam files to Hugo markdown."
    (interactive)
    (dolist (f (org-roam--list-all-files))
      (with-current-buffer (find-file f)
        (when (s-contains? "SETUPFILE" (buffer-string))
          (org-hugo-export-wim-to-md))))))

(use-package org-journal
  :general
  (my/leader-keys
    "n j"   '(:ignore t :which-key "journal")
    "n j n" '(org-journal-new-entry :which-key "new journal entry")
    "n j s" '(org-journal-search-forever :which-key "search all journal")
    "n j r" '(org-journal-search :which-key "search ranged journal"))
  :straight t
  :custom
  (org-journal-dir "~/workspace/org/journal")
  (org-journal-encrypt-journal t)
  (org-journal-file-format "%Y%m%d.org")
  (org-journal-date-format "%A, %m/%d/%Y"))

(use-package direnv
  :defer t
  :hook (after-init . direnv-mode))

(use-package restart-emacs
  :straight t
  :requires general
  :commands restart-emacs
  :general
  (my/leader-keys
    "e R" '(restart-emacs :which-key "restart emacs")))

(use-package code-stats
  :defer t
  :straight t
  :hook (kill-emacs . (lambda () (code-stats-sync :wait)))
  :config
  (setq code-stats-token (auth-source-pick-first-password :host "codestats.net"))
  (define-globalized-minor-mode my-global-code-stats-mode code-stats-mode
    (lambda () (code-stats-mode 1)))
  (my-global-code-stats-mode)
  (run-with-idle-timer 30 t #'code-stats-sync))

(use-package project
  :ensure nil
  :hook (find-file . my/project-remember-current)
  :config
  (setq project-switch-commands 'project-find-file)
  (dolist (proj '("~/workspace/dotfiles/"
                  "~/workspace/terraform/"
                  "~/workspace/blog/"
                  "~/workspace/org/"))
    (project-remember-project (list 'vc 'Git proj)))

  (defun my/project-remember-current ()
    (when-let* ((proj (project-current)))
      (project-remember-project proj))))

(use-package emacs
  :ensure nil
  :requires general
  :bind (("C-w" . backward-kill-word)
	 ("C-c C-x k" . (lambda () (interactive) (kill-buffer (current-buffer))))
	 ("<escape>" . keyboard-quit)
	 ("M-z" . zap-up-to-char))
  :hook
  ((emacs-startup . (lambda ()
		      (message
		       "Emacs loaded in %s with %d garbage collections."
		       (format "%.2f seconds"
			       (float-time (time-subtract after-init-time before-init-time)))
		       gcs-done)))
   (after-save . executable-make-buffer-file-executable-if-script-p))
  :general
  (my/leader-keys
    "f d" '(my/delete-current-file :which-key "delete file")
    "f c" '(my/copy-current-file :which-key "copy file")
    "f m" '(my/move-current-file :which-key "move file")
    "f"   '(:ignore t :which-key "files")
    "i"   '(:ignore t :which-key "irc")
    "s"   '(:ignore t :which-key "search")
    "s l" '(:ignore t :which-key "search links")
    "c"   '(:ignore t :which-key "code")
    "n"   '(:ignore t :which-key "org")
    "n r" '(:ignore t :which-key "roam")
    "g"   '(:ignore t :which-key "git")
    "b"   '(:ignore t :which-key "buffers")
    "b b" '(consult-buffer :which-key "switch buffer")
    "b k" '(kill-buffer :which-key "kill buffer")
    "b s" '(save-buffer :which-key "save buffer")
    "b l" '(ibuffer-list-buffers :which-key "list buffers")
    "b n" '(next-buffer :which-key "next buffer")
    "b p" '(prev-buffer :which-key "prev buffer")
    "b r" '(revert-buffer :which-key "revert buffer")
    "w"   '(:ignore t :which-key "windows")
    "w s" '(split-window-below :which-key "split horizontal")
    "w v" '(split-window-right :which-key "split vertical")
    "w k" '(delete-window :which-key "close window")
    "p"   '(:ignore t :which-key "project")
    "p p" '(project-switch-project :which-key "switch project")
    "p f" '(project-find-file :which-key "find file")
    "p k" '(project-kill-buffers :which-key "kill buffers")
    "p c" '(project-compile :which-key "compile project")
    "t"   '(:ignore t :which-key "toggle")
    "t b" '(my/big-font-mode :which-key "big font")
    "q"   '(:ignore t :which-key "quit")
    "e r" '(my/reload-init :which-key "reload config")
    "h"   '(:ignore t :which-key "help")
    "h m" '(describe-mode :which-key "describe mode")
    "h M" '(describe-minor-mode :which-key "describe minor mode")
    "h i" '(info :which-key "info")
    "o"   '(:ignore t :which-key "open")
    "o d" '((lambda () (interactive) (dired "~/workspace/dotfiles/")) :which-key "dotfiles")
    "o t" '((lambda () (interactive) (dired "~/workspace/terraform/")) :which-key "terraform")
    "o b" '((lambda () (interactive) (dired "~/workspace/blog/")) :which-key "blog")
    "o n" '((lambda () (interactive) (dired "~/workspace/org/")) :which-key "org")
    "SPC" '((lambda () (interactive)
              (if (project-current)
                  (project-find-file)
                (call-interactively #'find-file)))
            :which-key "find file")
    "j"   '(:ignore t :which-key "jump")
    "j b" '(consult-bookmark :which-key "bookmark")
    "j w" '(webjump :which-key "webjump")
    "d"   '(:ignore t :which-key "diff")
    "d d" '(my/diff-current-buffer :which-key "diff buffer")
    "d g" '(magit-diff-range :which-key "diff git range")
    "d s" '(diff-buffer-with-file :which-key "diff with file"))
  :custom
  (display-line-numbers-type t)
  (gc-cons-threshold 100000000)              ; 100 mb
  (backup-directory-alist `(("." . ,(expand-file-name "saves/backups/" user-emacs-directory))))
  (auto-save-file-name-transforms `((".*" ,(expand-file-name "saves/auto-saves/" user-emacs-directory) t)))
  (custom-file (locate-user-emacs-file "custom.el"))
  (uniquify-buffer-name-style 'forward)
  (ring-bell-function 'ignore)
  (inhibit-startup-screen t)
  (cursor-type 'bar)
  (auth-sources '("~/.authinfo" "~/.authinfo.gpg" "~/.netrc"))
  (enable-recursive-minibuffers t)
  (undo-limit 67108864)                      ; 64mb
  (undo-strong-limit 100663296)              ; 96mb
  (undo-outer-limit 1006632960)              ; 960mb
  (lock-file-name-transforms '((".*" "~/.emacs.d/locks/" t)))
  (native-comp-async-report-warnings-errors 'silent)
  (use-dialog-box nil)
  :config
  ;; disable bidirectional text scanning (right to left)
  (setq-default bidi-display-reordering 'left-to-right
		bidi-paragraph-direction 'left-to-right
		;; dont render cursors in non-focussed windows
		cursor-in-non-selected-windows nil)
  (set-face-attribute 'default nil
                      :height (if (eq system-type 'gnu/linux) 90 130)
                      :family "Hack Nerd Font")
  (fset 'yes-or-no-p 'y-or-n-p)
  (unless (memq (frame-parameter nil 'fullscreen) '(maximized fullboth))
    (toggle-frame-maximized))

  (dolist (mode '(menu-bar-mode
		  scroll-bar-mode
		  tool-bar-mode))
    (funcall mode -1))

  (dolist (mode '(display-time-mode
		  display-battery-mode
		  global-hl-line-mode
		  save-place-mode
		  recentf-mode
		  global-display-line-numbers-mode
		  global-auto-revert-mode))
    (funcall mode 1))

  ;; for emacs lock files
  (make-directory "~/.emacs.d/locks" t)
  (make-directory (expand-file-name "saves/auto-saves/" user-emacs-directory) t)

  (require 'uniquify)

  (setq read-process-output-max (* 4 1024 1024) ; 4MB
        inhibit-compacting-font-caches t
	;; skip fontification during input. this defers fontification until we stop typing
	redisplay-skip-fontification-on-input t
	bidi-inhibit-bpa t
	;; dont render cursors in non-focussed windows
	highlight-nonselected-windows nil
	;; save the Clipboard Before Killing
	save-interprogram-paste-before-kill t
	;; no Duplicates in the Kill Ring
	kill-do-not-save-duplicates t
	;; persist the Kill Ring Across Sessions
	savehist-additional-variables '(search-ring regexp-search-ring kill-ring)
	)


  (when (file-exists-p custom-file)
    (load custom-file))

  ;; Automatically create missing parent directories when visiting a file,
  ;; suppressing the "Use M-x make-directory" prompt.
  (add-to-list 'find-file-not-found-functions
               (lambda ()
                 (make-directory (file-name-directory buffer-file-name) t)
                 nil))

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

  (defun my/diff-current-buffer ()
    (interactive)
    (ediff-buffers (current-buffer)
                   (read-buffer "Ediff with buffer: " nil t)))

  (defun my/reload-init ()
    "Reload init.el in the current Emacs session."
    (interactive)
    (load-file user-init-file)
    (message "init.el reloaded"))

  (defun my/consult-rg-project ()
    "Run consult-ripgrep from the current project root."
    (interactive)
    (consult-ripgrep (project-root (project-current t))))

  (defun my/delete-current-file ()
    "Delete the file the current buffer is visiting and kill the buffer."
    (interactive)
    (let ((file (buffer-file-name)))
      (unless file (user-error "Buffer is not visiting a file"))
      (when (yes-or-no-p (format "Delete %s? " file))
        (delete-file file t)
        (kill-buffer))))

  (defun my/copy-current-file (dest)
    "Copy the file the current buffer is visiting to DEST and open it."
    (interactive (list (read-file-name "Copy to: " default-directory)))
    (let ((file (buffer-file-name)))
      (unless file (user-error "Buffer is not visiting a file"))
      (copy-file file dest)
      (find-file dest)))

  (defun my/move-current-file (dest)
    "Move (rename) the file the current buffer is visiting to DEST."
    (interactive (list (read-file-name "Move to: " default-directory)))
    (let ((file (buffer-file-name)))
      (unless file (user-error "Buffer is not visiting a file"))
      (rename-file file dest t)
      (set-visited-file-name dest t t)))

  (defun my/sudo-current-buffer ()
    (interactive)
    (find-alternate-file (concat "/sudo::" buffer-file-name)))

  ;; load custom chezmoi applied configuration
  (load (expand-file-name "chezmoi.el" user-emacs-directory) t)

  (let ((elisp-dir (expand-file-name "elisp" user-emacs-directory)))
    (when (file-directory-p elisp-dir)
      (add-to-list 'load-path elisp-dir)
      (dolist (file (directory-files-recursively elisp-dir "\\.el\\'"))
	(load file nil t)))))

(use-package epa
  :ensure nil
  :config
  (setq epa-armor t))

(use-package terraform-mode
  :straight t
  :mode "\\.tf\\'")

(use-package autoinsert
  :custom
  (auto-insert-query nil)
  :config
  (auto-insert-mode 1)
  (setq auto-insert-alist nil)
  (defun my/org-auto-insert ()
    (unless (and (fboundp 'org-roam-capture-p) (org-roam-capture-p))
      (let* ((base (file-name-base buffer-file-name))
             (spaced (let (case-fold-search)
                       (replace-regexp-in-string
                        "\\([[:lower:]]\\)\\([[:upper:]]\\)" "\\1 \\2"
                        (replace-regexp-in-string
                         "\\([[:upper:]]\\)\\([[:upper:]][0-9[:lower:]]\\)"
                         "\\1 \\2" base))))
             (title (string-join (mapcar #'capitalize
                                         (split-string spaced "[^[:word:]0-9]+"))
                                 " ")))
        (insert "#+TITLE: " (read-string "Title: " title) "\n"
                "#+SUBTITLE: " (read-string "Subtitle: " "") "\n"
                "#+AUTHOR: " (user-full-name) "\n"
                "#+EMAIL: " user-mail-address "\n"
                "#+DATE: <" (format-time-string "%F %a %R") ">\n\n"
                "#+HTML_DOCTYPE: xhtml5\n"
                "#+HTML_HTML5_FANCY:\n\n"
                "# Hugo config\n"
                "#+DRAFT: false\n"
                "#+HUGO_AUTO_SET_LASTMOD: t\n"
                "#+HUGO_BASE_DIR: ~/workspace/blog\n"
                "#+HUGO_AUTO_SET_LASTMOD: t\n\n"))))

  (define-auto-insert '("\\.org\\'" . "Org template") #'my/org-auto-insert)

  (defun my/python-file-header ()
    (insert "# Author: " (user-full-name) " <" user-mail-address ">\n")
    (insert "# Created at <" (format-time-string "%F %a %R") ">\n")
    (insert "\n"))

  (define-auto-insert '("\\.py\\'" . "Python template")
    '(nil (my/python-file-header) _))

  (define-auto-insert '("__main__\\.py\\'" . "Python __main__ template")
    '(nil
      (my/python-file-header)
      \n
      "def main() -> None:" \n
      > _ \n
      > "..." \n
      "\n\nif __name__ == \"__main__\":\n    main()\n"))

  (define-auto-insert '("\\.github/workflows/.*\\.yml\\'" . "GitHub Actions workflow")
    '(nil
      "name: " (skeleton-read "Workflow name: " "CI") \n
      \n
      "on:" \n
      > "push:" \n
      > > "branches: [main]" \n
      > "pull_request:" \n
      > > "branches: [main]" \n
      \n
      "jobs:" \n
      > (skeleton-read "Job name: " "ci") ":" \n
      > > "runs-on: ubuntu-latest" \n
      > > "steps:" \n
      > > > "- uses: actions/checkout@v4" \n
      > > > "- name: " _ \n)))

(use-package yaml-mode
  :straight t
  :mode ("\\.yaml\\'" "\\.yml\\'"))

(use-package json-mode
  :straight t
  :mode "\\.json\\'")

(use-package markdown-mode
  :straight t
  :mode ("\\.md\\'" . gfm-mode))

(use-package dockerfile-mode
  :straight t
  :mode ("\\Dockerfile\\'" . dockerfile-mode))

(use-package sh-script
  :ensure nil
  :mode (("\\.sh\\'"    . bash-ts-mode)
         ("\\.zsh\\'"   . bash-ts-mode)
         ("\\.bash\\'"  . bash-ts-mode)
         ("/\\.zshrc\\'" . bash-ts-mode)
         ("/\\.bashrc\\'" . bash-ts-mode)))

(use-package python
  :mode ("\\.py\\'" . python-ts-mode)
  :hook (python-ts-mode . my/python-maybe-activate-venv)
  :config
  (defun my/python-fmt ()
    (interactive)
    (let ((default-directory (or (when-let* ((proj (project-current)))
                                   (project-root proj))
				 default-directory)))
      (async-shell-command "uv run task fmt" "*python-fmt*" "*python-fmt-stderr*")))

  (defun my/python-test ()
    (interactive)
    (let ((default-directory (or (when-let* ((proj (project-current)))
                                   (project-root proj))
				 default-directory)))
      (async-shell-command "uv run task test" "*python-test*" "*python-test-stderr*")))

  (defun my/python-types ()
    (interactive)
    (let ((default-directory (or (when-let* ((proj (project-current)))
                                   (project-root proj))
				 default-directory)))
      (async-shell-command "uv run task check_types" "*python-types*" "*python-test-stderr*")))

  (defun my/python-activate-venv ()
    (interactive)
    (let* ((root (or (when-let* ((proj (project-current)))
		       (project-root proj))
                     default-directory))
           (venv (expand-file-name ".venv" root)))
      (pyvenv-activate venv)))

  (defvar my/python-last-project nil
    "Project root for which a venv was last activated.")

  (defun my/python-maybe-activate-venv (&optional _frame)
    "Activate .venv when the current buffer belongs to a new Python project."
    (when-let* ((proj (project-current))
		(root (project-root proj))
		(venv (expand-file-name ".venv" root)))
      (when (and (not (equal root my/python-last-project))
		 (file-exists-p (expand-file-name "pyproject.toml" root))
		 (file-directory-p venv))
	(setq my/python-last-project root)
	(pyvenv-activate venv)))))

(use-package kubernetes
  :straight (:host github :repo "kubernetes-el/kubernetes-el" :tag "0.19.0")
  :straight t
  :commands (kubernetes-overview)
  :custom
  (kubernetes-poll-frequency 3600)
  (kubernetes-redraw-frequency 3600))

(use-package kubernetes-evil
  :straight t
  :requires (evil kubernetes)
  :after kubernetes)

(use-package helpful
  :straight t
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-h x" . helpful-command)
   ("C-c C-d" . helpful-at-point)
   ("C-h F" . helpful-function))
  :general
  (my/leader-keys
    "h k" '(helpful-key :which-key "describe key")
    "h v" '(helpful-variable :which-key "describe variable")
    "h f" '(helpful-function :which-key "describe function")
    "h c" '(helpful-command :which-key "describe command")))

(use-package osx-lib
  :if (eq system-type 'darwin)
  :straight t)

(use-package pkgbuild-mode
  :if (eq system-type 'gnu/linux)
  :straight t)

(use-package circe
  :straight t
  :demand t
  :general
  (my/leader-keys
    "i c" '(my/irc :which-key "connect to irc")
    "i s" '(my/circe-switch-channel :which-key "switch irc channel"))
  :config
  (defun my/fetch-password (&rest params)
    (require 'auth-source)
    (let ((match (car (apply #'auth-source-search params))))
      (if match
          (let ((secret (plist-get match :secret)))
            (if (functionp secret)
	        (funcall secret)
              secret))
        (error "Password not found for %S" params))))

  (defun my/irccloud-password (server)
    (my/fetch-password :user "seds" :host "bnc.irccloud.com" :port 6697))

  (require 'lui-autopaste)
  (add-hook 'circe-channel-mode-hook 'enable-lui-autopaste)

  ;; consult-completion-in-region is set globally but causes the buffer to
  ;; jump/scroll as the popup resizes with each candidate list.  Use the
  ;; default completion--in-region locally so circe-use-cycle-completion
  ;; can cycle silently without opening a minibuffer popup.
  (defun my/circe-use-default-completion ()
    (setq-local completion-in-region-function #'completion--in-region))
  (add-hook 'circe-channel-mode-hook #'my/circe-use-default-completion)
  (add-hook 'circe-query-mode-hook   #'my/circe-use-default-completion)

  ;; set channel name in prompt
  (add-hook 'circe-chat-mode-hook 'my-circe-prompt)
  (defun my-circe-prompt ()
    (lui-set-prompt
     (concat (propertize (concat (buffer-name) ">")
		         'face 'circe-prompt-face)
             " ")))

  ;; Nick colorization
  (enable-circe-color-nicks)
  (setq circe-color-nicks-everywhere t)

  ;; Right-aligned fixed-width nick column
  (defvar my/circe-nick-column 8
    "Max nick width; nicks longer than this are truncated.")

  (defun my/lui-format-pad-nick (args)
    "Format :nick in ARGS as <nick> left-aligned in a fixed column.
Nicks longer than `my/circe-nick-column' are truncated.
Handles both (lui-format fmt :key val ...) and (lui-format fmt \\='(:key val ...))
since circe-display passes the plist as a single wrapped list."
    (let* ((fmt  (car args))
           (rest (cdr args))
           ;; circe-display calls (lui-format fmt '(:nick ...)) — unwrap that
           (wrapped   (and (= 1 (length rest)) (listp (car rest))))
           (keywords  (if wrapped (car rest) rest))
           (nick      (plist-get keywords :nick)))
      (if nick
          (let* ((nick-trimmed (if (> (length nick) my/circe-nick-column)
                                   (substring nick 0 my/circe-nick-column)
                                 nick))
                 (wrapped-nick (format "<%s>" nick-trimmed))
                 (pad    (max 0 (- (+ my/circe-nick-column 2) (length wrapped-nick))))
                 (padded (concat wrapped-nick (make-string pad ?\s)))
                 (new-kw (plist-put (copy-sequence keywords) :nick padded)))
            (if wrapped
                (list fmt new-kw)
              (cons fmt new-kw)))
        args)))

  (advice-add 'lui-format :filter-args #'my/lui-format-pad-nick)

  (defvar my/circe-time-stamp-format "[%H:%M:%S] "
    "Timestamp format prepended to each message.")

  ;; Prepend the timestamp inside lui-insert, BEFORE lui calls fill-region.
  ;; lui's built-in 'left timestamp is added AFTER fill, so continuation lines
  ;; don't account for the timestamp width and body alignment breaks.
  ;; By injecting it here, fill-region sees the complete line and wraps correctly.
  (defun my/lui-insert-with-timestamp (orig-fn str &optional not-tracked)
    (funcall orig-fn
             (concat (format-time-string my/circe-time-stamp-format) str)
             not-tracked))
  (advice-add 'lui-insert :around #'my/lui-insert-with-timestamp)

  ;; circe-nick-color-mapping accumulates every nick ever seen and is never
  ;; pruned.  Clear it on GC so it doesn't balloon to hundreds of KiB.
  (add-hook 'post-gc-hook
            (lambda ()
              (when (and (boundp 'circe-nick-color-mapping)
                         (> (hash-table-count circe-nick-color-mapping) 500))
                (clrhash circe-nick-color-mapping))))

  (advice-add 'circe-display-CHGHOST :override #'ignore)

  (setq circe-ignore-list '("Re-join:" "Quit: ")
        circe-reduce-lurker-spam t
        circe-format-server-lurker-activity ""
        circe-highlight-nick-type 'message
        lui-time-stamp-position nil  ; disabled — injected in lui-insert above
        lui-fill-type (make-string (+ (length my/circe-time-stamp-format)
				      my/circe-nick-column 3) ?\s)
        lui-fill-column 120
        circe-format-server-topic "*** Topic change by {userhost}: {topic-diff}"
        circe-format-say "{nick} {body}"
        circe-format-self-say "{nick} {body}"
        circe-use-cycle-completion t
        circe-network-options
        '(("irccloud"
	   :nick "seds"
	   :port 6697
	   :use-tls t
	   :host "bnc.irccloud.com"
	   :channels (:after-auth "#emacs")
	   :pass my/irccloud-password)))

  (defun my/circe-switch-channel ()
    "Switch to an open Circe channel or query buffer via completing-read."
    (interactive)
    (let* ((bufs (seq-filter (lambda (b)
                               (with-current-buffer b
                                 (derived-mode-p 'circe-channel-mode
                                                 'circe-query-mode)))
                             (buffer-list)))
           (names (mapcar #'buffer-name bufs))
           (choice (completing-read "IRC channel: " names nil t)))
      (switch-to-buffer choice)))

  (defun my/irc ()
    "Connect to IRC"
    (interactive)
    (circe "irccloud"))

  )

(use-package editorconfig
  :straight t
  :init
  (editorconfig-mode 1))

(use-package go-mode
  :straight t
  :mode ("\\.go\\'" . go-ts-mode))

(use-package link-hint
  :straight t
  :general
  (my/leader-keys
    "s l o" '(link-hint-open-link :which-key "open link")
    "s l c" '(link-hint-copy-link :which-key "copy link")
    "s l a" '(link-hint-copy-all-links :which-key "copy all links")))

(use-package gnus
  :ensure nil
  :after auth-source
  :custom
  (gnus-select-method '(nnimap "fastmail"
                               (nnimap-address "imap.fastmail.com")
                               (nnimap-server-port 993)
                               (nnimap-stream ssl)))
  (gnus-secondary-select-methods nil)
  (smtpmail-smtp-server "smtp.fastmail.com")
  (smtpmail-smtp-service 587)
  (smtpmail-stream-type 'starttls)
  (send-mail-function #'smtpmail-send-it)
  (message-send-mail-function #'smtpmail-send-it)
  (gnus-use-cache t)
  (gnus-read-active-file 'some)
  (nnmail-expiry-target "nnimap+fastmail:Trash")
  (nnmail-expiry-wait 'immediate)
  (gnus-fetch-old-headers nil)
  (mm-discouraged-alternatives '("text/html" "text/richtext"))
  (gnus-message-archive-group "nnimap+fastmail:Sent")
  (mail-user-agent 'gnus-user-agent)
  (gnus-summary-line-format "%U%R%z %(%&user-date;%) %-15,15f %B%S\n")
  (gnus-user-date-format-alist '((t . "%Y-%m-%d %H:%M")))
  (nnml-directory (expand-file-name "gnus/mail" user-emacs-directory))
  (message-directory (expand-file-name "gnus/mail" user-emacs-directory))
  :config
  (add-hook 'gnus-article-prepare-hook
            (lambda () (select-window (get-buffer-window gnus-article-buffer))))
  (define-key gnus-summary-mode-map (kbd "A")
              (lambda () (interactive)
                (gnus-summary-move-article nil "nnimap+fastmail:Archive"))))

(use-package message
  :straight nil
  :hook (message-mode . auto-fill-mode)
  :custom
  (message-signature "    Ben Mezger\n"))

(use-package deft
  :straight t
  :commands (deft)
  :general
  (my/leader-keys
    "n d" '(deft :which-key "deft"))
  :config
  (setq deft-extensions '("txt" "tex" "org")
        deft-directory org-directory
        deft-recursive t
        deft-use-filename-as-title t))

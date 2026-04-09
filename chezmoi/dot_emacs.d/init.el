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

(let ((elisp-dir (expand-file-name "elisp" user-emacs-directory)))
  (when (file-directory-p elisp-dir)
    (add-to-list 'load-path elisp-dir)
    (dolist (file (directory-files-recursively elisp-dir "\\.el\\'"))
      (load file nil t))))


(use-package straight
  :custom
  (straight-use-package-by-default t)
  (straight-recipe-repositories '(org-elpa melpa gnu-elpa-mirror nongnu-elpa el-get emacsmirror-mirror)))

(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
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
  :custom
  (undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  :config
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
  :init (load-theme 'gruvbox-dark-hard t)
  :config
  (custom-set-faces
   '(vertico-current ((t (:background "#3c3836" :foreground "#ebdbb2" :extend t))))))

(use-package doom-modeline
  :ensure t
  :init
  ;; Disable icons to prevent a crash on macOS ARM64 (GNU Emacs bug#68940).
  ;; During init, nsterm.m's `layoutSublayersOfLayer:' fires `redisplay()'
  ;; before the face cache is fully initialised.  doom-modeline's battery
  ;; status update then calls `char-displayable-p', which reaches
  ;; `font_find_for_lface' and dereferences the corrupted cache → SIGABRT.
  ;; Keeping icons off prevents any `char-displayable-p' calls at startup.
  (when (eq system-type 'darwin)
    (setq doom-modeline-icon nil))
  (doom-modeline-mode 1))

(use-package consult
  :ensure t
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
    "s d" '((lambda () (interactive) (consult-ripgrep default-directory nil)) :which-key "rg directory")
    "s i" '(consult-imenu :which-key "imenu")
    "p g" '(consult-ripgrep :which-key "grep files")
    "p s" '(my/consult-rg-project :which-key "search project")
    "g g" '(consult-git-grep :which-key "git grep")
    "p b" '(consult-project-buffer :which-key "project buffers"))
  :custom
  (consult-async-min-input 0)
  :config
  (consult-customize
   consult-ripgrep consult-grep consult-git-grep
   consult-buffer consult-project-buffer consult-recent-file
   consult-imenu
   :group nil
   :preview-key "M-."))

(use-package embark
  :ensure t
  :bind*
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :config
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package wgrep
  :ensure t
  :hook (grep-mode . wgrep-setup)
  :custom
  (wgrep-auto-save-buffer t))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :ensure t
  :custom
  (which-key-sort-order 'which-key-key-order-alpha)
  (which-key-side-window-max-width 0.333)
  (which-key-idle-delay 1.0)
  :config
  (which-key-setup-minibuffer))

(use-package magit
  :ensure t
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
  :custom
  (company-idle-delay 0.0)
  (company-minimum-prefix-length 1))

(use-package treesit-auto
  :ensure t
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
  :ensure t
  :after company
  :requires (which-key company general)
  :hook ((python-mode    . lsp-deferred)
         (python-ts-mode . lsp-deferred)
         (bash-ts-mode   . lsp-deferred)
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
  :ensure t
  :requires (lsp-mode consult)
  :after lsp-mode
  :commands (consult-lsp-symbols consult-lsp-diagnostics consult-lsp-file-symbols))

(use-package lsp-ui
  :ensure t
  :requires lsp-mode
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda () (require 'lsp-pyright)))
  :after lsp-mode)

(use-package org
  :straight t
  :ensure t
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
    "n i" '(benmezger/org-insert-link-dwim :which-key "insert link")
    "n f" '(benmezger/org-find-file :which-key "find file")
    "n t" '(org-todo-list :which-key "todo list")
    "n j" '(org-journal-new-entry :which-key "new journal entry")
    "n v" '(benmezger/org-open-cv :which-key "cv"))
  :config
  (setq org-directory "~/workspace/org"
        org-agenda-files (list org-directory)
        bibtex-completion-bibliography (concat org-directory "/bibliography.bib")
        org-id-locations-file (concat org-directory "/.orgid")
        ob-async-no-async-languages-alist '("gnuplot" "mermaid"))
  (setq-default org-catch-invisible-edits 'smart)

  (defun benmezger/org-find-file ()
    "Find a file in `org-directory'."
    (interactive)
    (let ((default-directory (file-name-as-directory (expand-file-name org-directory))))
      (call-interactively #'find-file)))

  (defun benmezger/org-open-cv ()
    "Open the org CV file."
    (interactive)
    (find-file (expand-file-name "cv/cv.org" org-directory)))

  (let ((capture-dir (concat user-emacs-directory "org-captures/")))
    (setq org-capture-templates
          `(("c" "Code" entry (file "~/workspace/org/refs/code.org")
             (file ,(concat capture-dir "code-snippet.capture")))
            ("i" "Inbox" entry (file+datetree "~/workspace/org/refs/inbox.org")
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

  (defun benmezger/org-update-org-ids ()
    "Update all org ids."
    (interactive)
    (org-id-update-id-locations
     (directory-files-recursively
      org-roam-directory "\\.org$"))))

(use-package org-roam-ui
  :ensure t
  :requires org
  :after org-roam
  :custom
  (org-roam-ui-sync-theme t)
  (org-roam-ui-follow t)
  (org-roam-ui-update-on-save t)
  (org-roam-ui-open-on-start nil))

(use-package org-contrib
  :after org
  :straight (:host github :repo "emacsmirror/org-contrib")
  :config (require 'ox-extra))

(use-package ox-hugo
  :ensure t
  :after org
  :custom
  (org-hugo-external-file-extensions-allowed-for-copying
   '("jpg" "jpeg" "tiff" "png" "svg" "gif"
     "mp4" "pdf" "odt" "doc" "ppt" "xls"
     "docx" "pptx" "xlsx" "zip"))
  :config

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
  :custom
  (org-journal-dir "~/workspace/org/journal")
  (org-journal-encrypt-journal t)
  (org-journal-file-format "%Y%m%d.org"))

(use-package direnv
  :defer t
  :hook (after-init . direnv-mode))

(use-package restart-emacs
  :ensure t
  :requires general
  :commands restart-emacs
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

(use-package package
  :ensure nil
  :config
  (setq project-switch-commands 'project-find-file)
  (dolist (proj '("~/workspace/dotfiles/"
                  "~/workspace/terraform/"
                  "~/workspace/org/"))
    (project-remember-project (list 'vc 'Git proj))))

(use-package emacs
  :ensure nil
  :requires general
  :bind (("C-w" . backward-kill-word)
	 ("C-c C-x k" . (lambda () (interactive) (kill-buffer (current-buffer))))
	 ("<escape>" . keyboard-quit))
  :hook
  ((emacs-startup . (lambda ()
		      (message
		       "Emacs loaded in %s with %d garbage collections."
		       (format "%.2f seconds"
			       (float-time (time-subtract after-init-time before-init-time)))
		       gcs-done))))
  :general
  (my/leader-keys
    "f d" '(my/delete-current-file :which-key "delete file")
    "f c" '(my/copy-current-file :which-key "copy file")
    "f"   '(:ignore t :which-key "files")
    "s"   '(:ignore t :which-key "search")
    "c"   '(:ignore t :which-key "code")
    "n"   '(:ignore t :which-key "org")
    "n r" '(:ignore t :which-key "roam")
    "g"   '(:ignore t :which-key "git")
    "b"   '(:ignore t :which-key "buffers")
    "b b" '(consult-buffer :which-key "switch buffer")
    "b k" '(kill-buffer :which-key "kill buffer")
    "b s" '(save-buffer :which-key "save buffer")
    "b l" '(list-buffers :which-key "list buffers")
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
    "SPC" '(project-find-file :which-key "find file")
    "j"   '(:ignore t :which-key "jump")
    "j b" '(consult-bookmark :which-key "bookmark")
    "j w" '(webjump :which-key "webjump")
    "d"   '(:ignore t :which-key "diff")
    "d d" '(my/diff-current-buffer :which-key "diff buffer")
    "d g" '(magit-diff-range :which-key "diff git range")
    "d s" '(diff-buffer-with-file :which-key "diff with file"))
  :custom
  (epa-armor t)
  (display-line-numbers-type t)
  (gc-cons-threshold 100000000)              ; 100 mb
  (backup-directory-alist '(("." . "~/.saves")))
  (auto-save-file-name-transforms '((".*" "~/.saves/" t)))
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
  (set-face-attribute 'default nil
                      :height (if (eq system-type 'gnu/linux) 90 130)
                      :family "Hack Nerd Font")
  (fset 'yes-or-no-p 'y-or-n-p)
  (global-display-line-numbers-mode)
  (global-auto-revert-mode t)
  (unless (memq (frame-parameter nil 'fullscreen) '(maximized fullboth))
    (toggle-frame-maximized))
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (display-time-mode 1)
  (display-battery-mode 1)
  (global-hl-line-mode 1)
  (save-place-mode)
  (recentf-mode)

  ;; for emacs lock files
  (make-directory "~/.emacs.d/locks" t)

  (require 'uniquify)

  (setq read-process-output-max (* 1024 1024) ; 1mb — defvar, not defcustom
        inhibit-compacting-font-caches t)     ; defvar, not defcustom

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
  )

(use-package terraform-mode
  :ensure t
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
  :ensure t
  :mode ("\\.yaml\\'" "\\.yml\\'"))

(use-package json-mode
  :ensure t
  :mode "\\.json\\'")

(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . gfm-mode))

(use-package dockerfile-mode
  :ensure t
  :mode ("\\Dockerfile\\'" . dockerfile-mode))

(use-package sh-script
  :ensure nil
  :mode (("\\.sh\\'"    . bash-ts-mode)
         ("\\.zsh\\'"   . bash-ts-mode)
         ("\\.bash\\'"  . bash-ts-mode)
         ("/\\.zshrc\\'" . bash-ts-mode)
         ("/\\.bashrc\\'" . bash-ts-mode)))

(use-package python
  :mode "\\.py\\'"
  :hook (python-mode . benmezger/python-maybe-activate-venv)
  :config
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
	(pyvenv-activate venv)))))

(use-package kubernetes
  :straight (:host github :repo "kubernetes-el/kubernetes-el" :tag "0.19.0")
  :ensure t
  :commands (kubernetes-overview)
  :custom
  (kubernetes-poll-frequency 3600)
  (kubernetes-redraw-frequency 3600))

(use-package kubernetes-evil
  :ensure t
  :requires evil
  :after kubernetes)

(use-package helpful
  :ensure t
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

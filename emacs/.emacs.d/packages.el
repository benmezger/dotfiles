;; enable packages
(require 'cl)
(require 'package)

(setq package-enable-at-startup t)

                                        ; add package archive
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                          ("melpa" . "https://melpa.org/packages/")
                          ("org" . "http://orgmode.org/elpa/")))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; packages to install
(defvar required-packages
  '(
     try
     which-key
     magit
     git-gutter-fringe+
     fringe-helper
     evil-magit
     evil-magit
     ;; helm
     ;; helm-ls-git
     ;; helm-projectile
     ;; helm-rg
     counsel
     counsel-projectile
     counsel-etags
     ivy-rich
     all-the-icons-ivy
     flx
     smex
     ripgrep
     ;; base16-theme
     doom-themes
     rainbow-delimiters
     elpy
     pyenv-mode
     wakatime-mode
     evil
     evil-leader
     editorconfig
     flycheck
     org
     ;; smart-mode-line
     ;; smart-mode-line-atom-one-dark-theme
     mode-line-bell
     yasnippet
     undo-tree
     markdown-mode
     yaml-mode
     exec-path-from-shell
     highlight-indent-guides
     avy
     all-the-icons-dired
     adoc-mode
     org-journal
     mode-icons
     projectile
     diminish
     auto-package-update
     disable-mouse
     super-save
     centaur-tabs
     ) "a list of packages to ensure are installed at launch.")


;; method to check if all packages are installed
(defun packages-installed-p ()
  (loop for p in required-packages
    when (not (package-installed-p p)) do (return nil)
    finally (return t)))

;; if not all packages are installed, check one by one and install the missing ones.
(unless (packages-installed-p)
  ;; check for new packages (package versions)
  (message "%s" "Emacs is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; install the missing packages
  (dolist (p required-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(use-package try :ensure t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-minibuffer))

;; startup
(load "~/.emacs.d/packages/doom.el")
;; (load "~/.emacs.d/packages/base16.el")
(load "~/.emacs.d/packages/evil.el")
(load "~/.emacs.d/packages/editorconfig.el")
;; (load "~/.emacs.d/packages/helm.el")
(load "~/.emacs.d/packages/ivy.el")
(load "~/.emacs.d/packages/magit.el")
(load "~/.emacs.d/packages/rainbow_delimiter.el")

(load "~/.emacs.d/packages/python.el")
(load "~/.emacs.d/packages/wakatime.el")
(load "~/.emacs.d/packages/flycheck.el")
(load "~/.emacs.d/packages/orgmode.el")
(load "~/.emacs.d/packages/gitgutter.el")
;; (load "~/.emacs.d/packages/modeline.el")
(load "~/.emacs.d/packages/yasnippet.el")
(load "~/.emacs.d/packages/undotree.el")
(load "~/.emacs.d/packages/markdown.el")
(load "~/.emacs.d/packages/completion.el")
(load "~/.emacs.d/packages/yaml.el")

(if (eq system-type 'darwin)
  (load "~/.emacs.d/packages/execpath.el"))

(load "~/.emacs.d/packages/indentguide.el")
(load "~/.emacs.d/packages/avy.el")
(load "~/.emacs.d/packages/icons.el")
(load "~/.emacs.d/packages/adoc.el")
(load "~/.emacs.d/packages/projectile.el")
(load "~/.emacs.d/packages/diminish.el")
(load "~/.emacs.d/packages/autoupdate.el")
(load "~/.emacs.d/packages/mouse.el")
(load "~/.emacs.d/packages/super_save.el")
(load "~/.emacs.d/packages/centaurtabs.el")

;; PGP
(require 'epa-file)
(epa-file-enable)

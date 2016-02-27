;; let cask manage my packages

(if (eq system-type 'darwin)
    (require 'cask "~/.cask/cask.el")
  (require 'cask "~/.cask/cask.el"))
(cask-initialize)

;; custom site lisp
(setq site-lisp-dir
      (expand-file-name "site-lisp" user-emacs-directory))
(add-to-list 'load-path site-lisp-dir)

;; keep emacs custom settings in a different file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; keep emacs configuration in a different file
(setq emacs-file (expand-file-name "emacs.el" user-emacs-directory))
(load emacs-file)

;; load package configurations
(require 'emacs)
(require 'setup-orgmode)
(require 'setup-smartline)
(require 'setup-theme)
(require 'setup-magit)
(require 'setup-acejump)
(require 'setup-helm)
(require 'setup-projectile)
(require 'linum-off)
(require 'setup-completion)
(require 'setup-git-gutter)
(require 'setup-mu4e)
(require 'setup-autopair)
(require 'setup-w3m)
(require 'setup-elfeed)
(require 'setup-exec-path-from-shell)
(require 'setup-jabber)
(require 'setup-twitter)
(require 'setup-virtualenvwrapper)
(require 'setup-ag)
(require 'setup-evil)
(require 'setup-editorconfig)

;; session
(add-hook 'after-init-hook 'session-initialize)

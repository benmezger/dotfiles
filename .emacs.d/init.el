;; let cask manage my packages
(require 'cask "~/.cask/cask.el")
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

;; load site-lisps
(require 'setup-completion)
(require 'setup-orgmode)
(require 'setup-editorconfig)
(require 'setup-magit)
(require 'setup-gitgutter)
(require 'setup-smartline)
(require 'setup-smartparens)
(require 'setup-exec-path-from-shell)

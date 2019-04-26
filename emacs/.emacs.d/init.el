; disable startup message
(setq inhibit-startup-message t)


;; Emacs general config
; keep it minimal
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq-default cursor-type 'bar)

; set custom config file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

; backups
(setq backup-directory-alist '(("." . "~/.emacs.d/fbackup")))
(setq backup-by-copying t)

(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

; load packages
(load "~/.emacs.d/packages.el")

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
        (package-refresh-contents)
        (package-install 'use-package))


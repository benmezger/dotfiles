
;; disable startup message
(setq inhibit-startup-message t)


;; Emacs general config
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(display-time-mode 1)

(global-hl-line-mode)
(setq-default cursor-type 'bar)

;; set font
(set-face-attribute 'default nil
                    :family "Inconsolata-dz"
                    :height 140)

;; set custom config file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; backups
(setq backup-directory-alist '(("." . "~/.emacs.d/fbackup")))
(setq backup-by-copying t)

(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; load packages
(load "~/.emacs.d/packages.el")

;; disable startup message
(setq inhibit-startup-message t)

;; Emacs general config
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(display-time-mode 1)
(display-battery-mode 1)

(global-hl-line-mode)
(setq-default cursor-type 'bar)


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

(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))

(setq user-full-name "Ben Mezger"
      user-mail-address "me@benmezger.nl")

;; load packages
(load "~/.emacs.d/packages.el")

(toggle-frame-maximized) ;; start at maximzed frame

(if (eq system-type 'darwin)
  (set-frame-font "InconsolataDZ 12" nil t)
  (if (eq system-type 'gnu/linux)
    (set-frame-font "InconsolataDZ 8" nil t)))


;; set line number
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)
(set-face-attribute 'line-number-current-line nil :inverse-video nil)

(setq-default shell-file-name "/bin/bash")
(setq-default explicit-shell-file-name "/bin/bash")

;; Set 50MB for the garbage collection
;; and
(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)

;; Replate yes-or-not to y-or-n
(fset 'yes-or-no-p 'y-or-n-p)

;; reload files automatically
(global-auto-revert-mode t)

;; Cleanup whitespaces before save
(add-hook 'before-save-hook 'whitespace-cleanup)

;; human-readable file size format
(setq dired-listing-switches "-alh")

;; kill minibuffer when another buffer gets clicked
(defun stop-using-minibuffer ()
  "kill the minibuffer"
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))

(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

;; fixes helm lag
;; (setq x-wait-for-event-timeout nil)

(require 'whitespace)
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))
(global-whitespace-mode +1)

;; turn off alarm bell completly
(setq ring-bell-function 'ignore)

;; Store point place
(save-place-mode 1)

;; save silently
(setq save-silently t)

;; unbind keys
(global-unset-key (kbd "C-x C-b"))

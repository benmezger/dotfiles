;; emacs configuration

;; disable menu bar and tool bar
;; (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; set cursor type
(setq-default cursor-type 'bar)

;; disable startup screen, set column number, etc
(setq-default inhibit-startup-screen t
	      column-number-mode t
	      line-number-mode t
	      fill-column 80
	      use-dialog-box nil)

;; tabs to space
(setq-default indent-tabs-mode nil)
(setq-default standard-indent 4)
(setq default-tab-width 4)
(setq-default c-basic-offset 4)

;; display time
(display-time-mode)

;; display battery stats
(display-battery-mode 1)

;; line number
(setq linum-format "%4d \u2502 ")
(global-linum-mode t)

;; save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; highlight current line
(global-hl-line-mode t)

; start emacs with empty file
(setq inhibit-splash-screen t)
(switch-to-buffer "**")

; completion splits horizontally
(setq split-width-threshold nil)

; ido-mode
(require 'ido)
(ido-mode t)

; winner mode
(when (fboundp 'winner-mode)
  (winner-mode 1))

; windmove
(windmove-default-keybindings)

; CamelCase distinction
(global-subword-mode t)

; yes/no to y/n
(fset 'yes-or-no-p 'y-or-n-p)

; read only prompt
(setq comint-prompt-read-only t)

; add homebrew's path
(add-to-list 'exec-path "/usr/local/bin")

; show matching parenthesis
(show-paren-mode 1)

;; backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; set font
(set-frame-font "Inconsolata-14")

(define-minor-mode sensitive-mode
  "For sensitive files like password lists.
It disables backup creation and auto saving.

With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode."
  ;; The initial value.
  nil
  ;; The indicator for the mode line.
  " Sensitive"
  ;; The minor mode bindings.
  nil
  (if (symbol-value sensitive-mode)
      (progn
        ;; disable backups
        (set (make-local-variable 'backup-inhibited) t)	
        ;; disable auto-save
        (if auto-save-default
            (auto-save-mode -1)))
    ;; resort to default value of backup-inhibited
    (kill-local-variable 'backup-inhibited)
    ;;resort to default auto save setting
    (if auto-save-default
        (auto-save-mode 1))))

; set sensitive mode by default for *.gpg
(setq auto-mode-alist
      (append '(("\\.gpg$" . sensitive-mode))
              auto-mode-alist))

; tell epa to use gpg2 instead
(setq epg-gpg-program "gpg2")

;; Default browser
(setq browse-url-browser-function 'browse-url-default-macosx-browser)

;; start server if it's not running
(load "server")
(unless (server-running-p) (server-start))

(provide 'emacs)

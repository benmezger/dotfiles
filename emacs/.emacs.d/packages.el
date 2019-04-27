
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
    evil-magit
    helm
    helm-ls-git
    base16-theme
    rainbow-delimiters
    elpy
    pyenv-mode
    wakatime-mode
    evil
    editorconfig
    linum-relative
    flycheck
    org
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
  (which-key-mode))

;; startup
(load "~/.emacs.d/packages/base16.el")
(load "~/.emacs.d/packages/evil.el")
(load "~/.emacs.d/packages/editorconfig.el")
(load "~/.emacs.d/packages/helm.el")
(load "~/.emacs.d/packages/magit.el")
(load "~/.emacs.d/packages/rainbow_delimiter.el")
(load "~/.emacs.d/packages/linenum.el")

(load "~/.emacs.d/packages/python.el")
(load "~/.emacs.d/packages/wakatime.el")
(load "~/.emacs.d/packages/flycheck.el")
(load "~/.emacs.d/packages/orgmode.el")

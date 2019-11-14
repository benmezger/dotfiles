;; enable packages
(require 'cl)
(require 'package)

(setq package-enable-at-startup t)

;; fixes Emacs bug https://debbugs.gnu.org/cgi/bugreport.cgi?bug=34341
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; add package archive
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                          ("gnu" . "https://elpa.gnu.org/packages/")
                          ("org" . "http://orgmode.org/elpa/")))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; startup
(load "~/.emacs.d/packages/doom.el")
(load "~/.emacs.d/packages/evil.el")
(load "~/.emacs.d/packages/editorconfig.el")
(load "~/.emacs.d/packages/ivy.el")
(load "~/.emacs.d/packages/magit.el")
(load "~/.emacs.d/packages/rainbow_delimiter.el")

(load "~/.emacs.d/packages/python.el")
(load "~/.emacs.d/packages/wakatime.el")
(load "~/.emacs.d/packages/flycheck.el")
(load "~/.emacs.d/packages/orgmode.el")
(load "~/.emacs.d/packages/gitgutter.el")

(load "~/.emacs.d/packages/yasnippet.el")
(load "~/.emacs.d/packages/undotree.el")
(load "~/.emacs.d/packages/markdown.el")
(load "~/.emacs.d/packages/completion.el")
(load "~/.emacs.d/packages/yaml.el")

(if (eq system-type 'darwin)
  (load "~/.emacs.d/packages/execpath.el"))

(load "~/.emacs.d/packages/avy.el")
(load "~/.emacs.d/packages/icons.el")

(load "~/.emacs.d/packages/projectile.el")
(load "~/.emacs.d/packages/diminish.el")
(load "~/.emacs.d/packages/autoupdate.el")
(load "~/.emacs.d/packages/mouse.el")
(load "~/.emacs.d/packages/super_save.el")
(load "~/.emacs.d/packages/centaurtabs.el")
(load "~/.emacs.d/packages/whichkey.el")


;; PGP
(require 'epa-file)
(epa-file-enable)

;; include common
(require 'hooks)

;; doom related packages

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
    doom-themes-enable-italic t)
  (load-theme 'doom-molokai t))

(use-package doom-modeline
  :ensure t
  :defer .1
  :config
  (setq doom-modeline-height 20)
  (setq doom-modeline-buffer-file-name-style 'truncate-upto-project)

  (setq doom-modeline-icon t)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)

  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-buffer-modification-icon t)

  (setq doom-modeline-enable-word-count t)

  (setq doom-modeline-mu4e nil)
  (setq doom-modeline-irc nil)

  ;; Don’t compact font caches during GC.
  (setq inhibit-compacting-font-caches t)

  :hook (after-init . doom-modeline-mode))
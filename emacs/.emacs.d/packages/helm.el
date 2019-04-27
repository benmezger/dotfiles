;; helm mode
(use-package helm
  :bind (("M-a" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x f" . helm-recentf)
         ("M-y" . helm-show-kill-ring)
         ("C-x b" . helm-buffers-list))
  :bind (:map helm-map
              ("M-i" . helm-previous-line)
              ("M-k" . helm-next-line)
              ("M-I" . helm-previous-page)
              ("M-K" . helm-next-page)
              ("M-h" . helm-beginning-of-buffer)
              ("M-H" . helm-end-of-buffer))
  :ensure t
  :config (progn
            (setq helm-buffers-fuzzy-matching t)
            (setq helm-grep-ag-command "rg --color=always --colors 'match:fg:black' --colors 'match:bg:yellow' --smart-case --no-heading --line-number %s %s %s")
            (setq helm-grep-ag-pipe-cmd-switches '("--colors 'match:fg:black'" "--colors 'match:bg:yellow'"))
            (setq helm-recentf-fuzzy-match t)
            (setq helm-buffers-fuzzy-matching t)
            (setq helm-buffers-fuzzy-matching t)
            (setq helm-locate-fuzzy-match t)
            (setq helm-M-x-fuzzy-match t)
            (setq helm-semantic-fuzzy-match t)
            (setq helm-imenu-fuzzy-match t)
            (setq helm-apropos-fuzzy-match t)
            (setq helm-lisp-fuzzy-completion t)
            (setq helm-session-fuzzy-match t)
            (setq helm-etags-fuzzy-match t)
            (setq helm-mode-fuzzy-match t)
            (setq helm-completion-in-region-fuzzy-match t)
            (helm-autoresize-mode 1)
            (helm-mode 1)))

(use-package helm-ls-git
  :bind (("C-M-;"   . helm-ls-git-ls)
         ("C-x C-d" . helm-browse-project)))

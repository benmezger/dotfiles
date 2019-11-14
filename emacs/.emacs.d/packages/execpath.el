(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-copy-env "LANG")
  (exec-path-from-shell-copy-env "MAKEFLAGS")
  (exec-path-from-shell-initialize))

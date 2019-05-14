(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :ensure t
  :config
  (exec-path-from-shell-copy-env "LANG")
  (exec-path-from-shell-copy-env "MAKEFLAGS")
  (exec-path-from-shell-initialize))
;; exec-path-from-shell
(require 'exec-path-from-shell)

; (setq exec-path-from-shell-arguments '("-l"))

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GPG_AGENT_INFO"))

(provide 'setup-exec-path-from-shell)

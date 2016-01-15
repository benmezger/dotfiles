;; virtualenvwrapper.el

(require 'virtualenvwrapper)

(venv-initialize-interactive-shells) ;; interactive shell support
(venv-initialize-eshell) ;; eshell support
(setq venv-location "~/.virtualenvs")

(provide 'setup-virtualenvwrapper)

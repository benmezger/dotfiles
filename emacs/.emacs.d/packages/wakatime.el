(use-package wakatime-mode
  :ensure t
  :defer .1
  :custom (wakatime-cli-path "~/.pyenv/shims/wakatime")
  :config (global-wakatime-mode))

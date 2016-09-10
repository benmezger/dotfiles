;; ycmd configuration
(require 'ycmd)
(require 'company-ycmd)
(require 'flycheck-ycmd)

;; use in all supported modes
(add-hook 'after-init-hook #'global-ycmd-mode)

(set-variable 'ycmd-server-command '("python2"))
(add-to-list 'ycmd-server-command (expand-file-name "~/.vim/plugged/youcompleteme/third_party/ycmd/ycmd") t)
(set-variable 'ycmd-global-config "~/.ycm_extra_conf.py")

;; hide server messages
(set-variable 'ycmd-request-message-level' -1)

;; use company mode as completion framework
(company-ycmd-setup)
(add-hook 'after-init-hook 'global-company-mode)

;; bind company-select-next to tab
(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
     (define-key company-active-map [tab] 'company-complete-common-or-cycle)))
(setq company-selection t)
(setq company-idle-delay 0)

;; enable flycheck integration
(flycheck-ycmd-setup)

;; Make sure the flycheck cache sees the parse results
(add-hook 'ycmd-file-parse-result-hook 'flycheck-ycmd--cache-parse-results)

;; Add the ycmd checker to the list of available checkers
(add-to-list 'flycheck-checkers 'ycmd)

;; make flycheck and company work together
(when (not (display-graphic-p))
  (setq flycheck-indication-mode nil))

(provide 'setup-completion)

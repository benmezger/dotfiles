(use-package company
  :defer 2
  :diminish company-mode
  :config (global-company-mode t)

  (add-hook 'c-mode-hook
    (lambda () (local-set-key (kbd "<tab>") #'company-complete)
      (local-set-key (kbd "C-SPC") #'company-complete-selection))))

;; C
(use-package irony
  :defer 2
  :diminish irony-mode
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(use-package company-irony
  :defer 2
  :requires (company irony)
  :after (company-mode irony)
  :config
  '(add-to-list 'company-backends 'company-irony))

(use-package company-irony-c-headers
  :defer 2
  :requires (company company-irony irony)
  :config
  (eval-after-load 'company
    '(add-to-list
       'company-backends '(company-irony-c-headers company-irony))))

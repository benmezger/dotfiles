(use-package company
  :defer 2
  :ensure t
  :diminish company-mode
  :config (global-company-mode t)

  (add-hook 'c-mode-hook
    (lambda () (local-set-key (kbd "<tab>") #'company-complete)
      (local-set-key (kbd "C-SPC") #'company-complete-selection))))

(use-package company-c-headers
  :ensure t)

(use-package company-irony
  :defer 2
  :ensure t
  :requires (company irony)
  :after (company-mode irony)
  :config
  '(add-to-list 'company-backends 'company-irony))

(use-package company-irony-c-headers
  :defer 2
  :ensure t
  :requires (company company-irony irony)
  :config
  (eval-after-load 'company
    '(add-to-list
       'company-backends '(company-irony-c-headers company-irony))))

;; C
(use-package irony
  :defer 2
  :diminish irony-mode
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(use-package clang-format
  :ensure t)

(use-package company-tabnine
  :ensure t
  :defer 2
  :requires (company)
  :config
  (require 'company-tabnine)
  ;; Trigger completion immediately.
  (setq company-idle-delay 0)

  ;; Number the candidates (use M-1, M-2 etc to select completions).
  (setq company-show-numbers t)
  (eval-after-load 'company
    '(add-to-list
       'company-backends '(company-irony-c-headers company-irony company-tabnine))))

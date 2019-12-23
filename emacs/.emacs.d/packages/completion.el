(use-package eglot
  :after (exec-path-from-shell)
  :ensure t
  :hook ((python-mode . eglot-ensure)
          (c-mode . eglot-ensure)
          (go-mode . eglot-ensure)))

;; (use-package lsp-mode
;;   :hook (python-mode . lsp-deferred)
;;   :hook (c-mode . lsp-deferred)
;;   :commands (lsp lsp-deferred))
;;
;;   ;; :config
;;   ;; (lsp-register-client
;;   ;;   (make-lsp-client :new-connection (lsp-stdio-connection "pyls")
;;   ;;     :major-modes '(python-mode)
;;   ;;     :server-id 'pyls)))

;; lsp extras
;; (use-package lsp-ui
;;   :ensure t
;;   :after (eglot)
;;   :commands lsp-ui-mode
;;   :config
;;   (setq lsp-ui-sideline-ignore-duplicate t))
;;   ;; (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package company
  :ensure t
  :bind (("<tab>" . company-indent-or-complete-common)
          ("C-SPC" . company-complete-selection))
  :diminish company-mode
  :config
  (setq company-selection-wrap-around t)
  (setq company-minimum-prefix-length 1)
  ;;(company-tng-configure-default)
  (setq company-idle-delay 0)
  (global-company-mode t))

  ;;(add-hook 'c-mode-hook
  ;;  (lambda () (local-set-key (kbd "<tab>") #'company-complete)
  ;;    (local-set-key (kbd "C-SPC") #'company-complete-selection)))

  ;;(add-hook 'python-mode-hook
  ;;  (lambda () (local-set-key (kbd "<tab>") #'company-complete)
  ;;    (local-set-key (kbd "C-SPC") #'company-complete-selection))))

(use-package company-lsp
  :ensure t
  :after (lsp-mode)
  :diminish company-lsp
  :config
  (push 'company-lsp company-backends)
  (setq company-lsp-async t)
  (setq company-lsp-cache-candidates t)
  (setq company-lsp-enable-recompletion t))
  ;; :config
  ;; (require 'company-lsp)
  ;; (push 'company-lsp company-backends)
  ;; (setq company-transformers nil
  ;;       company-lsp-async t
  ;;       company-lsp-cache-candidates nil))

;; (use-package company-c-headers
;;   :ensure t)
;;
;; (use-package ccls
;;   :preface
;;   (setq ccls-executable "/usr/local/bin/ccls"))
;;   :diminish t
;;   :hook ((c-mode c++-mode objc-mode cuda-mode) .
;;           (lambda () (require 'ccls) (lsp)))

;;
;; (use-package company-irony
;;   :defer 2
;;   :ensure t
;;   :requires (company irony)
;;   :after (company-mode irony)
;;   :config
;;   '(add-to-list 'company-backends 'company-irony))
;;
;; (use-package company-irony-c-headers
;;   :defer 2
;;   :ensure t
;;   :requires (company company-irony irony)
;;   :config
;;   (eval-after-load 'company
;;     '(add-to-list
;;        'company-backends '(company-irony-c-headers company-irony))))
;;
;; ;; C
;; (use-package irony
;;   :defer 2
;;   :diminish irony-mode
;;   :ensure t
;;   :config
;;   (add-hook 'c++-mode-hook 'irony-mode)
;;   (add-hook 'c-mode-hook 'irony-mode)
;;   (add-hook 'objc-mode-hook 'irony-mode)
;;   (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))
;;
(use-package clang-format
  :ensure t)
;;
;; (use-package company-tabnine
;;   :ensure t
;;   :defer 2
;;   :requires (company)
;;   :config
;;   (require 'company-tabnine)
;;   ;; Trigger completion immediately.
;;   (setq company-idle-delay 0)
;;
;;   ;; Number the candidates (use M-1, M-2 etc to select completions).
;;   (setq company-show-numbers t)
;;   (eval-after-load 'company
;;     '(add-to-list
;;        'company-backends '(company-irony-c-headers company-irony company-tabnine))))

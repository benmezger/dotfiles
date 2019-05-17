(use-package counsel
  :ensure t
  :init
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; enable this if you want `swiper' to use it
  (setq search-default-mode #'char-fold-to-regexp)
  (setq ivy-use-virtual-buffers t
    ivy-count-format "%d/%d ")

  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)

  (define-key ivy-minibuffer-map (kbd "C-j") #'ivy-immediate-done)
  (define-key ivy-minibuffer-map (kbd "RET") #'ivy-alt-done)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

  (recentf-mode 1)
  (defun eh-ivy-return-recentf-index (dir)
    (when (and (boundp 'recentf-list)
            recentf-list)
      (let ((files-list
              (cl-subseq recentf-list
                0 (min (- (length recentf-list) 1) 20)))
             (index 0))
        (while files-list
          (if (string-match-p dir (car files-list))
            (setq files-list nil)
            (setq index (+ index 1))
            (setq files-list (cdr files-list))))
        index)))

  (defun eh-ivy-sort-file-function (x y)
    (let* ((x (concat ivy--directory x))
            (y (concat ivy--directory y))
            (x-mtime (nth 5 (file-attributes x)))
            (y-mtime (nth 5 (file-attributes y))))
      (if (file-directory-p x)
        (if (file-directory-p y)
          (let ((x-recentf-index (eh-ivy-return-recentf-index x))
                 (y-recentf-index (eh-ivy-return-recentf-index y)))
            (if (and x-recentf-index y-recentf-index)
              ;; Directories is sorted by `recentf-list' index
              (< x-recentf-index y-recentf-index)
              (string< x y)))
          t)
        (if (file-directory-p y)
          nil
          ;; Files is sorted by mtime
          (time-less-p y-mtime x-mtime)))))

  (add-to-list 'ivy-sort-functions-alist
    '(read-file-name-internal . eh-ivy-sort-file-function)))

(use-package counsel-projectile
  :ensure t
  :init
  (counsel-projectile-mode))

(use-package counsel-etags
  :ensure t)

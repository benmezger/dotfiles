;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ben Mezger"
      user-mail-address "me@benmezger.nl")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "InconsolataDZ" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-vibrant)

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)

(display-time-mode 1)
(display-battery-mode 1)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
;;

(after! lsp-mode
  :config
  (setq lsp-response-timeout 90000))

(after! company-lsp
  :config
  (push 'company-lsp company-backends)
  (setq company-lsp-async t)
  (setq company-lsp-cache-candidates t)
  (setq company-lsp-enable-recompletion t))

(after! company
  :config
  (setq company-selection-wrap-around t)
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0))

(after! doom-modeline
  :config
  (setq doom-modeline-height 20)
  (setq doom-modeline-buffer-file-name-style 'truncate-upto-project)

  (setq doom-modeline-icon (display-graphic-p))
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)

  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-buffer-modification-icon t)

  (setq doom-modeline-enable-word-count t)
  (setq doom-modeline-buffer-encoding t)
  (setq doom-modeline-indent-info t)

  (setq doom-modeline-mu4e nil)
  (setq doom-modeline-irc nil)

  (setq doom-modeline-env-version t)
  (setq doom-modeline-env-load-string "...")

  (custom-set-faces
    '(mode-line ((t (:height 1))))
    '(mode-line-inactive ((t (:height 1)))))

  ;; Don’t compact font caches during GC.
  (setq inhibit-compacting-font-caches t))

(after! flycheck
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enable)))

(after! ivy
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)

  ;; enable this if you want `swiper' to use it
  (setq search-default-mode #'char-fold-to-regexp)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
           (counsel-rg . ivy--regex-plus)
          (t      . ivy--regex-fuzzy)))

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


(after! org
  :config
  (setq org-log-done 'time)
  (setq org-clock-persist 'history)
  (setq org-directory "~/workspace/org")
  (setq org-archive-location "archives/%s_archive::")
  (setq org-agenda-files (list org-directory org-roam-directory))
  (org-clock-persistence-insinuate)
  (setq-default org-catch-invisible-edits 'smart)
  (setq org-log-into-drawer t)
  (setq org-agenda-inhibit-startup t)
  (auto-fill-mode t)

  (setq org-todo-keywords
    '((sequence "TODO(t)" "CURRENT(u)" "WAIT(w@/!)" "NEXT(n)" "PROJ(o!)" "|")
       (sequence "READING(r!)" "HOLD(h@/!)" "|" "READ(e@/!)")
       (sequence "|" "DONE(d!)" "CANCELED(c!)"))
    org-todo-keyword-faces
    '(("CURRENT"  . "orange")
       ("TODO" . "systemRedColor")
       ("READING" . "systemOrangeColor")
       ("HOLD"  . "indianRed")
       ("WAIT" . "salmon1")
       ("PROJ" . "systemYellowColor")))

  (setq org-capture-templates
    '(
       ("b" "Book note" entry (file+olp+datetree "~/workspace/org/notes.org" "Books" "Notes")
         (file "~/workspace/org/templates/book-note.capture"))
       ("n" "Note" entry (file+olp+datetree "~/workspace/org/notes.org" "Inbox")
         "* %?\nEntered on %U\n  %i\n  %a")
       ("t" "Todo" entry (file+olp+datetree "~/workspace/org/notes.org" "Inbox" "Tasks")
         "* TODO %?\n  %i\n  %a")
       ("r" "Register new book" entry (file+olp "~/workspace/org/notes.org" "Books" "List")
         (file "~/workspace/org/templates/new-book.capture"))
       ))

  (setq ob-async-no-async-languages-alist '("gnuplot" "mermaid")))

(after! org-roam
  :defer t
  (setq org-roam-directory "~/workspace/org/roam")
  (setq org-roam-index-file (concat org-roam-directory "/" "index.org"))

  (setq org-roam-capture-templates
    '(("d" "default" plain (function org-roam-capture--get-point)
        "%?"
        :file-name "%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}\" (current-time) t)"
        :head "#+TITLE: ${title}
#+DATE: %T
#+FILETAGS: %^G
#+SETUPFILE: %(concat (file-name-as-directory org-directory) \"hugo.setup\")
#+HUGO_SLUG: ${slug}

- tags :: "
        :unnarrowed t)
       ("p" "private" plain (function org-roam-capture--get-point)
         "%?"
         :file-name "private/%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}\" (current-time) t)"
         :head "#+TITLE: ${title}
#+DATE: %T
#+FILETAGS: :personal:%^G
#+SETUPFILE: %(concat (file-name-as-directory org-directory) \"hugo.setup\")
#+HUGO_SLUG: ${slug}"
         :unnarrowed t)))

  (setq org-roam-ref-capture-templates
    '(("r" "ref" plain (function org-roam-capture--get-point)
        "%?"
        :file-name "%(format-time-string \"%Y-%m-%d--%H-%M-%SZ--${slug}\" (current-time) t)"
        :head "#+TITLE: ${title}
#+DATE: %T
#+FILETAGS: %^G
#+SETUPFILE: %(concat (file-name-as-directory org-directory) \"hugo.setup\")
#+ROAM_KEY: ${ref}
#+ROAM_TAGS: website
#+HUGO_SLUG: ${slug}

- tags ::
- source :: ${ref}"
        :unnarrowed t)))

  (defun custom-org-protocol-focus-advice (orig &rest args)
    (x-focus-frame nil)
    (apply orig args))

  (advice-add 'org-roam-protocol-open-ref :around
    #'custom-org-protocol-focus-advice)
  (advice-add 'org-roam-protocol-open-file :around
    #'custom-org-protocol-focus-advice))

(after! (org org-roam)
  :defer t
  (defun benmezger/org-roam-export-all ()
  "Re-exports all Org-roam files to Hugo markdown."
  (interactive)
  (dolist (f (org-roam--list-all-files))
    (with-current-buffer (find-file f)
      (when (s-contains? "SETUPFILE" (buffer-string))
        (org-hugo-export-wim-to-md)))))

  (defun benmezger/org-roam--backlinks-list (file)
    (when (org-roam--org-roam-file-p file)
      (mapcar #'car (org-roam-db-query
                      [:select :distinct [from]
                        :from links
                        :where (= to $s1)
                        :and from :not :like $s2] file "%private%"))))

  (defun benmezger/org-export-preprocessor (_backend)
    (when-let ((links (benmezger/org-roam--backlinks-list (buffer-file-name))))
      (insert "\n** Backlinks\n")
      (dolist (link links)
        (insert (format "- [[file:%s][%s]]\n"
                  (file-relative-name link org-roam-directory)
                  (org-roam--get-title-or-slug link))))))

  (add-hook 'org-export-before-processing-hook #'benmezger/org-export-preprocessor))

(after! (org ox-hugo)
  :defer t
  (defun benmezger/conditional-hugo-enable ()
    (save-excursion
      (if (cdr (assoc "SETUPFILE" (org-roam--extract-global-props '("SETUPFILE"))))
        (org-hugo-auto-export-mode +1)
        (org-hugo-auto-export-mode -1))))
  (add-hook 'org-mode-hook #'benmezger/conditional-hugo-enable))

(use-package! org-roam-server
  :defer t)

(use-package! org-projectile
  :after projectile
  :config
    (map! :leader
      (:prefix "n"
        :desc "Add a TODO to project" "p" #'org-projectile-project-todo-completing-read))

  (org-projectile-per-project)
  (defun org-projectile-get-project-todo-file (project-path)
    (concat org-directory "/projects/" (file-name-nondirectory (directory-file-name project-path)) ".org"))
 
  (push (org-projectile-project-todo-entry) org-capture-templates)
  (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files))))


(after! deft
  :defer t
  :config
  (setq deft-directory org-directory)
  (setq deft-extensions '("org" "md" "txt"))
  (setq deft-default-extension "org")
  (setq deft-recursive t)
  (setq deft-use-filename-as-title nil)
  (setq deft-use-filter-string-for-filename t)
  (setq deft-file-naming-rules '((nospace . "-"))))

(after! doom-modeline
  :config
  (setq doom-modeline-continuous-word-count-modes
    '(markdown-mode gfm-mod)))

(use-package! wakatime-mode
  :init
  (setq wakatime-cli-path "~/.pyenv/shims/wakatime")
  :config
  (global-wakatime-mode))

(use-package! py-isort
  :defer t
  :init
  (add-hook 'before-save-hook 'py-isort-before-save))

(after! elfeed-org
  :defer t
  :init
  (setq rmh-elfeed-org-files (list "~/workspace/org/urls.org")))

(after! ob-mermaid
  :defer t
  :init
  (setq ob-mermaid-cli-path "/usr/local/bin/mmdc"))

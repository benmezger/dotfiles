;;; chezmoi.el --- Handle chezmoi configuration -*- lexical-binding: t -*-
;;
;;; Author: Ben Mezger
;; https://github.com/benmezger
;;
;;; Commentary:
;; Work in progress.
;;
;;; Code:

(require 'ivy)

(defvar chezmoi-bin "chezmoi"
  "Path to chezmoi's binary.")

(defvar chezmoi-buffer "*chezmoi*"
  "Path to chezmoi's binary.")

(defvar chezmoi-flags "--color false -v --force -i noscripts"
  "Flags to pass to chezmoi in every run.")

(defun chezmoi-apply()
  "Run chezmoi apply without running scripts."
  (interactive)
  (apply 'start-process
         "chezmoi" chezmoi-buffer
         chezmoi-bin "apply" (split-string chezmoi-flags " "))
  (with-current-buffer chezmoi-buffer
    (diff-mode)))

(defun chezmoi-diff()
  "Run chezmoi diff."
  (interactive)
  (message "Running chezmoi diff...")
  (apply 'start-process
         "chezmoi" chezmoi-buffer
         chezmoi-bin "diff" (split-string chezmoi-flags " "))
  (with-current-buffer chezmoi-buffer
    (diff-mode)
    (read-only-mode)))

(defun chezmoi-edit()
  "Edit a chezmoi file."
  (interactive)
  (ivy-read "File: "
            (process-lines chezmoi-bin "managed")
            :require-match t
            :action
            (lambda (n)
              (find-file
               (nth 0 (process-lines
                       chezmoi-bin "source-path"
                       (expand-file-name (concat "~/" n))))))))

(define-minor-mode chezmoi-mode
  "Enable chezmoi functionality."
  :lighter " chezmoi"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c A") 'chezmoi-apply)
            (define-key map (kbd "C-c E") 'chezmoi-edit)
            (define-key map (kbd "C-c D") 'chezmoi-diff)
            map))

(provide 'chezmoi)

;;; chezmoi.el ends here

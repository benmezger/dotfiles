(require 'notmuch)

;; from: https://www.reddit.com/r/emacs/comments/esxjh5/my_notmuch_email_count_display_in_modeline/
;; with a few modifications

(defvar notmuch-unread-mode-line-string "")
(defvar notmuch-unread-tag "tag:unread and tag:me")

(defvar notmuch-unread-email-count nil)
(defconst my-mode-line-map (make-sparse-keymap))

(defun notmuch-unread-count ()
  (setq notmuch-unread-email-count
        (string-to-number
         (replace-regexp-in-string
          "\n" "" (notmuch-command-to-string
                   "count" notmuch-unread-tag))))

  (if (eq notmuch-unread-email-count 0)
      (setq notmuch-unread-mode-line-string
            (format
             "  %d"
             (string-to-number
              (replace-regexp-in-string
               "\n" ""
               (notmuch-command-to-string "count" notmuch-unread-tag)))))
    (setq notmuch-unread-mode-line-string (format "  %d" notmuch-unread-email-count)))
  (force-mode-line-update))

(run-at-time nil 10 'notmuch-unread-count)

(defun notmuch-open-emails ()
  (interactive)
  (notmuch-search notmuch-unread-tag))

(setq global-mode-string
      (append global-mode-string
              (list '(:eval
                      (propertize notmuch-unread-mode-line-string
                                  'help-echo "notmuch emails"
                                  'mouse-face 'mode-line-highlight
                                  'local-map my-mode-line-map)))))

(define-key my-mode-line-map
  (vconcat [mode-line down-mouse-1])
  (cons "hello" 'notmuch-open-emails))

(provide 'notmuch-unread)
;;; notmuch-unread.el ends here

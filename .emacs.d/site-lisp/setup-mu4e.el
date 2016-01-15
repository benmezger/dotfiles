;; Mu4e

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")

(require 'smtpmail)
(require 'mu4e)

;; default
(setq mu4e-maildir "~/.maildir")
(setq smtpmail-queue-mail t  ;; start in queuing mode)
      smtpmail-queue-dir   "~/.maildir/queue/cur")

(setq
 ;; general
 mu4e-get-mail-command "offlineimap"
 mu4e-update-interval 300
 
 ;; smtp
 message-send-mail-function 'smtpmail-send-it
 smtpmail-stream-type 'starttls
 
 ;; attachment dir
 mu4e-attachment-dir  "~/Documents/"
 ;; insert sign
 mu4e-compose-signature-auto-include 't)

(setq mu4e-html2text-command "w3m -T text/html")

;; overwrite mu4e's autoload function and load secrets.
(defun mu4e (&optional background)
  "If mu4e is not running yet, start it. Then, show the the main
window, unless BACKGROUND (prefix-argument) is non-nil."
  (require 'secrets)
  (interactive "P")
  ;; start mu4e, then show the main view
  (mu4e~start (unless background 'mu4e~main-view)))

(defun my-mu4e-set-account ()
  "Set the account for composing a message."
  (let* ((account
          (if mu4e-compose-parent-message
              (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
                (string-match "/\\(.*?\\)/" maildir)
                (match-string 1 maildir))
            (completing-read (format "Compose with account: (%s) "
                                     (mapconcat #'(lambda (var) (car var))
                                                my-mu4e-account-alist "/"))
                             (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
                             nil t nil nil (caar my-mu4e-account-alist))))
         (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
        (mapc #'(lambda (var)
                  (set (car var) (cadr var)))
              account-vars)
      (error "No email account found"))))

(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

;;(define-key 'mu4e-main-mode-map "C" 'mu4e-multi-compose-new)
;;(define-key 'mu4e-headers-mode-map "C" 'mu4e-multi-compose-new)
;;(define-key 'mu4e-view-mode-map "C" 'mu4e-multi-compose-new)

;; don't save message to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; PGP-Sign all e-mails
(add-hook 'message-send-hook 'mml-secure-message-sign-pgpmime)

;; Some messages are unreadable in Emacs, view those messages in the browser
(add-to-list 'mu4e-view-actions '("ViewInBrowser" . mu4e-action-view-in-browser) t)

(provide 'setup-mu4e)

;; jabber setup

(require 'netrc)
(require 'jabber)

(defun jabber-benmezger(&optional arg)
  (setq cred (netrc-machine (netrc-parse "~/.authinfo.gpg") "jabber" t))
  
  (setq jabber-account-list
        `((,(netrc-get cred "login")
           (:password . ,(netrc-get cred "password"))
           (:network-server . "talk.google.com")
           (:connection-type . ssl)
           (:port . 443))))
  
  (setq jabber-vcard-avatars-retrieve nil
        jabber-chat-buffer-show-avatar nil)
  
  (add-hook 'jabber-chat-mode-hook 'goto-address)
  (interactive)
  (jabber-connect-all)
  (switch-to-buffer "*-jabber-roster-*"))

(provide 'setup-jabber)

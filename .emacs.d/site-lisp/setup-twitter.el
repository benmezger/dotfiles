;; twittering mode

;; use gpg
(setq twittering-use-master-password t)

;; display icons
(setq twittering-icon-mode t)

;; retrive 20 tweets
(setq twittering-number-of-tweets-on-retrieval 20)

;; display unread tweets on the mode-line
(setq twittering-enable-unread-status-notifier)

;; display remaining number of API calls
;; (setq twittering-display-remaining t)

(provide 'setup-twitter)

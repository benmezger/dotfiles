;; disable touchpad when on emacs
 
(defun turn-off-mouse (&optional frame)
  (interactive)
  (call-process-shell-command "xinput --disable bcm5974"
                              nil "*Shell command output*" t))

(defun turn-on-mouse (&optional frame)
  (interactive)
  (call-process-shell-command "xinput --enable bcm5974"
                              nil "*Shell command output*" t))

(add-hook 'focus-in-hook #'turn-off-mouse)
(add-hook 'focus-out-hook #'turn-on-mouse)
(add-hook 'delete-frame-functions #'turn-on-mouse)

(add-hook 'kill-emacs-hook #'turn-on-mouse)

(provide 'setup-xinput)

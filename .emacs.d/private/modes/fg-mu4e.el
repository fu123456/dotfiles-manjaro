(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(require 'mu4e)

;; default
(setq mu4e-maildir "~/Maildir")
(setq mu4e-drafts-folder "/[yahoo].Drafts")
(setq mu4e-sent-folder   "/[yahoo].Sent Mail")
(setq mu4e-trash-folder  "/[yahoo].Trash")


(setq mu4e-maildir-shortcuts
      '( ("/INBOX"               . ?i)
         ("/[yahoo].Sent Mail"   . ?s)
         ("/[yahoo].Trash"       . ?t)
         ("/[yahoo].All Mail"    . ?a)))

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "offlineimap")

;; something about ourselves
(setq
 user-mail-address "xyzgfu@yahoo.com"
 user-full-name  "Gang Fu"
 mu4e-compose-signature
 (concat
  "Gang Fu\n"))

(require 'smtpmail)
(require 'starttls)
(setq send-mail-function 'smtpmail-send-it
      smtpmail-stream-type 'starttls
      smtpmail-default-smtp-server "smtp.mail.yahoo.com"
      smtpmail-smtp-server "smtp.mail.yahoo.com"
      smtpmail-smtp-service 587         ;587
      smtpmail-local-domain "homepc"
      smtpmail-auth-credentials "~/.authinfo")
(setq mu4e-update-interval 60)
(setq mu4e-view-show-images t)

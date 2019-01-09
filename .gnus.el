(require 'nnir)

;; @see http://www.emacswiki.org/emacs/GnusGmail#toc1
(setq gnus-select-method '(nntp "news.gmane.org")) ;; if you read news groups

;; ask encryption password once
(setq epa-file-cache-passphrase-for-symmetric-encryption t)

;; ;; @see http://gnus.org/manual/gnus_397.html
;; (add-to-list 'gnus-secondary-select-methods
;;              '(nnimap "yahoo mail"
;;                       (nnimap-address "imap.mail.yahoo.com")
;;                       (nnimap-server-port 993)
;;                       (nnimap-stream ssl)
;;                       (nnir-search-engine pop)
;;                       ; @see http://www.gnu.org/software/emacs/manual/html_node/gnus/Expiring-Mail.html
;;                       ;; press 'E' to expire email
;;                       (nnmail-expiry-target "nnimap+yahoo mail:[Gmail]/Trash")
;;                       (nnmail-expiry-wait 90)))

;; OPTIONAL, the setup for Microsoft Hotmail
(add-to-list 'gnus-secondary-select-methods
             '(nnimap "hotmail"
                      (nnimap-address "imap-mail.outlook.com")  ;; imap-mail.outlook.com
                      (nnimap-server-port 993) ;; 993
                      (nnimap-stream ssl)
                      (nnir-search-engine imap)
                      (nnmail-expiry-wait 90)))

(setq gnus-thread-sort-functions
      '(gnus-thread-sort-by-most-recent-date
        (not gnus-thread-sort-by-number)))

; NO 'passive
(setq gnus-use-cache t)

;; ;; BBDB: Address list
;; (add-to-list 'load-path "/where/you/place/bbdb/")
;; (require 'bbdb)
;; (bbdb-initialize 'message 'gnus 'sendmail)
;; (add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
;; (setq bbdb/mail-auto-create-p t
;;       bbdb/news-auto-create-p t)

;; auto-complete emacs address using bbdb UI
(add-hook 'message-mode-hook
          '(lambda ()
             (flyspell-mode t)
             (local-set-key (kbd "TAB") 'bbdb-complete-name)))

;; Fetch only part of the article if we can.
;; I saw this in someone's .gnus
(setq gnus-read-active-file 'some)

;; open attachment
(eval-after-load 'mailcap
  '(progn
     (cond
      ;; on OSX, maybe change mailcap-mime-data?
      ((eq system-type 'darwin))
      ;; on Windows, maybe change mailcap-mime-data?
      ((eq system-type 'windows-nt))
      (t
       ;; Linux, read ~/.mailcap
       (mailcap-parse-mailcaps)))))

;; Tree view for groups.
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

;; Threads!  I hate reading un-threaded email -- especially mailing
;; lists.  This helps a ton!
(setq gnus-summary-thread-gathering-function 'gnus-gather-threads-by-subject)

;; Also, I prefer to see only the top level message.  If a message has
;; several replies or is part of a thread, only show the first message.
;; `gnus-thread-ignore-subject' will ignore the subject and
;; look at 'In-Reply-To:' and 'References:' headers.
(setq gnus-thread-hide-subtree t)
(setq gnus-thread-ignore-subject t)

;; Personal Information
(setq user-full-name "fugang"
      user-mail-address "xyzgfu@outlook.com")

;; Read HTML mail:
;; You need install the command line web browser 'w3m' and Emacs plugin 'w3m'
;; manually. It specify the html render as w3m so my setup works on all versions
;; of Emacs.
;;
;; Since Emacs 24+, a default html rendering engine `shr' is provided:
;;   - It works out of box without any cli program dependency or setup
;;   - It can render html color
;; So below line is optional.
(setq mm-text-html-renderer 'w3m) ; OPTIONAL

;; Send email through SMTP
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-default-smtp-server "smtp-mail.outlook.com" ;;smtp-mail.outlook.com
      smtpmail-smtp-service 587  ;; 587
      smtpmail-local-domain "homepc")
;; http://www.gnu.org/software/emacs/manual/html_node/gnus/_005b9_002e2_005d.html
(setq gnus-use-correct-string-widths nil)

;; Sample on how to organize mail folders.
;; It's dependent on `gnus-topic-mode'.
(eval-after-load 'gnus-topic
  '(progn
     (setq gnus-message-archive-group '((format-time-string "sent.%Y")))
     (setq gnus-server-alist '(("archive" nnfolder "archive" (nnfolder-directory "~/Mail/archive")
                                (nnfolder-active-file "~/Mail/archive/active")
                                (nnfolder-get-new-mail nil)
                                (nnfolder-inhibit-expiry t))))

     ;; "Gnus" is the root folder, and there are three mail accounts, "misc", "hotmail", "gmail"
     (setq gnus-topic-topology '(("Gnus" visible)
                                 (("misc" visible))
                                 (("hotmail" visible nil nil))
                                 (("gmail" visible nil nil))))

     ;; each topic corresponds to a public imap folder
     (setq gnus-topic-alist '(
                              ("hotmail" ; the key of topic
                               "nnimap+hotmail:Inbox"
                               "nnimap+hotmail:Drafts"
                               "nnimap+hotmail:Sent"
                               "nnimap+hotmail:Junk"
                               "nnimap+hotmail:Deleted")
                              ("gmail" ; the key of topic
                               "INBOX"
                               "[Gmail]/Sent Mail"
                               "[Gmail]/Trash"
                               "Sent Messages"
                               "Drafts")
                              ("misc" ; the key of topic
                               "nnfolder+archive:sent.2015-12"
                               "nnfolder+archive:sent.2016"
                               "nnfolder+archive:sent.2017"
                               "nndraft:drafts")
                              ("Gnus")))))

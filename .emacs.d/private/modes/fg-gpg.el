;; {{{ gnupg
;; to see @https://truongtx.me/2013/03/02/password-management-with-emacs
(when (file-executable-p "/usr/local/bin/gpg2")
	(setq epg-gpg-program "/usr/local/bin/gpg2"))
;; }}}

;; Note
;; Always use symmetric encryption
;; To prevent EPG from prompting for a key every time you save a file, put the following at the top of your file:

;; -*- epa-file-encrypt-to: ("your@email.address") -*-
;; EPA will prompt for the key only the first time you save the file, assuming you have the email address you specified in your keyring.

(require 'tramp)
(defun remote-fugang ()
  (interactive)
  (dired "/ssh:fugang@202.114.96.180:/home/fugang/"))

(add-to-list 'backup-directory-alist
             (cons tramp-file-name-regexp nil))
;; (setq tramp-chunksize 8192)
(setq tramp-chunksize 2000)

;; @see https://github.com/syl20bnr/spacemacs/issues/1921
;; If you tramp is hanging, you can uncomment below line.
(setq tramp-ssh-controlmaster-options "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no")

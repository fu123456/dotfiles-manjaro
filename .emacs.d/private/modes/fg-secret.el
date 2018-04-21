;;Encryption-------------------------------
;;Setup for transparent, automatic encryption and decryption:
;;(does naught... ?)
(when (require 'epa-file nil 'noerror)
  (epa-file-enable)

  ;; t      to always ask for user
  ;; nil    to ask for users unless specified
  ;;'silent to use symmetric encryption:
  (setq epa-file-select-key 'silent)

  ;;Note: if you have an instance of seahorse running, then the environment
  ;;variable GPG_AGENT_INFO=/tmp/seahorse-nDQm50/S.gpg-agent:6321:1, which
  ;;causes emacs to start a GUI for password, instead of using mini-buffer.

  (setenv "GPG_AGENT_INFO" nil)
  ;; Note: another form is:
  ;;(setenv (concat "GPG_AGENT_INFO" nil))
  )
;;---------------------------------------------
;;Turn off backup for gpg-files ---------------
(define-minor-mode sensitive-mode
  "For sensitive files like password lists. It disables backup
creation and auto saving.

With no argument, this command toggles the mode. Non-null prefix
argument turns on the mode. Null prefix argument turns off the
mode."
  ;; The initial value.
  nil
  ;; The indicator for the mode line.
  " Sensitive"
  ;; The minor mode bindings.
  nil
  (if (symbol-value sensitive-mode)
      (progn
        ;; disable backups
        (set (make-local-variable 'backup-inhibited) t)
        ;; disable auto-save
        (if auto-save-default
            (auto-save-mode -1)))
    ;; resort to default value of backup-inhibited
    (kill-local-variable 'backup-inhibited)
    ;;resort to default auto save setting
    (if auto-save-default
        (auto-save-mode 1))))

(setq auto-mode-alist
      (append '(("\\.gpg$" . sensitive-mode))
              auto-mode-alist))

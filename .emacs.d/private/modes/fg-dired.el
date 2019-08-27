;;; code
(define-key dired-mode-map [tab] 'dired-subtree-toggle)
(define-key dired-mode-map [backtab] 'dired-subtree-cycle)

;; load other useful packages
(add-to-list 'load-path "~/.emacs.d/private/OtherUsefulElFiles")

;; {{{ Start a process from dired
;; please refer to  https://oremacs.com/2015/01/04/dired-nohup/
;; Ignore running processes when closing Emacs
(define-advice save-buffers-kill-emacs (:around (orig-fun &rest r) no-query-kill-emacs)
  (cl-letf (((symbol-function 'process-list) 'ignore))
    (apply orig-fun r)))

;; Guess programs by file extension
(require 'dired-x)
(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "zathura" "evince" "okular" "mupdf")
        ("\\.\\(?:djvu\\|eps\\)\\'" "evince")
        ("\\.\\(?:jpg\\|jpeg\\|png\\|gif\\|xpm\\)\\'" "eog")
        ("\\.\\(?:xcf\\)\\'" "gimp")
        ("\\.csv\\'" "libreoffice")
        ("\\.tex\\'" "pdflatex" "latex")
        ("\\.\\(?:mp4\\|mkv\\|avi\\|flv\\|ogv\\)\\(?:\\.part\\)?\\'"
         "smplayer")
        ("\\.\\(?:mp3\\|flac\\)\\'" "rhythmbox")
        ("\\.html?\\'" "firefox")
        ("\\.cue?\\'" "audacious")))

;; Add nohup
;; processes started by Emacs can continue running even when Emacs is closed.
(require 'dired-aux)

(defvar dired-filelist-cmd
  '(("vlc" "-L")))

(defun dired-start-process (cmd &optional file-list)
  (interactive
   (let ((files (dired-get-marked-files
                 t current-prefix-arg)))
     (list
      (dired-read-shell-command "& on %s: "
                                current-prefix-arg files)
      files)))
  (let (list-switch)
    (start-process
     cmd nil shell-file-name
     shell-command-switch
     (format
      "nohup 1>/dev/null 2>/dev/null %s \"%s\""
      (if (and (> (length file-list) 1)
               (setq list-switch
                     (cadr (assoc cmd dired-filelist-cmd))))
          (format "%s %s" cmd list-switch)
        cmd)
      (mapconcat #'expand-file-name file-list "\" \"")))))
(define-key dired-mode-map (kbd "C-!") 'dired-start-process)
;; }}}

;; Other setting
;; https://www.reddit.com/r/emacs/comments/4agkye/how_do_you_customize_dired/

;; work like two-panelled file manager if two dired buffers opened. Very cool!
(setq dired-dwim-target t)

;;----------------------------------------
;;Open file by C-return in external application
(defun ergoemacs-open-in-external-app ()
  "Open the current file or dired marked files in external app."
  (interactive)
  (let ( doIt
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           (t (list (buffer-file-name))) ) ) )

    (setq doIt (if (<= (length myFileList) 5)
                   t
                 (y-or-n-p "Open more than 5 files?") ) )

    (when doIt
      (cond
       ((string-equal system-type "windows-nt")
        (mapc (lambda (fPath) (w32-shell-execute "open" (replace-regexp-in-string "/" "\\" fPath t t)) ) myFileList)
        )
       ((string-equal system-type "darwin")
        (mapc (lambda (fPath) (shell-command (format "open \"%s\"" fPath)) )  myFileList) )
       ((string-equal system-type "gnu/linux")
        (mapc (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "xdg-open" fPath)) ) myFileList) ) ) ) ) )

(define-key dired-mode-map (kbd "<C-return>") 'ergoemacs-open-in-external-app)

;;----------------------------------------
;;Sort settings
(require 'dired-sort-menu+)
(add-hook 'dired-load-hook
          (lambda () (require 'dired-sort-menu)))

(if (eq system-type 'windows-nt) ;OR gnu/linux
    (setq dired-listing-switches "-lah")
  (setq dired-listing-switches "-lah --group-directories-first"))

;; windows settings See (customize-group 'ls-lisp)
(setq ls-lisp-dirs-first t)
(setq ls-lisp-ignore-case t)
                                        ; hide the link count, user, and group columns - default is '(links uid gid)
(setq ls-lisp-verbosity '(links))
                                        ; use ISO dates (the first is for recent dates, second for old dates)
(setq ls-lisp-format-time-list '("%Y-%m-%d %H:%M" "%Y-%m-%d %H:%M"))
(setq ls-lisp-use-localized-time-format t)

;; Always copy/delete recursively
(setq dired-recursive-copies (quote always))
(setq dired-recursive-deletes (quote top))

;; Auto-refresh dired on file change
(add-hook 'dired-mode-hook 'auto-revert-mode)
;; Auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(require 'dired-x)
(setq-default dired-omit-files-p t) ; Buffer-local variable
(setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.[^.].+$")
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode)))

;; Allow to switch from current user to sudo when browsind `dired' buffers.
;; To activate and swit with "C-c C-s" just put in your .emacs:
(require 'dired-toggle-sudo)
;; (define-key dired-mode-map (kbd "C-c C-s") 'dired-toggle-sudo)

;; (eval-after-load 'tramp
;;  '(progn
;;     ;; Allow to use: /sudo:user@host:/path/to/file
;;     (add-to-list 'tramp-default-proxies-alist
;;        '(".*" "\\`.+\\'" "/ssh:%h:"))))

;;http://www.emacswiki.org/emacs/DiredPlus
(add-to-list 'load-path "/home/fg/MEGA/dotfiles-manjaro/.emacs.d/private/myPackages/diredPlus")
(require 'dired+)
(define-key dired-mode-map (kbd "C-,") 'diredp-copy-abs-filenames-as-kill)
(define-key dired-mode-map (kbd "C-y") 'diredp-yank-files)
;; does not open a directory on other window
(put 'dired-find-alternate-file 'disabled nil)

;;----------------------------------------
;; http://stackoverflow.com/questions/10226836/how-to-tar-and-compress-marked-files-in-emacs
;; You can also archive files just by marking and copying them to an archive file.
;; For example, mark several files in dired, and select m-x dired-do-copy.
;; When prompted for destination, type test.zip. The files will be added to the zip archive automatically.
;; You can also uncompress files by selecting them in dired and running the command dired-do-extract
;; To set this up, look at the following variables: dired-to-archive-copy-alist dired-extract-alist
;; Here's my setup, which has served me for many years...
;; ;; dired-a provides support functions, including archiving, for dired
;; (load "dired-a")

;; Alist with information how to add files to an archive (from dired-a)
;; Each element has the form (REGEXP ADD-CMD NEW-CMD). If REGEXP matches
;; the file name of a target, that target is an archive and ADD-CMD is a command
;; that adds to an existing archive and NEW-CMD is a command that makes a new
;; archive (overwriting an old one if it exists). ADD-CMD and NEW-CMD are:
;; 1. Nil (meaning we cannot do this for this type of archive) (one of
;;    ADD-CMD and NEW-CMD must be non-nil).
;; 2. A symbol that must be a function e.g. dired-do-archive-op.
;; 3. A format string with two arguments, the source files concatenated into
;;    a space separated string and the target archive.
;; 4. A list of strings, the command and its flags, to which the target and
;;    the source-files are concatenated."
(setq dired-to-archive-copy-alist
      '(("\\.sh\\(ar\\|[0-9]\\)*$" nil "shar %s > %s")
        ("\\.jar$" ("jar" "uvf") ("jar" "cvf"))
        ("\\.tar$" ("tar" "-uf") ("tar" "-cf"))
        ("\\.tgz$\\|\\.tar\\.g?[zZ]$" ("tar" "-uf %s" "|" "gzip > %s") ("tar" "-czvf"))
        ("\\.ear$" ("zip" "-qr") ("zip" "-qr"))
                                        ;   ("\\.rar$" ("rar" "a")   ("rar" "a"))
        ("\\.war$" ("zip" "-qr") ("zip" "-qr"))
        ("\\.zip$" ("zip" "-qr") ("zip" "-qr"))
        ("\\.wmz$" ("zip" "-qr") ("zip" "-qr")) ;; for media player skins
        ("\\.arc$" ("arc" "a") nil)
        ("\\.zoo$" ("zoo" "aP") nil)
        ))

;; use pkzip with manipulating zip files (t) from within dired (use zip
;; and unzip otherwise)
(setq archive-zip-use-pkzip nil)

;; add these file types to archive mode to allow viewing and changing
;; their contents
(add-to-list 'auto-mode-alist '("\\.[ejrw]ar$\\'" . archive-mode))

;; modify the dired-extract switches to use the directory
;; ~/download/tryout as the default extract directory for zip files
(defconst MY_TRYOUT_DIR "~/downloads/tryout"
  "Directory for extracting files")

(setq dired-extract-alist
      `(
        ("\\.u\\(ue\\|aa\\)$" . dired-uud)
        ("\\.jar$" . "jar -xvf %s")
        ("\\.tar$" . ,(concat "tar -xf %s -C " MY_TRYOUT_DIR))
        ("\\.tgz$\\|\\.tar\\.g?[zZ]$" . ,(concat "tar -xzf %s -C " MY_TRYOUT_DIR))
        ("\\.arc$" . "arc x %s ")
        ("\\.bz2$" . ,(concat "bunzip2 -q %s"))
        ("\\.rar$" . ,(concat "unrar x %s " MY_TRYOUT_DIR "\\"))
        ("\\.zip$" . ,(concat "unzip -qq -Ux %s -d " MY_TRYOUT_DIR))
        ("\\.ear$" . ,(concat "unzip -qq -Ux %s -d " MY_TRYOUT_DIR))
        ("\\.war$" . ,(concat "unzip -qq -Ux %s -d " MY_TRYOUT_DIR))
        ("\\.zoo$" . "zoo x. %s ")
        ("\\.lzh$" . "lha x %s ")
        ("\\.7z$"  . "7z e %s ")
        ("\\.g?[zZ]$" . "gzip -d %s")   ; There is only one file
        ))

;; {{{ open directory with Pcmanfm
;; to see @ http://jixiuf.github.io/blog/emacs%E7%9A%84%E6%8F%92%E4%BB%B6openwith.el/
(defun open-directory-with-pcmanfm()
  (interactive)
  (start-process "pcmanfm"  nil "pcmanfm" (expand-file-name  default-directory)))
(eval-after-load 'dired
  '(define-key dired-mode-map (quote [C-M-return]) 'open-directory-with-pcmanfm))
(global-set-key (quote [C-M-return]) (quote open-directory-with-pcmanfm))
;; }}}

;; {{{rsync config
;; to see @ https://vxlabs.com/2018/03/30/asynchronous-rsync-with-emacs-dired-and-tramp/
;; also see @ https://truongtx.me/tmtxt-dired-async.html
(add-to-list 'load-path "/home/fg/MEGA/dotfiles-manjaro/.emacs.d/private/myPackages/tmtxt-async-tasks")
(add-to-list 'load-path "/home/fg/MEGA/dotfiles-manjaro/.emacs.d/private/myPackages/tmtxt-dired-async")
(require 'tmtxt-async-tasks)
(require 'tmtxt-dired-async)
(eval-after-load "dired" '(progn
                            (define-key dired-mode-map (kbd "C-c C-o") 'tda/rsync)
                            (define-key dired-mode-map (kbd "C-c C-R") 'tda/rsync-delete)
                            (define-key dired-mode-map (kbd "C-c C-z") 'tda/zip)
                            (define-key dired-mode-map (kbd "C-c C-u") 'tda/unzip)

                            (define-key dired-mode-map (kbd "C-c C-a") 'tda/rsync-multiple-mark-file)
                            (define-key dired-mode-map (kbd "C-c C-e") 'tda/rsync-multiple-empty-list)
                            (define-key dired-mode-map (kbd "C-c C-d") 'tda/rsync-multiple-remove-item)
                            (define-key dired-mode-map (kbd "C-c C-v") 'tda/rsync-multiple)

                            (define-key dired-mode-map (kbd "C-c C-s") 'tda/get-files-size)

                            (define-key dired-mode-map (kbd "C-c C-q") 'tda/download-to-current-dir)
                            ))
;; }}}

(require 'dired-single)
;; keybinding
(define-key dired-mode-map [remap dired-find-file] #'dired-single-buffer)
(define-key dired-mode-map [remap diredp-up-directory] #'dired-single-up-directory)
(define-key dired-mode-map [remap dired-mouse-find-file-other-window] #'dired-single-buffer-mouse)
(define-key dired-mode-map [remap dired-up-directory] #'dired-single-up-directory)
;; (define-key dired-mode-map (kbd "^") 'dired-single-up-directory)
(define-key dired-mode-map (kbd "<mouse-3>") 'dired-single-up-directory)

(setq dired-omit-size-limit nil) ;dired忽略的上限
(setq large-file-warning-threshold nil)

(provide 'fg-dired)
;; fg-dired.el ends here

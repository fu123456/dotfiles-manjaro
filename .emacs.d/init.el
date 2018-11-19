;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;       Spacemacs default setting ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Avoid garbage collection during startup.
;; see `SPC h . dotspacemacs-gc-cons' for more info
(defconst emacs-start-time (current-time))
(setq gc-cons-threshold 402653184 gc-cons-percentage 0.6)
(load (concat (file-name-directory load-file-name)
              "core/core-versions.el")
      nil (not init-file-debug))
(load (concat (file-name-directory load-file-name)
              "core/core-load-paths.el")
      nil (not init-file-debug))
(load (concat spacemacs-core-directory "core-dumper.el")
      nil (not init-file-debug))

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  ;; Disable file-name-handlers for a speed boost during init
  (let ((file-name-handler-alist nil))
    (require 'core-spacemacs)
    (spacemacs|unless-dumping
      (when (boundp 'load-path-backup)
        (setq load-path load-path-backup)))
    (configuration-layer/load-lock-file)
    (spacemacs/init)
    (configuration-layer/stable-elpa-download-tarball)
    (configuration-layer/load)
    (spacemacs-buffer/display-startup-note)
    (spacemacs/setup-startup-hook)
    (spacemacs|unless-dumping
      (global-font-lock-mode)
      (global-undo-tree-mode t)
      (winner-mode t))
    (when (and dotspacemacs-enable-server (not (spacemacs-is-dumping-p)))
      (require 'server)
      (when dotspacemacs-server-socket-dir
        (setq server-socket-dir dotspacemacs-server-socket-dir))
      (unless (server-running-p)
        (message "Starting a server...")
        (server-start)))
    (spacemacs|when-dumping-strict
      (setq load-path-backup load-path)
      ;; disable undo-tree to prevent from segfaulting when loading the dump
      (global-undo-tree-mode -1)
      (setq spacemacs-dump-mode 'dumped)
      (garbage-collect))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                 fugang setting                       ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;{{{ org C-c C-e, convert dot org file to latex/pdf file, there is error about
;; version of org-mode
(require 'org)
(let ((current-prefix-arg 1))
  (call-interactively 'org-reload))
;;}}}

;;{{{ autosave
;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)
(make-directory "~/.emacs.d/backups/" t)
;; put files
(custom-set-variables
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))
;;}}}

;; {{{ disable warnings at iitialization
;; see @ https://stackoverflow.com/questions/23749267/how-do-i-disable-warnings-at-initialization-in-emacs
(setq warning-minimum-level :emergency)
;; }}}

;; some useful config
;; without it graphviz-dot-mode does not work
(setq default-tab-width 4)

;; ;; disable mouse
;; (require 'disable-mouse)
;; (global-disable-mouse-mode)

;; change the title from emacs@host to file name
(setq-default frame-title-format '("%f [%m]"))
;; revert buffer, time interval, save
(setq auto-revert-interval 0.5)
(setq revert-without-query '(".*"))
;;禁止生成备份文件
(setq make-backup-files nil)
;; close auto save function
(setq auto-save-default nil)

;;{{{
;; start server with emacs
(unless (server-running-p)
  (server-start))
;;}}}

;;{{{ global-mode, turn on these global mode
(yas-global-mode 1)
(global-company-mode 1)
(global-auto-complete-mode nil)
;; see @ https://github.com/Malabarba/aggressive-indent-mode
(global-aggressive-indent-mode 1)
(global-auto-revert-mode)
;;}}}

;;{{{ load config files
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-package-update.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-popwin.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-tramp.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-apperance.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-bibtex.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-matlab.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-vlf.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-keys.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-pdf-tools.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-tools.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-dired.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-latex.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/ora-company.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-graphviz.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-hooks.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-chinese.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-deft.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-git.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-apperance.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-search-engine.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-gnus.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-ediff.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-ebdb.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-secret.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-dict.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-gnuplot.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-fold.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-ibuffer.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-occur.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-org.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-key-chord.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-quickrun.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-gtags.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-visual-regexp.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-expand-region.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-tab.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-cpp.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-sh.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-supersave.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-workgroups2.el"))
;;}}}

;;{{{ open PDF file using others
;;below config about helm-bibtex if put fg-bibtex.el file,
;;it does not work, so put below

;; (setq helm-bibtex-pdf-open-function
;;       (lambda (fpath)
;;         (call-process "zathura" nil 0 nil fpath)))
;; (setq org-ref-open-pdf-function
;;       (lambda (fpath)
;;         (start-process "zathura" "*helm-bibtex-zathura*" "/usr/bin/zathura" fpath)))

;;}}}

(add-hook 'dired-load-hook '(lambda () (require 'dired-x))) ; Load Dired X when Dired is loaded.
(setq dired-omit-mode t) ; Turn on Omit mode.

;; cua-mode setting
(setq cua-enable-cua-keys nil) ;; only for rectangles
(cua-mode t)

;; bind ':ls' command to 'ibuffer instead of 'list-buffers
(evil-ex-define-cmd "ls" 'ibuffer)

(setf epa-pinentry-mode 'loopback)

;; avoid package initialized warning messages
;; (unless package--initialized (package-initialize t))


;; Change workgroups session file
(setq wg-session-file "~/MEGA/dotfiles-manjaro/.emacs.d/.emacs_workgroups")

(setq buffer-save-without-query t)
(setq confirm-nonexistent-file-or-buffer nil)

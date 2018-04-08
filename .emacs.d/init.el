;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Increase gc-cons-threshold, depending on your system you may set it back to a
;; lower value in your dotfile (function `dotspacemacs/user-config')
(setq gc-cons-threshold 100000000)

(defconst spacemacs-version         "0.200.13" "Spacemacs version.")
(defconst spacemacs-emacs-min-version   "24.4" "Minimal version of Emacs.")

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  (load-file (concat (file-name-directory load-file-name)
                     "core/core-load-paths.el"))
  (require 'core-spacemacs)
  (spacemacs/init)
  (configuration-layer/sync)
  (spacemacs-buffer/display-startup-note)
  (spacemacs/setup-startup-hook)
  (require 'server)
  (unless (server-running-p) (server-start)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                 fugang setting                       ;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; load config files
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-apperance.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-bibtex.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-matlab.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-vlf.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-tools.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-dired.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-pdf-tools.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-latex.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/ora-company.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-org.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-graphviz.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-keys.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-hooks.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-chinese.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-deft.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-julia.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-git.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-email.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-apperance.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-org.el"))
(mapc 'load (file-expand-wildcards "~/.emacs.d/private/modes/fg-search-engine.el"))
;; global-mode
(yas-global-mode 1)
(global-company-mode 1)
(global-auto-complete-mode nil)

;; open PDF file using others
;; below config about helm-bibtex if put fg-bibtex.el file,
;; it does not work, so put below
(setq helm-bibtex-pdf-open-function
      (lambda (fpath)
        (call-process "evince" nil 0 nil fpath)))
(setq org-ref-open-pdf-function
      (lambda (fpath)
        (start-process "evince" "*helm-bibtex-evince*" "/usr/bin/evince" fpath)))

(add-hook 'dired-load-hook '(lambda () (require 'dired-x))) ; Load Dired X when Dired is loaded.
(setq dired-omit-mode t) ; Turn on Omit mode.

;; cua-mode setting
(setq cua-enable-cua-keys nil) ;; only for rectangles
(cua-mode t)

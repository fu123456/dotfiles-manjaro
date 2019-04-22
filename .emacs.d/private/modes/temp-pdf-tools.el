(require 'pdf-tools)
;; (package-initialize t)
;; (package-activate 'pdf-tools)
(pdf-tools-install)

;;grap org-pdfview https://github.com/markus1189/org-pdfview/blob/master/org-pdfview.el
(eval-after-load 'org '(require 'org-pdfview))
(add-to-list 'org-file-apps '("\\.pdf\\'" . org-pdfview-open))
(add-to-list 'org-file-apps '("\\.pdf::\\([[:digit:]]+\\)\\'" . org-pdfview-open))

;;{{{ auto revert buffer
;; see @ https://github.com/politza/pdf-tools/issues/25
(setq auto-revert-interval 0.5)
(auto-revert-set-timer)
(setq revert-without-query '(".*"))
(add-hook 'pdf-view-mode-hook (lambda ()
                                (auto-revert-mode 1)
                                ))
;;}}}

;; Avoid hanging Emacs by closing some minor mode
(defun fg/pdf-view-mode-hook ()
  (company-mode -1)
  (auto-complete-mode -1)
  (linum-mode -1)
  (pyim-isearch-mode -1)
  (yas-minor-mode -1)
  (pangu-spacing-mode -1)
  (aggressive-indent-mode -1)
  (line-number-mode -1)
  (font-lock-mode -1)
  (column-number-mode -1)
  (cua-mode -1)
  ;; (eyebrose-mode -1)
  ;; (auto-revert-mode -1)
  (symbol-overlay-mode -1)
  ;; (folding-mode -1)
  )

(add-hook 'pdf-view-mode-hook (lambda ()
                                (vlf-mode 1)
                                ))

;; Close evil-mode in pdf-tools
;; to see @ https://github.com/politza/pdf-tools/issues/201
(evil-set-initial-state 'pdf-view-mode 'emacs)

(add-hook 'pdf-view-mode-hook 'fg/pdf-view-mode-hook)

;; (add-to-list 'display-buffer-alist '("\\.pdf\\(<[^>]+>\\)?$" . (display-buffer-pop-up-window-pdf-split-horizontally)))

;; pdf-tool setting using hydra
(defhydra hydra-pdftools (:color blue :hint nil)
  "
                                                                      ╭───────────┐
       Move  History   Scale/Fit     Annotations  Search/Link    Do   │ PDF Tools │
   ╭──────────────────────────────────────────────────────────────────┴───────────╯
         ^^_gg_^^      _B_    ^↧^    _+_    ^ ^     [_al_] list    [_s_] search    [_u_] revert buffer
         ^^^↑^^^      ^↑^    _H_    ^↑^  ↦ _W_ ↤   [_am_] markup  [_o_] outline   [_i_] info
         ^^_p_^^      ^ ^    ^↥^    _0_    ^ ^     [_at_] text    [_F_] link      [_d_] dark mode
         ^^^↑^^^      ^↓^  ╭─^─^─┐  ^↓^  ╭─^ ^─┐   [_ad_] delete  [_f_] search link
    _h_ ←pag_e_→ _l_  _N_  │ _P_ │  _-_    _b_     [_aa_] dired
         ^^^↓^^^      ^ ^  ╰─^─^─╯  ^ ^  ╰─^ ^─╯   [_y_]  yank
         ^^_n_^^      ^ ^  _r_eset slice box
         ^^^↓^^^
         ^^_G_^^
   --------------------------------------------------------------------------------
        "
  ("\\" hydra-master/body "back")
  ("<ESC>" nil "quit")
  ("al" pdf-annot-list-annotations)
  ("ad" pdf-annot-delete)
  ("aa" pdf-annot-attachment-dired)
  ("am" pdf-annot-add-markup-annotation)
  ("at" pdf-annot-add-text-annotation)
  ("y"  pdf-view-kill-ring-save)
  ("+" pdf-view-enlarge :color red)
  ("-" pdf-view-shrink :co(setq helm-bibtex-pdf-open-function
                                (lambda (fpath)
                                  (call-process "pdf-tools" nil 0 nil fpath)))lor red)
  ("0" pdf-view-scale-reset)
  ("H" pdf-view-fit-height-to-window)
  ("W" pdf-view-fit-width-to-window)
  ("P" pdf-view-fit-page-to-window)
  ("n" pdf-view-next-page-command :color red)
  ("p" pdf-view-previous-page-command :color red)
  ("d" pdf-view-dark-minor-mode)
  ("b" pdf-view-set-slice-from-bounding-box)
  ("r" pdf-view-reset-slice)
  ("gg" pdf-view-first-page)
  ("G" pdf-view-last-page)
  ("e" pdf-view-goto-page)
  ("o" pdf-outline)
  ("s" pdf-occur)
  ("i" pdf-misc-display-metadata)
  ("u" pdf-view-revert-buffer)
  ("F" pdf-links-action-perfom)
  ("f" pdf-links-isearch-link)
  ("B" pdf-history-backward :color red)
  ("N" pdf-history-forward :color red)
  ("l" image-forward-hscroll :color red)
  ("h" image-backward-hscroll :color red))
;; (global-set-key (kbd "<f5>") 'hydra-pdftools/body)
(define-key pdf-view-mode-map (kbd "<f5>") 'hydra-pdftools/body)

;;{{{ remove some keybinding and define new keybinding in pdf-tools
(define-key pdf-view-mode-map (kbd "SPC") nil)
(define-key pdf-view-mode-map (kbd "SPC hb") 'helm-bibtex)
(define-key pdf-view-mode-map (kbd "SPC w") 'hydra-window/body)
(define-key pdf-view-mode-map (kbd "SPC oy") 'xah-copy-file-path)
(define-key pdf-view-mode-map (kbd "SPC ii") 'ibuffer)
(define-key pdf-view-mode-map (kbd "SPC ff") 'find-file)
(define-key pdf-view-mode-map (kbd "SPC bb") 'switch-to-buffer)
(define-key pdf-view-mode-map (kbd "SPC bp") 'previous-buffer)
(define-key pdf-view-mode-map (kbd "SPC bn") 'next-buffer)
;; window movement like vim style
(define-key pdf-view-mode-map (kbd "C-w j") 'evil-window-down)
(define-key pdf-view-mode-map (kbd "C-w k") 'evil-window-up)
(define-key pdf-view-mode-map (kbd "C-w h") 'evil-window-left)
(define-key pdf-view-mode-map (kbd "C-w l") 'evil-window-right)
;; M-x
(define-key pdf-view-mode-map (kbd "SPC SPC") 'counsel-M-x)
;; buffer
(define-key pdf-view-mode-map (kbd "SPC b p") 'previous-buffer)
(define-key pdf-view-mode-map (kbd "SPC b n") 'next-buffer)
(define-key pdf-view-mode-map (kbd "SPC TAB") 'spacemacs/alternate-buffer)
;; quickly open my files
(define-key pdf-view-mode-map (kbd "SPC a") 'hydra-fgfiles/body)
;;;}}}
(define-key pdf-view-mode-map (kbd "SPC [") 'hydra-tab/body)
(define-key pdf-view-mode-map (kbd "SPC ]") 'hydra-workgroups/body)

;; save some useful buffers quickly
(defun fg/save-some-buffers ()
  "Save my some files: latex file, org file, markdown file, PDf file."
  (interactive)
  (save-some-buffers 'no-confirm (lambda ()
                                   (cond
                                    ((and buffer-file-name (equal buffer-file-name abbrev-file-name)))
                                    ((and buffer-file-name (eq major-mode 'latex-mode)))
                                    ((and buffer-file-name (eq major-mode 'markdown-mode)))
				                            ((and buffer-file-name (eq major-mode 'pdf-view-mode)))
                                    ((and buffer-file-name (derived-mode-p 'org-mode)))))))
(define-key pdf-view-mode-map (kbd "<SPC>fw") 'fg/save-some-buffers)

;; some useful keybinding
(define-key pdf-view-mode-map (kbd "C-c C-g") 'pdf-sync-forward-search)
;; (define-key pdf-view-mode-map "j" 'pdf-view-next-line-or-next-page)
;; (define-key pdf-view-mode-map "k" 'pdf-view-previous-line-or-previous-page)
;; (define-key pdf-view-mode-map (kbd "C-j") 'pdf-view-next-page-command)
;; (define-key pdf-view-mode-map (kbd "C-k") 'pdf-view-previous-page-command)

;; more fine-grained zooming
(setq pdf-view-resize-factor 1.1)

;; pdf-view-mode for goldendict
(require 'goldendict)
(evil-leader/set-key (kbd "og") 'goldendict-dwim)

(provide 'fg-pdf-tools)

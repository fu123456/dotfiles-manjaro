;; my keybinding
(evil-leader/set-key (kbd "y") 'hydra-yasnippet/body)
(evil-leader/set-key (kbd "d") 'hydra-dired/body)
(evil-leader/set-key (kbd "p") 'hydra-projectile/body)
(evil-leader/set-key (kbd "O") 'hydra-outline/body)
(evil-leader/set-key (kbd "w") 'hydra-window/body)
(evil-leader/set-key (kbd "c") 'hydra-rectangle/body)
(global-set-key (kbd "<f8>") 'fg/sudo-edit)
(evil-leader/set-key (kbd "a") 'hydra-fgfiles/body)
(global-set-key [f7] 'indent-whole)
(global-set-key (kbd "C-x p i") 'cliplink)
(dolist (key '("\C-z"))
  (global-unset-key key))
;; other keybinding
(evil-leader/set-key (kbd "ii") 'ibuffer)

(defhydra hydra-zoom (global-map "<f10>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out")
  ("r" (text-scale-set 0) "reset")
  ("0" (text-scale-set 0) :bind nil :exit t)
  ("1" (text-scale-set 0) nil :bind nil :exit t))
(global-set-key (kbd "C-;") nil)
(define-key evil-insert-state-map (kbd "C-.") 'evil-delete-backward-word)

;; yasnippet settings using hydra
(defhydra hydra-yasnippet (:color pink :hint nil)
  "
              ^YASnippets^
--------------------------------------------
 ^Modes^   ^Visit^   ^Load^         ^Actions^

 _g_lobal  _h_elm    _d_irectory    _i_nsert
 _m_inor   _f_ile    _a_ll          _t_ryout
 _e_xtra   _l_ist    ^ ^            _n_ew
 ^ ^       ^ ^       ^ ^            _r_egion
"
  ("d" yas-load-directory)
  ("e" yas-activate-extra-mode)
  ("i" yas-insert-snippet)
  ("h" spacemacs/helm-yas)
  ("f" yas-visit-snippet-file :color blue)
  ("n" yas-new-snippet)
  ("t" yas-tryout-snippet)
  ("l" yas-describe-tables)
  ("g" yas/global-mode)
  ("m" yas/minor-mode)
  ("a" yas-reload-all)
  ("r" helm-yas-create-snippet-on-region)
  ;; quit
  ("q" nil "cancel"))

;; dired setting using hydra
(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-x C-q : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir    C-c C-c : commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          C-c ESC : abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _._ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp
_Z_ compress       _Q_ repl regexp

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff)         ;; smart diff
  ("?" dired-summary)
  ("$" diredp-hide-subdir-nomove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay)   ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("c" dired-copy-filename-as-kill) ;; copy current file name
  ("q" nil)
  ("." nil :color blue))

;; projectile
(defhydra hydra-projectile-other-window (:color teal)
  "projectile-other-window"
  ("f"  projectile-find-file-other-window        "file")
  ("g"  projectile-find-file-dwim-other-window   "file dwim")
  ("d"  projectile-find-dir-other-window         "dir")
  ("b"  projectile-switch-to-buffer-other-window "buffer")
  ("q"  nil                                      "cancel" :color blue))

(defhydra hydra-projectile (:color teal
                                   :hint nil)
  "
     PROJECTILE: %(projectile-project-root)

     Find File            Search/Tags          Buffers                Cache
------------------------------------------------------------------------------------------
_s-f_: file            _a_: ag                _i_: Ibuffer           _c_: cache clear
 _ff_: file dwim       _g_: update gtags      _b_: switch to buffer  _x_: remove known project
 _fd_: file curr dir   _o_: multi-occur     _s-k_: Kill all buffers  _X_: cleanup non-existing
  _r_: recent file                                               ^^^^_z_: cache current
  _d_: dir

"
  ("a"   projectile-ag)
  ("b"   projectile-switch-to-buffer)
  ("c"   projectile-invalidate-cache)
  ("d"   projectile-find-dir)
  ("s-f" projectile-find-file)
  ("ff"  projectile-find-file-dwim)
  ("fd"  projectile-find-file-in-directory)
  ("g"   ggtags-update-tags)
  ("s-g" ggtags-update-tags)
  ("i"   projectile-ibuffer)
  ("K"   projectile-kill-buffers)
  ("s-k" projectile-kill-buffers)
  ("m"   projectile-multi-occur)
  ("o"   projectile-multi-occur)
  ("s-p" projectile-switch-project "switch project")
  ("p"   projectile-switch-project)
  ("s"   projectile-switch-project)
  ("r"   projectile-recentf)
  ("x"   projectile-remove-known-project)
  ("X"   projectile-cleanup-known-projects)
  ("z"   projectile-cache-current-file)
  ("`"   hydra-projectile-other-window/body "other window")
  ("q"   nil "cancel" :color blue))
;; projectile settting using hydra
(defhydra hydra-project (:color blue :hint nil :idle 0.4)
  "
                                                                    ╭────────────┐
    Files             Search          Buffer             Do         │ Projectile │
  ╭─────────────────────────────────────────────────────────────────┴────────────╯
    [_f_] file          [_a_] ag          [_b_] switch         [_g_] magit
    [_l_] file dwim     [_A_] grep        [_v_] show all       [_p_] commander
    [_r_] recent file   [_s_] occur       [_V_] ibuffer        [_i_] info
    [_d_] dir           [_S_] replace     [_K_] kill all
    [_o_] other         [_t_] find tag
    [_u_] test file     [_T_] make tags
    [_h_] root
                                                                        ╭────────┐
    Other Window      Run             Cache              Do             │ Fixmee │
  ╭──────────────────────────────────────────────────╯ ╭────────────────┴────────╯
    [_F_] file          [_U_] test        [_kc_] clear         [_x_] TODO & FIXME
    [_L_] dwim          [_m_] compile     [_kk_] add current   [_X_] toggle
    [_D_] dir           [_c_] shell       [_ks_] cleanup
    [_O_] other         [_C_] command     [_kd_] remove
    [_B_] buffer
  --------------------------------------------------------------------------------
        "
  ("<tab>" hydra-master/body "back")
  ("<ESC>" nil "quit")
  ("a"   projectile-ag)
  ("A"   projectile-grep)
  ("b"   projectile-switch-to-buffer)
  ("B"   projectile-switch-to-buffer-other-window)
  ("c"   projectile-run-async-shell-command-in-root)
  ("C"   projectile-run-command-in-root)
  ("d"   projectile-find-dir)
  ("D"   projectile-find-dir-other-window)
  ("f"   projectile-find-file)
  ("F"   projectile-find-file-other-window)
  ("g"   projectile-vc)
  ("h"   projectile-dired)
  ("i"   projectile-project-info)
  ("kc"  projectile-invalidate-cache)
  ("kd"  projectile-remove-known-project)
  ("kk"  projectile-cache-current-file)
  ("K"   projectile-kill-buffers)
  ("ks"  projectile-cleanup-known-projects)
  ("l"   projectile-find-file-dwim)
  ("L"   projectile-find-file-dwim-other-window)
  ("m"   projectile-compile-project)
  ("o"   projectile-find-other-file)
  ("O"   projectile-find-other-file-other-window)
  ("p"   projectile-commander)
  ("r"   projectile-recentf)
  ("s"   projectile-multi-occur)
  ("S"   projectile-replace)
  ("t"   projectile-find-tag)
  ("T"   projectile-regenerate-tags)
  ("u"   projectile-find-test-file)
  ("U"   projectile-test-project)
  ("v"   projectile-display-buffer)
  ("V"   projectile-ibuffer)
  ("X"   fixmee-mode)
  ("x"   fixmee-view-listing))

;; outline mode setting using hydra
(defhydra hydra-outline (:color pink
                                :hint nil)
  "
^Hide^              ^Show^          ^Jump^
^^^^^^^^-------------j---------------------------------------
_B_: body           _a_: all        _n_: next
_e_: entry          _E_: entry      _p_: previous
_o_: other          _c_: children   _f_: forward
_s_: subtree        _r_: branches   _b_: backward
_l_: leaves         _S_: subtree    _u_: up
_U_: sublevels      ^ ^             ^ ^
"
  ;; show
  ("a" show-all)
  ("c" show-children)
  ("E" show-entry)
  ("r" show-branches)
  ("S" show-subtree)
  ;; hide
  ("B" hide-body)
  ("o" hide-other)
  ("e" hide-entry)
  ("s" hide-subtree)
  ("l" hide-leaves)
  ("U" hide-sublevels)
  ;; outline move
  ("n" outline-next-visible-heading)
  ("p" outline-previous-visible-heading)
  ("f" outline-forward-same-level)
  ("b" outline-backward-same-level)
  ("u" outline-up-heading)
  ;; quit
  ("q" nil "cancel")
  )

;; quickly open my files
(defun open-init-file()
  (interactive) (find-file "~/.emacs.d/init.el"))
(defun open-init-file-spacemacs()
  (interactive)
  (find-file "~/.spacemacs"))
(defun reload-init-file()
  (interactive)
  (load-file "~/.emacs.d/init.el"))
(defun open-bookmark-file()
  (interactive)
  (find-file "/home/fg/MEGA/org/bookmark.org"))
(defun open-refnotes-file()
  (interactive)
  (find-file "/home/fg/MEGA/org/refnotes.org"))
(defun open-bibtex-file()
  (interactive)
  (find-file "/home/fg/MEGA/bibtex-pdfs/bib/references.bib")
  )
(defun open-bibtex-org-file ()
  (interactive)
  (find-file "/home/fg/MEGA/bibtex-pdfs/bib/references.org")
  )
(defun open-gtd-file()
  (interactive)
  (find-file "~/MEGA/org/gtd.org")
  )
(defun open-paper-file()
  (interactive)
  (find-file "~/MEGA/org/paper.org")
  )
(defun open-orgconfig-file()
  (interactive)
  (find-file "~/.emacs.d/private/modes/fg-org.el")
  )
(defun open-code-file ()
  (interactive)
  (find-file "~/MEGA/org/codes.org")
  )
(defun open-interent-file ()
  (interactive)
  (find-file "~/MEGA/org/surfInternet.org")
  )
(defun open-latex-symbol-file ()
  (interactive)
  (find-file "/home/fg/MEGA/linux-pdfs/Symbols.pdf")
  )

;; quickl open my files using hydra
(defhydra hydra-fgfiles (:color pink
                                :hint nil)
  "
^Configuration^         ^Org^                ^Code^               ^LatexWritting^
^^^^^^^^----------------------------------------------------------------------------------
_i_: init               _n_: bookmark      _c_: codes            _B_:bibtexOrg
_r_: reload init        _f_: refnotes      _I_: surfInternet     _b_:bibtexBib
_s_: spacemacs          _g_: gtd           ^ ^                   _l_:mathSymbol
_o_: orgconfig          _p_: paper         ^ ^
  "
  ;; config files
  ("i" open-init-file)
  ("s" open-init-file-spacemacs)
  ("r" reload-init-file)
  ("o" open-orgconfig-file)
  ;; org files
  ("n" open-bookmark-file)
  ("f" open-refnotes-file)
  ("b" open-bibtex-file)
  ("g" open-gtd-file)
  ("B" open-bibtex-org-file)
  ("p" open-paper-file)
  ;; other
  ("c" open-code-file)
  ("I" open-interent-file)
  ("l" open-latex-symbol-file)
  ;; quit
  ("q" nil "cancel")
  )

;;拷贝代码自动格式化
(dolist (command '(yank yank-pop))
  (eval
   `(defadvice ,command (after indent-region activate)
      (and (not current-prefix-arg)
           (member major-mode
                   '(emacs-lisp-mode
                     lisp-mode
                     clojure-mode
                     scheme-mode
                     haskell-mode
                     ruby-mode
                     rspec-mode
                     python-mode
                     c-mode
                     c++-mode
                     objc-mode
                     latex-mode
                     js-mode
                     markdown-mode
                     matlab-mode
                     octave-mode
                     org-mode
                     plain-tex-mode))
           (let ((mark-even-if-inactive transient-mark-mode))
             (indent-region (region-beginning) (region-end) nil))))))

;;代码格式化
;;格式化整个文件函数
(defun indent-whole ()
  (interactive)
  (indent-region (point-min) (point-max))
  (message "format successfully"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; window move config ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun hydra-move-splitter-left (arg)
  "Move window splitter left."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (shrink-window-horizontally arg)
    (enlarge-window-horizontally arg)))

(defun hydra-move-splitter-right (arg)
  "Move window splitter right."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (enlarge-window-horizontally arg)
    (shrink-window-horizontally arg)))

(defun hydra-move-splitter-up (arg)
  "Move window splitter up."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (enlarge-window arg)
    (shrink-window arg)))

(defun hydra-move-splitter-down (arg)
  "Move window splitter down."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (shrink-window arg)
    (enlarge-window arg)))

(defhydra hydra-window ()
  "
Movement^^        ^Split^         ^Switch^		^Resize^      ^Layout^
-----------------------------------------------------------------------
_h_ ←       	_v_ertical    	_b_uffer		_Q_ X←            _u_ undo
_j_ ↓        	_x_ horizontal	_f_ind files	_w_ X↓          _r_ redo
_k_ ↑        	_z_ undo      	_a_ce 1		_e_ X↑
_l_ →        	_Z_ reset      	_s_wap		_R_ X→
_F_ollow		_D_lt Other   	_S_ave		max_i_mize
_q_ cancel	_o_nly this   	_d_elete
"
  ("u" winner-undo)
  ("r" winner-redo)
  ("h" windmove-left )
  ("j" windmove-down )
  ("k" windmove-up )
  ("l" windmove-right )
  ("Q" hydra-move-splitter-left)
  ("w" hydra-move-splitter-down)
  ("e" hydra-move-splitter-up)
  ("R" hydra-move-splitter-right)
  ("b" helm-mini)
  ("f" helm-find-files)
  ("F" follow-mode)
  ("a" (lambda ()
         (interactive)
         (ace-window 1)
         (add-hook 'ace-window-end-once-hook
                   'hydra-window/body))
   )
  ("v" (lambda ()
         (interactive)
         (split-window-right)
         (windmove-right))
   )
  ("x" (lambda ()
         (interactive)
         (split-window-below)
         (windmove-down))
   )
  ("s" (lambda ()
         (interactive)
         (ace-window 4)
         (add-hook 'ace-window-end-once-hook
                   'hydra-window/body)))
  ("S" save-buffer)
  ("d" delete-window)
  ("D" (lambda ()
         (interactive)
         (ace-window 16)
         (add-hook 'ace-window-end-once-hook
                   'hydra-window/body))
   )
  ("o" delete-other-windows)
  ("i" ace-maximize-window)
  ("z" (progn
         (winner-undo)
         (setq this-command 'winner-undo))
   )
  ("Z" winner-redo)
  ("SPC" nil)
  ("q" nil)
  )

;; bookmark setting
;; refer to http://rexim.me/emacs-as-bookmark-manager-links.html
(defun straight-string (s)
  (mapconcat '(lambda (x) x) (split-string s) " "))

(defun extract-title-from-html (html)
  (let ((start (string-match "<title>" html))
        (end (string-match "</title>" html))
        (chars-to-skip (length "<title>")))
    (if (and start end (< start end))
        (substring html (+ start chars-to-skip) end)
      nil)))

(defun prepare-cliplink-title (title)
  (let ((replace-table '(("\\[" . "{")
                         ("\\]" . "}")
                         ("&mdash;" . "—")))
        (max-length 77)
        (result (straight-string title)))
    (dolist (x replace-table)
      (setq result (replace-regexp-in-string (car x) (cdr x) result)))
    (when (> (length result) max-length)
      (setq result (concat (substring result 0 max-length) "...")))
    result))

(defun perform-cliplink (buffer url content)
  (let* ((decoded-content (decode-coding-string content 'utf-8))
         (title (prepare-cliplink-title
                 (extract-title-from-html decoded-content))))
    (with-current-buffer buffer
      (insert (format "[[%s][%s]]" url title)))))

(defun cliplink ()
  (interactive)
  (let ((dest-buffer (current-buffer))
        (url (substring-no-properties (current-kill 0))))
    (url-retrieve
     url
     `(lambda (s)
        (perform-cliplink ,dest-buffer ,url
                          (buffer-string))))))

;; mc-evil
(defhydra hydra-mc (:body-pre (evil-mc-mode 1)
                              :color pink
                              :hint nil
                              :post (deactivate-mark))
  "
^ ^                      ^Cursor^                     ^Match^
                   ^Make^        ^Skip^         ^Make^       ^Skip^
^^^^^^^^-----------------------------------------------------------------
_grm_: make all    _M-n_: next   _grN_: next    _C-n_: next  _grn_: next
_gru_: undo all    _M-p_: prev   _grP_: prev    _C-p_: prev  _grp_: prev
_grs_: pause       _grj_: nline
_grr_: resume      _grk_: pline
_grh_: here
_grf_: first
_grl_: last
"
  ("grm"  evil-mc-make-all-cursors)
  ("gru"  evil-mc-undo-all-cursors)
  ("grs"  evil-mc-pause-cursors)
  ("grr"  evil-mc-resume-cursors)
  ("grf"  evil-mc-make-and-goto-first-cursor)
  ("grl"  evil-mc-make-and-goto-last-cursor)
  ("grh"  evil-mc-make-cursor-here)
  ("grj"  evil-mc-make-cursor-move-next-line)
  ("grk"  evil-mc-make-cursor-move-prev-line)
  ("M-n"  evil-mc-make-and-goto-next-cursor)
  ("grN"  evil-mc-skip-and-goto-next-cursor)
  ("M-p"  evil-mc-make-and-goto-prev-cursor)
  ("grP"  evil-mc-skip-and-goto-prev-cursor)
  ("C-n"  evil-mc-make-and-goto-next-match)
  ("grn"  evil-mc-skip-and-goto-next-match)
  ("C-t"  evil-mc-skip-and-goto-next-match)
  ("C-p"  evil-mc-make-and-goto-prev-match)
  ("grp"  evil-mc-skip-and-goto-prev-match)
  ("." hydra-repeat)
  ;; quit
  ("q" nil "cancel"))
(evil-leader/set-key (kbd "ec") 'hydra-mc/body)

(defun fg/sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defhydra hydra-rectangle (:body-pre (rectangle-mark-mode 1)
                                     :color pink
                                     :hint nil
                                     :post (deactivate-mark))
  "
  ^_k_^       _w_ copy      _o_pen       _N_umber-lines            |\\     -,,,--,,_
_h_   _l_     _y_ank        _t_ype       _e_xchange-point          /,`.-'`'   ..  \-;;,_
  ^_j_^       _d_ kill      _c_lear      _r_eset-region-mark      |,4-  ) )_   .;.(  `'-'
^^^^          _u_ndo        _q_ quit     ^ ^                     '---''(./..)-'(_\_)
"
  ("k" rectangle-previous-line)
  ("j" rectangle-next-line)
  ("h" rectangle-backward-char)
  ("l" rectangle-forward-char)
  ("d" kill-rectangle)                    ;; C-x r k
  ("y" yank-rectangle)                    ;; C-x r y
  ("w" copy-rectangle-as-kill)            ;; C-x r M-w
  ("o" open-rectangle)                    ;; C-x r o
  ("t" string-rectangle)                  ;; C-x r t
  ("c" clear-rectangle)                   ;; C-x r c
  ("e" rectangle-exchange-point-and-mark) ;; C-x C-x
  ("N" rectangle-number-lines)            ;; C-x r N
  ("r" (if (region-active-p)
           (deactivate-mark)
         (rectangle-mark-mode 1)))
  ("u" undo nil)
  ("q" nil))      ;; ok
;;{{{ magit
(defhydra hydra-magit(:color blue :hint nil)
  "
_mp_ magit-push _mc_ magit-commit _md_ magit diff _mla_ magit log _ms_ magit status
"
  ;;Magit part
  ("mp" magit-push)
  ("mc" magit-commit)
  ("md" magit-diff)
  ("mla" magit-log-all)
  ("ms" magit-status)
  )
(evil-leader/set-key (kbd "ma") 'hydra-magit/body)
;;}}}

;;{{{ mail
;; @see https://github.com/redguardtoo/mastering-emacs-in-one-year-guide/blob/master/gnus-guide-en.org
;; gnus-group-mode
(eval-after-load 'gnus-group
  '(progn
     (defhydra hydra-gnus-group (:color blue)
       "?"
       ("a" gnus-group-list-active "REMOTE groups A A")
       ("l" gnus-group-list-all-groups "LOCAL groups L")
       ("c" gnus-topic-catchup-articles "Rd all c")
       ("G" gnus-group-make-nnir-group "Srch server G G")
       ("g" gnus-group-get-new-news "Refresh g")
       ("s" gnus-group-enter-server-mode "Servers")
       ("m" gnus-group-new-mail "Compose m OR C-x m")
       ("#" gnus-topic-mark-topic "mark #")
       ("q" nil "Bye"))
     ;; y is not used by default
     (define-key gnus-group-mode-map "y" 'hydra-gnus-group/body)))

;; gnus-summary-mode
(eval-after-load 'gnus-sum
  '(progn
     (defhydra hydra-gnus-summary (:color blue)
       "?"
       ("s" gnus-summary-show-thread "Show thread")
       ("h" gnus-summary-hide-thread "Hide thread")
       ("n" gnus-summary-insert-new-articles "Refresh / N")
       ("f" gnus-summary-mail-forward "Fwd C-c C-f")
       ("!" gnus-summary-tick-article-forward "Mail -> disk !")
       ("p" gnus-summary-put-mark-as-read "Mail <- disk")
       ("c" gnus-summary-catchup-and-exit "Rd all c")
       ("e" gnus-summary-resend-message-edit "Resend S D e")
       ("R" gnus-summary-reply-with-original "Re with orig R")
       ("r" gnus-summary-reply "Re r")
       ("W" gnus-summary-wide-reply-with-original "Re all with orig S W")
       ("w" gnus-summary-wide-reply "Re all S w")
       ("#" gnus-topic-mark-topic "Mark #")
       ("q" nil "Bye"))
     ;; y is not used by default
     (define-key gnus-summary-mode-map "y" 'hydra-gnus-summary/body)))

;; gnus-article-mode
(eval-after-load 'gnus-art
  '(progn
     (defhydra hydra-gnus-article (:color blue)
       "?"
       ("f" gnus-summary-mail-forward "Fwd")
       ("R" gnus-article-reply-with-original "Re with orig R")
       ("r" gnus-article-reply "Re r")
       ("W" gnus-article-wide-reply-with-original "Re all with orig S W")
       ("o" gnus-mime-save-part "Save attachment at point o")
       ("w" gnus-article-wide-reply "Re all S w")
       ("v" w3mext-open-with-mplayer "Video/audio at point")
       ("d" w3mext-download-rss-stream "CLI to download stream")
       ("b" w3mext-open-link-or-image-or-url "Link under cursor or page URL with external browser")
       ("f" w3m-lnum-follow "Click link/button/input")
       ("F" w3m-lnum-goto "Move focus to link/button/input")
       ("q" nil "Bye"))
     ;; y is not used by default
     (define-key gnus-article-mode-map "y" 'hydra-gnus-article/body)))

;; message-mode
(eval-after-load 'message
  '(progn
     (defhydra hydra-message (:color blue)
       "?"
       ("a" counsel-bbdb-complete-mail "Mail address")
       ("ca" mml-attach-file "Attach C-c C-a")
       ("cc" message-send-and-exit "Send C-c C-c")
       ("q" nil "Bye"))))

(defun message-mode-hook-hydra-setup ()
  (local-set-key (kbd "C-c C-y") 'hydra-message/body))
(add-hook 'message-mode-hook 'message-mode-hook-hydra-setup)
;;}}}

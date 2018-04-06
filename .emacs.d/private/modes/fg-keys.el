;; my keybinding
(evil-leader/set-key (kbd "y") 'hydra-yasnippet/body)
(evil-leader/set-key (kbd "d") 'hydra-dired/body)
(evil-leader/set-key (kbd "p") 'hydra-projectile/body)
(evil-leader/set-key (kbd "o") 'hydra-outline/body)
(evil-leader/set-key (kbd "w") 'hydra-window/body)
(global-set-key (kbd "<f8>") 'fg/sudo-edit)
(evil-leader/set-key (kbd "a") 'hydra-fgfiles/body)
(global-set-key [f7] 'indent-whole)
(global-set-key (kbd "C-x p i") 'cliplink)
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
  ("q" nil)
  ("." nil :color blue))

;; projectile settting using hydra
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
(defun open-notes-file()
  (interactive)
  (find-file "/home/fg/MEGA/org/notes.org"))
(defun open-refnotes-file()
  (interactive)
  (find-file "/home/fg/MEGA/org/refnotes.org"))
(defun open-bibtex-file()
  (interactive)
  (find-file "/home/fg/MEGA/bibtex-pdfs/bib/references.bib")
  )
(defun open-gtd-file()
  (interactive)
  (find-file "~/MEGA/org/gtd.org")
  )
(defun open-orgconfig-file()
  (interactive)
  (find-file "~/.emacs.d/private/modes/org.el")
  )
(defun open-code-file ()
  (interactive)
  (find-file "~/MEGA/org/codes.org")
  )

;; quickl open my files using hydra
(defhydra hydra-fgfiles (:color pink
                                :hint nil)
  "
^Configuration^         ^Org^                ^Code^
^^^^^^^^------------------------------------------------------
_i_: init               _n_: notes         _c_: codes
_r_: reload init        _f_: refnotes
_s_: spacemacs          _b_: bibtex
_o_: orgconfig          _g_: gtd
  "
  ;; config files
  ("i" open-init-file)
  ("s" open-init-file-spacemacs)
  ("r" reload-init-file)
  ("o" open-orgconfig-file)
  ;; org files
  ("n" open-notes-file)
  ("f" open-refnotes-file)
  ("b" open-bibtex-file)
  ("g" open-gtd-file)
  ;; other
  ("c" open-code-file)
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

(defhydra hydra-window (:color red
                        :columns nil)
  "window"
  ("h" windmove-left nil)
  ("j" windmove-down nil)
  ("k" windmove-up nil)
  ("l" windmove-right nil)
  ("H" hydra-move-splitter-left nil)
  ("J" hydra-move-splitter-down nil)
  ("K" hydra-move-splitter-up nil)
  ("L" hydra-move-splitter-right nil)
  ("v" (lambda ()
         (interactive)
         (split-window-right)
         (windmove-right))
       "vert")
  ("x" (lambda ()
         (interactive)
         (split-window-below)
         (windmove-down))
       "horz")
  ("t" transpose-frame "'" :exit t)
  ("o" delete-other-windows "one" :exit t)
  ("a" ace-window "ace")
  ("s" ace-swap-window "swap")
  ("d" ace-delete-window "del")
  ("i" ace-maximize-window "ace-one" :exit t)
  ("b" ido-switch-buffer "buf")
  ("m" headlong-bookmark-jump "bmk")
  ("q" nil "cancel")
  ("u" (progn (winner-undo) (setq this-command 'winner-undo)) "undo")
  ("f" nil))

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

(defhydra hydra-mc (:color pink :hint nil)
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

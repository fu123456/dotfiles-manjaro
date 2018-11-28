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
(define-key evil-normal-state-map (kbd "<SPC>fw") 'fg/save-some-buffers)

(defun fg/save-all-file-buffers ()
  "saves every buffer associated with a file."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (buffer-modified-p))
        (save-buffer)))))
(define-key evil-normal-state-map (kbd "<SPC>fW") 'fg/save-all-file-buffers)

;; you can use "daw" in the vim style, remove a word and word
(defun fg/kill-line-backwards ()
  "Kill line backwards and adjust the indentation."
  (interactive)
  (kill-line 0)
  (indent-according-to-mode))
(global-set-key (kbd "C-<backspace>") #'fg/kill-line-backwards)

(defun fg/kill-other-buffers ()
  "Kill all buffers but the current one.
Don't mess with special buffers."
  (interactive)
  (dolist (buffer (buffer-list))
    (unless (or (eql buffer (current-buffer)) (not (buffer-file-name buffer)))
      (kill-buffer buffer))))
(global-set-key (kbd "C-c K") 'fg/kill-other-buffers)

;; useful mapping, which is same as the config of HHKB keyboard
;; C-; left char
;; C-' right char
;; C-[ up line
;; C-? down line
(define-key global-map (kbd "C-;") nil)
(define-key evil-insert-state-map (kbd "C-;") 'left-char)
(define-key evil-insert-state-map (kbd "C-'") 'right-char)
;; (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-word)
;; (define-key global-map (kbd "C-[") nil)
;; (define-key global-map (kbd "C-?") nil)
;; (define-key evil-insert-state-map (kbd "C-[") 'evil-previous-line)
;; (define-key evil-insert-state-map (kbd "C-?") 'evil-next-line)

;; window moving quickly
;; you can also use <SPC>+number of window
;; for example,<SPC>+2
(define-key global-map (kbd "C-k") 'windmove-up)
(define-key global-map (kbd "C-j") 'windmove-down)
(define-key global-map (kbd "C-h") 'windmove-left)
(define-key global-map (kbd "C-l") 'windmove-right)

;; {{ presentation
;; control my pdf presentation without leaving my Emacs
;; xdotool key --window $(xdotool search --name "presentation.pdf") Return
(defun fg/presentation-move-next ()
  "click next monitor, pdf next, and back"
  (interactive)
  (shell-command
   "bash ~/MEGA/dotfiles-manjaro/scripts/move-other-monitor-bak.sh"
   ))
(defun fg/presentation-move-previous ()
  "click next monitor, pdf previous, and back"
  (interactive)
  (shell-command
   "bash ~/MEGA/dotfiles-manjaro/scripts/move-other-monitor-bak-previous-pdf.sh"
   ))
(define-key evil-normal-state-map (kbd "<SPC>.") 'fg/presentation-move-next)
(define-key evil-normal-state-map (kbd "<SPC>,") 'fg/presentation-move-previous)
;; }}

;;{{{
;; Fill and unfill paragraphs with a single key
;; see @ http://endlessparentheses.com/fill-and-unfill-paragraphs-with-a-single-key.html
(defun endless/fill-or-unfill ()
  "Like `fill-paragraph', but unfill if used twice."
  (interactive)
  (let ((fill-column
         (if (eq last-command 'endless/fill-or-unfill)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (call-interactively #'fill-paragraph)))

(global-set-key [remap fill-paragraph]
                #'endless/fill-or-unfill)
;;}}}

;;{{{ copy the file-name/full-path in dired buffer into clipboard
;; `w` => copy file name
;; `C-u 0 w` => copy full path
(defadvice dired-copy-filename-as-kill (after dired-filename-to-clipboard activate)
  (with-temp-buffer
    (insert (current-kill 0))
    (shell-command-on-region (point-min) (point-max)
                             (cond
                              ((eq system-type 'cygwin) "putclip")
                              ((eq system-type 'darwin) "pbcopy")
                              (t "xsel -ib")
                              )))
  (message "%s => clipboard" (current-kill 0))
  )
;;}}}

;; {{{ copy file path of current buffer
;; see @http://ergoemacs.org/emacs/emacs_copy_file_path.html
(defun xah-copy-file-path (&optional @dir-path-only-p)
  "Copy the current buffer's file path or dired path to `kill-ring'.
Result is full path.
If `universal-argument' is called first, copy only the dir path.

If in dired, copy the file/dir cursor is on, or marked files.

If a buffer is not file and not dired, copy value of `default-directory' (which is usually the “current” dir when that buffer was created)

URL `http://ergoemacs.org/emacs/emacs_copy_file_path.html'
Version 2017-09-01"
  (interactive "P")
  (let (($fpath
         (if (string-equal major-mode 'dired-mode)
             (progn
               (let (($result (mapconcat 'identity (dired-get-marked-files) "\n")))
                 (if (equal (length $result) 0)
                     (progn default-directory )
                   (progn $result))))
           (if (buffer-file-name)
               (buffer-file-name)
             (expand-file-name default-directory)))))
    (kill-new
     (if @dir-path-only-p
         (progn
           (message "Directory path copied: 「%s」" (file-name-directory $fpath))
           (file-name-directory $fpath))
       (progn
         (message "File path copied: 「%s」" $fpath)
         $fpath )))))
(define-key evil-normal-state-map (kbd "<SPC>oy") 'xah-copy-file-path)
;; }}}

;; copy current directory path
(define-key evil-normal-state-map (kbd "<SPC>od") 'spacemacs/copy-directory-path)

;; {{{ open a file with external app
(defun prelude-open-with (arg)
  "Open visited file in default external program.
With a prefix ARG always prompt for command to use."
  (interactive "P")
  (when buffer-file-name
    (shell-command (concat
                    (cond
                     ;; ((and (not arg) (eq system-type 'darwin)) "open")
                     ;; ((and (not arg) (member system-type '(gnu gnu/linux gnu/kfreebsd))) "xdg-open")
                     (t (read-shell-command "Open current file with: ")))
                    " "
                    (shell-quote-argument buffer-file-name)))))
(global-set-key (kbd "C-c C-u o") 'prelude-open-with)
;; }}}

;; {{{ convert markdown file to org file
(defun markdown-convert-buffer-to-org ()
  "Convert the current buffer's content from markdown to orgmode format and save it with the current buffer's file name but with .org extension."
  (interactive)
  (shell-command-on-region (point-min) (point-max)
                           (format "pandoc -f markdown -t org -o %s"
                                   (concat (file-name-sans-extension (buffer-file-name)) ".org"))))
;; }}}

;; {{{
;; see @https://emacsredux.com/blog/2013/03/27/open-file-in-external-program/
(defun er-open-with (arg)
  "Open visited file in default external program.

With a prefix ARG always prompt for command to use."
  (interactive "P")
  (when buffer-file-name
    (shell-command (concat
                    (cond
                     ((and (not arg) (eq system-type 'darwin)) "open")
                     ((and (not arg) (member system-type '(gnu gnu/linux gnu/kfreebsd))) "xdg-open")
                     (t (read-shell-command "Open current file with: ")))
                    " "
                    (shell-quote-argument buffer-file-name)))))
(global-set-key (kbd "C-c C-o") #'er-open-with)
;; }}}

(provide 'fg-tools)
;;; fg-tools.el ends here

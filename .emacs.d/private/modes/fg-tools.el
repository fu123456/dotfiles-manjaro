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
(add-to-list 'load-path "/home/fg/MEGA/dotfiles-manjaro/.emacs.d/private/myPackages/xah-replace-pairs")
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

;; {{{ Convert Full-Width/Half-Width Punctuations
;; to see @ http://ergoemacs.org/emacs/elisp_convert_chinese_punctuation.html
;; This page shows commands to convert to/from Full-Width/Half-Width characters. (全角 半角 转换)

(defun xah-convert-english-chinese-punctuation (@begin @end &optional @to-direction)
  "Convert punctuation from/to English/Chinese characters.

When called interactively, do current line or selection. The conversion direction is automatically determined.

If `universal-argument' is called, ask user for change direction.

When called in lisp code, *begin *end are region begin/end positions. *to-direction must be any of the following values: 「\"chinese\"」, 「\"english\"」, 「\"auto\"」.

See also: `xah-remove-punctuation-trailing-redundant-space'.

URL `http://ergoemacs.org/emacs/elisp_convert_chinese_punctuation.html'
Version 2015-10-05"
  (interactive
   (let ($p1 $p2)
     (if (use-region-p)
         (progn
           (setq $p1 (region-beginning))
           (setq $p2 (region-end)))
       (progn
         (setq $p1 (line-beginning-position))
         (setq $p2 (line-end-position))))
     (list
      $p1
      $p2
      (if current-prefix-arg
          (ido-completing-read
           "Change to: "
           '( "english"  "chinese")
           "PREDICATE"
           "REQUIRE-MATCH")
        "auto"
        ))))
  (let (
        ($input-str (buffer-substring-no-properties @begin @end))
        ($replacePairs
         [
          [". " "。"]
          [".\n" "。\n"]
          [", " "，"]
          [",\n" "，\n"]
          [": " "："]
          ["; " "；"]
          ["? " "？"] ; no space after
          ["! " "！"]

          ;; for inside HTML
          [".</" "。</"]
          ["?</" "？</"]
          [":</" "：</"]
          [" " "　"]
          ]
         ))

    (when (string= @to-direction "auto")
      (setq
       @to-direction
       (if
           (or
            (string-match "　" $input-str)
            (string-match "。" $input-str)
            (string-match "，" $input-str)
            (string-match "？" $input-str)
            (string-match "！" $input-str))
           "english"
         "chinese")))
    (save-excursion
      (save-restriction
        (narrow-to-region @begin @end)
        (mapc
         (lambda ($x)
           (progn
             (goto-char (point-min))
             (while (search-forward (aref $x 0) nil "noerror")
               (replace-match (aref $x 1)))))
         (cond
          ((string= @to-direction "chinese") $replacePairs)
          ((string= @to-direction "english") (mapcar (lambda (x) (vector (elt x 1) (elt x 0))) $replacePairs))
          (t (user-error "Your 3rd argument 「%s」 isn't valid" @to-direction))))))))
(defun xah-remove-punctuation-trailing-redundant-space (@begin @end)
  "Remove redundant whitespace after punctuation.
Works on current line or text selection.

When called in emacs lisp code, the *begin *end are cursor positions for region.

See also `xah-convert-english-chinese-punctuation'.

URL `http://ergoemacs.org/emacs/elisp_convert_chinese_punctuation.html'
version 2015-08-22"
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-end-position))))
  (require 'xah-replace-pairs)
  (xah-replace-regexp-pairs-region
   @begin @end
   [
    ;; clean up. Remove extra space.
    [" +," ","]
    [",  +" ", "]
    ["?  +" "? "]
    ["!  +" "! "]
    ["\\.  +" ". "]

    ;; fullwidth punctuations
    ["， +" "，"]
    ["。 +" "。"]
    ["： +" "："]
    ["？ +" "？"]
    ["； +" "；"]
    ["！ +" "！"]
    ["、 +" "、"]
    ]
   "FIXEDCASE" "LITERAL"))
(defun xah-convert-fullwidth-chars (@begin @end &optional @to-direction)
  "Convert ASCII chars to/from Unicode fullwidth version.
Works on current line or text selection.

The conversion direction is determined like this: if the command has been repeated, then toggle. Else, always do to-Unicode direction.

If `universal-argument' is called first:

 no C-u → Automatic.
 C-u → to ASCII
 C-u 1 → to ASCII
 C-u 2 → to Unicode

When called in lisp code, @begin @end are region begin/end positions. @to-direction must be any of the following values: 「\"unicode\"」, 「\"ascii\"」, 「\"auto\"」.

See also: `xah-remove-punctuation-trailing-redundant-space'.

URL `http://ergoemacs.org/emacs/elisp_convert_chinese_punctuation.html'
Version 2018-08-02"
  (interactive
   (let ($p1 $p2)
     (if (use-region-p)
         (progn
           (setq $p1 (region-beginning))
           (setq $p2 (region-end)))
       (progn
         (setq $p1 (line-beginning-position))
         (setq $p2 (line-end-position))))
     (list $p1 $p2
           (cond
            ((equal current-prefix-arg nil) "auto")
            ((equal current-prefix-arg '(4)) "ascii")
            ((equal current-prefix-arg 1) "ascii")
            ((equal current-prefix-arg 2) "unicode")
            (t "unicode")))))
  (let* (
         ($ascii-unicode-map
          [
           ["0" "０"] ["1" "１"] ["2" "２"] ["3" "３"] ["4" "４"] ["5" "５"] ["6" "６"] ["7" "７"] ["8" "８"] ["9" "９"]
           ["A" "Ａ"] ["B" "Ｂ"] ["C" "Ｃ"] ["D" "Ｄ"] ["E" "Ｅ"] ["F" "Ｆ"] ["G" "Ｇ"] ["H" "Ｈ"] ["I" "Ｉ"] ["J" "Ｊ"] ["K" "Ｋ"] ["L" "Ｌ"] ["M" "Ｍ"] ["N" "Ｎ"] ["O" "Ｏ"] ["P" "Ｐ"] ["Q" "Ｑ"] ["R" "Ｒ"] ["S" "Ｓ"] ["T" "Ｔ"] ["U" "Ｕ"] ["V" "Ｖ"] ["W" "Ｗ"] ["X" "Ｘ"] ["Y" "Ｙ"] ["Z" "Ｚ"]
           ["a" "ａ"] ["b" "ｂ"] ["c" "ｃ"] ["d" "ｄ"] ["e" "ｅ"] ["f" "ｆ"] ["g" "ｇ"] ["h" "ｈ"] ["i" "ｉ"] ["j" "ｊ"] ["k" "ｋ"] ["l" "ｌ"] ["m" "ｍ"] ["n" "ｎ"] ["o" "ｏ"] ["p" "ｐ"] ["q" "ｑ"] ["r" "ｒ"] ["s" "ｓ"] ["t" "ｔ"] ["u" "ｕ"] ["v" "ｖ"] ["w" "ｗ"] ["x" "ｘ"] ["y" "ｙ"] ["z" "ｚ"]
           ["," "，"] ["." "．"] [":" "："] [";" "；"] ["!" "！"] ["?" "？"] ["\"" "＂"] ["'" "＇"] ["`" "｀"] ["^" "＾"] ["~" "～"] ["¯" "￣"] ["_" "＿"]
           [" " "　"]
           ["&" "＆"] ["@" "＠"] ["#" "＃"] ["%" "％"] ["+" "＋"] ["-" "－"] ["*" "＊"] ["=" "＝"] ["<" "＜"] [">" "＞"] ["(" "（"] [")" "）"] ["[" "［"] ["]" "］"] ["{" "｛"] ["}" "｝"] ["(" "｟"] [")" "｠"] ["|" "｜"] ["¦" "￤"] ["/" "／"] ["\\" "＼"] ["¬" "￢"] ["$" "＄"] ["£" "￡"] ["¢" "￠"] ["₩" "￦"] ["¥" "￥"]
           ]
          )
         ($reverse-map
          (mapcar
           (lambda (x) (vector (elt x 1) (elt x 0)))
           $ascii-unicode-map))

         ($stateBefore
          (if (get 'xah-convert-fullwidth-chars 'state)
              (get 'xah-convert-fullwidth-chars 'state)
            (progn
              (put 'xah-convert-fullwidth-chars 'state 0)
              0
              )))
         ($stateAfter (if (eq $stateBefore 0) 1 0 )))

                                        ;"０\\|１\\|２\\|３\\|４\\|５\\|６\\|７\\|８\\|９\\|Ａ\\|Ｂ\\|Ｃ\\|Ｄ\\|Ｅ\\|Ｆ\\|Ｇ\\|Ｈ\\|Ｉ\\|Ｊ\\|Ｋ\\|Ｌ\\|Ｍ\\|Ｎ\\|Ｏ\\|Ｐ\\|Ｑ\\|Ｒ\\|Ｓ\\|Ｔ\\|Ｕ\\|Ｖ\\|Ｗ\\|Ｘ\\|Ｙ\\|Ｚ\\|ａ\\|ｂ\\|ｃ\\|ｄ\\|ｅ\\|ｆ\\|ｇ\\|ｈ\\|ｉ\\|ｊ\\|ｋ\\|ｌ\\|ｍ\\|ｎ\\|ｏ\\|ｐ\\|ｑ\\|ｒ\\|ｓ\\|ｔ\\|ｕ\\|ｖ\\|ｗ\\|ｘ\\|ｙ\\|ｚ"

    ;; (message "before %s" $stateBefore)
    ;; (message "after %s" $stateAfter)
    ;; (message "@to-direction %s" @to-direction)
    ;; (message "real-this-command  %s" real-this-command)
    ;; (message "real-last-command %s" real-last-command)
    ;; (message "this-command  %s" this-command)
    ;; (message "last-command %s" last-command)

    (let ((case-fold-search nil))
      (xah-replace-pairs-region
       @begin @end
       (cond
        ((string= @to-direction "unicode") $ascii-unicode-map)
        ((string= @to-direction "ascii") $reverse-map)
        ((string= @to-direction "auto")
         (if (eq $stateBefore 0)
             $reverse-map
           $ascii-unicode-map )

         ;; 2018-08-02 this doesn't work when using smex
         ;; (if (eq last-command this-command)
         ;;     (progn
         ;;       (message "%s" "repeated")
         ;;       (if (eq $stateBefore 0)
         ;;           $reverse-map
         ;;         $ascii-unicode-map ))
         ;;   (progn
         ;;     (message "%s" "not repeated")
         ;;     $ascii-unicode-map))

         ;;

         )
        (t (user-error "Your 3rd argument 「%s」 isn't valid" @to-direction)))
       t t ))
    (put 'xah-convert-fullwidth-chars 'state $stateAfter)))
;; }}}

;; {{{
;; to see @ www.wilkesley.org/~ian/xah/emacs/modernization_fill-paragraph.html
(defun xah-fill-or-unfill ()
  "Reformat current paragraph or region to `fill-column', like `fill-paragraph' or “unfill”.
When there is a text selection, act on the the selection, else, act on a text block separated by blank lines.
URL `http://ergoemacs.org/emacs/modernization_fill-paragraph.html'
Version 2016-07-13"
  (interactive)
  ;; This command symbol has a property “'compact-p”, the possible values are t and nil. This property is used to easily determine whether to compact or uncompact, when this command is called again
  (let ( (-compact-p
          (if (eq last-command this-command)
              (get this-command 'compact-p)
            (> (- (line-end-position) (line-beginning-position)) fill-column)))
         (deactivate-mark nil)
         (-blanks-regex "\n[ \t]*\n")
         -p1 -p2
         )
    (if (use-region-p)
        (progn (setq -p1 (region-beginning))
               (setq -p2 (region-end)))
      (save-excursion
        (if (re-search-backward -blanks-regex nil "NOERROR")
            (progn (re-search-forward -blanks-regex)
                   (setq -p1 (point)))
          (setq -p1 (point)))
        (if (re-search-forward -blanks-regex nil "NOERROR")
            (progn (re-search-backward -blanks-regex)
                   (setq -p2 (point)))
          (setq -p2 (point)))))
    (if -compact-p
        (fill-region -p1 -p2)
      (let ((fill-column most-positive-fixnum ))
        (fill-region -p1 -p2)))
    (put this-command 'compact-p (not -compact-p))))

;; Handy key definition
(define-key global-map "\C-\M-Q" 'xah-fill-or-unfill)
;; }}}

;; execture
(add-to-list 'load-path "/home/fg/.emacs.d/private/execute")
(require 'execute)

;; auto copy
;; to see @ https://emacs.stackexchange.com/questions/17170/how-to-auto-copy-when-a-region-is-selected
;; also see @ https://emacs-china.org/t/emacs/10314/3
(setq mouse-drag-copy-region t)

(provide 'fg-tools)
;;; fg-tools.el ends here

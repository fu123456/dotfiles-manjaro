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

(provide 'fg-tools)

;;; fg-tools.el ends here

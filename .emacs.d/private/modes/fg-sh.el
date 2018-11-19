(defun sh-single-file-compile ()
  (interactive)
  (save-buffer)
  (compile
   (concat "bash " (buffer-file-name))
   ))

(add-hook 'sh-mode-hook (lambda () (local-set-key "\C-c\C-c" 'sh-single-file-compile)))

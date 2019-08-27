(defun cpp-single-file-compile ()
  (interactive)
  (save-buffer)
  (compile
   (concat "g++ -g " (buffer-file-name) " -o " (file-name-sans-extension (buffer-file-name)))
   ))

(add-hook 'c++-mode-hook (lambda () (local-set-key "\C-c\C-c" 'cpp-single-file-compile)))

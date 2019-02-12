(require 'blimp)
(add-hook 'image-mode-hook 'blimp-mode)
;; Rotates image 90 degrees when called
(defun fg/blimp-rotate-90()
  (interactive)
  (blimp-add-to-command-stack (list "-rotate" "90"))
  (blimp-execute-command-stack))
(define-key image-mode-map (kbd "R") 'fg/blimp-rotate-90)

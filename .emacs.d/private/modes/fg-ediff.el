;; this config from abo-abo confi
(require 'ediff)
(require 'diff-mode)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-diff-options "--text")
(setq ediff-diff-options "-w --text")

(defun ora-ediff-jk ()
  (define-key ediff-mode-map "j" 'ediff-next-difference)
  (define-key ediff-mode-map "k" 'ediff-previous-difference))

(add-hook 'ediff-keymap-setup-hook #'ora-ediff-jk)

;;;###autoload
(defun ora-ediff-hook ())

;;;###autoload
(defun ora-diff-hook ())

(mapc
 (lambda (k)
   (define-key diff-mode-map k
     `(lambda () (interactive)
         (if (region-active-p)
             (replace-regexp "^." ,k nil
                             (region-beginning)
                             (region-end))
           (insert ,k)))))
 (list " " "-" "+"))

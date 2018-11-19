(add-to-list 'auto-mode-alist '("\\.m\\'" . matlab-mode))
(custom-set-variables
 '(matlab-shell-command-switches '("-nodesktop -nosplash")))
(setq matlab-mode-verify-fix-functions nil)
(eval-after-load "matlab" '(progn
                             (define-key matlab-mode-map (kbd "C-M-i") nil)
                             (define-key matlab-mode-map (kbd "C-j") nil)
                             (define-key matlab-mode-map (kbd "C-h") nil)
                             (define-key matlab-mode-map (kbd "C-k") nil)
                             (define-key matlab-mode-map (kbd "<f6>") 'matlab-run-file)
                             (define-key matlab-mode-map (kbd "C-c C-z") 'ora-matlab-switch-to-shell)
                             ))

;; matlab mode parens highlight,
(defvar default-fill-column 100)
(remove-hook 'matlab-mode-hook 'highlight-numbers-mode)
(remove-hook 'prog-mode-hook 'highlight-numbers-mode)
(turn-on-auto-fill)

;; matlab add hooks
(add-hook 'matlab-mode-hook
          (lambda ()
            (abbrev-mode 1)
            ;;(setq font-lock-maximum-decoration 1)
            (auto-fill-mode 1)
            ;; (mlint-minor-mode 1)
            (rainbow-delimiters-mode 1)
            (smartparens-mode 1)
            (auto-complete-mode 1)
            ;; (ggtags-mode 1)
            ;; (org-toggle-latex-fragment)
            (if (eq window-system 'x)
                (font-lock-mode 1))
            ))

(defun ora-matlab-switch-to-shell ()
  (interactive)
  (let ((wnd (cl-find-if (lambda (w) (string= "*MATLAB*" (buffer-name (window-buffer w))))
                         (window-list))))
    (if wnd
        (select-window wnd)
      (other-window 1)
      (matlab-shell))))

(defun matlab-run-file ()
  (interactive)
  (let ((buffer (current-buffer))
        (dir default-directory))
    (unless (matlab-shell-active-p)
      (matlab-shell))
    (switch-to-buffer buffer)
    (save-window-excursion
      (switch-to-buffer (concat "*" matlab-shell-buffer-name "*"))
      (matlab-shell-send-string (format "cd %s;\n"
                                        dir)))
    (matlab-shell-save-and-go)))


(setq matlab-fill-code nil)

;; ;; hydra for mlint
;; (defhydra hydra-mlint (:color pink :hint nil)
;;   "
;;  _k_: previous   _f_: fix
;;  _j_: next       _m_: mlint
;; "
;;   ("k" mlint-prev-buffer)
;;   ("j" mlint-next-buffer)
;;   ("f" mlint-fix-warning)
;;   ("m" mlint-buffer)
;;   ("q" nil :color blue))

(provide 'fg-matlab)

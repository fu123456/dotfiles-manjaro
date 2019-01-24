;; {{{ symbol-overlay config
;; to see @ https://github.com/wolray/symbol-overlay
(require 'symbol-overlay)
(global-set-key (kbd "M-i") nil)
(global-set-key (kbd "M-i") 'symbol-overlay-put)
(global-set-key (kbd "M-n") 'symbol-overlay-switch-forward)
(global-set-key (kbd "M-p") 'symbol-overlay-switch-backward)
(global-set-key (kbd "M-[") 'symbol-overlay-mode)
(global-set-key (kbd "M-]") 'symbol-overlay-remove-all)
;; to see @ https://emacs-china.org/t/package-symbol-overlay-symbol/7706/3
;; 添加跳转到 first 和 last的功能
(defun symbol-overlay-switch-first ()
  (interactive)
  (let* ((symbol (symbol-overlay-get-symbol))
         (keyword (symbol-overlay-assoc symbol))
         (a-symbol (car keyword))
         (before (symbol-overlay-get-list a-symbol 'car))
         (count (length before)))
    (symbol-overlay-jump-call 'symbol-overlay-basic-jump (- count))))

(defun symbol-overlay-switch-last ()
  (interactive)
  (let* ((symbol (symbol-overlay-get-symbol))
         (keyword (symbol-overlay-assoc symbol))
         (a-symbol (car keyword))
         (after (symbol-overlay-get-list a-symbol 'cdr))
         (count (length after)))
    (symbol-overlay-jump-call 'symbol-overlay-basic-jump (- count 1))))

(define-key symbol-overlay-map (kbd "<") 'symbol-overlay-switch-first)
(define-key symbol-overlay-map (kbd ">") 'symbol-overlay-switch-last)
;; }}}

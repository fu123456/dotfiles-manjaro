(require 'vlf-setup)
(eval-after-load "vlf"
  '(define-key vlf-prefix-map "\C-xv" vlf-mode-map))
(custom-set-variables
 '(vlf-application 'dont-ask))

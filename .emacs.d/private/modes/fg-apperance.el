;; set default window size
(if (display-graphic-p)
    (progn
      (setq initial-frame-alist
            '(
              (tool-bar-lines . 0)
              (width . 82) ; chars
              (height . 38) ; lines
              ;;
              ))

      (setq default-frame-alist
            '(
              (tool-bar-lines . 0)
              (width . 82)
              (height . 38)
              ;;
              )))
  (progn
    (setq initial-frame-alist
          '(
            (tool-bar-lines . 0)))
    (setq default-frame-alist
          '(
            (tool-bar-lines . 0)))))

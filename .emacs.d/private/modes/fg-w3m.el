;; {{{
(with-eval-after-load 'w3m
  (define-key w3m-mode-map (kbd "C-c w e") 'w3m-bookmark-edit)
  (define-key w3m-mode-map (kbd "C-c w a") 'w3m-bookmark-add-current-url)
  (define-key w3m-mode-map (kbd "C-c w b") 'helm-w3m-bookmarks)
  (define-key w3m-mode-map (kbd "C-c w B") 'w3m-bookmark-view)
  (define-key w3m-mode-map (kbd "C-c w h") 'w3m-gohome)
  (define-key w3m-mode-map (kbd "C-c w c") 'v/w3m-copy-link)
  (define-key w3m-mode-map (kbd "C-c C-u o") 'w3m-view-url-with-external-browser)
  (define-key w3m-mode-map (kbd "C-f") 'evil-scroll-page-down)
  (define-key w3m-mode-map (kbd "C-b") 'evil-scroll-page-up)
  (define-key w3m-mode-map (kbd "SPC") 'evil-evilified-state))

(defun v/w3m-copy-link ()
  (interactive)
  (let ((link (w3m-anchor)))
    (if (not link)
        (message "The point is not link.")
      (kill-new link)
      (message "Copy \"%s\" to clipboard." link))))

;; to see @  https://github.com/venmos/w3m-layer/blob/master/READMECN.org
(setq w3m-home-page "https://baidu.com/")
;; W3M Home Page
(setq w3m-default-display-inline-images t)
(setq w3m-default-toggle-inline-images t)
;; W3M default display images
(setq w3m-command-arguments '("-cookie" "-F"))
(setq w3m-use-cookies t)
;; W3M use cookies
(setq browse-url-browser-function 'w3m-browse-url)
;; Browse url function use w3m
(setq w3m-view-this-url-new-session-in-background t)
;; W3M view url new session in background

;; Emacs w3m: Open pages in external browsers
;; to see @ http://sachachua.com/blog/2008/09/emacs-w3m-open-pages-in-external-browsers/
(defun wicked/w3m-open-current-page-in-firefox ()
  "Open the current URL in Mozilla Firefox."
  (interactive)
  (browse-url-firefox w3m-current-url)) ;; (1)

(defun wicked/w3m-open-link-or-image-in-firefox ()
  "Open the current link or image in Firefox."
  (interactive)
  (browse-url-firefox (or (w3m-anchor) ;; (2)
                          (w3m-image)))) ;; (3)

(with-eval-after-load 'w3m
  (define-key w3m-mode-map (kbd "C-c w f") 'wicked/w3m-open-current-page-in-firefox)
  (define-key w3m-mode-map (kbd "C-c w F") 'wicked/w3m-open-link-or-image-in-firefox))


;; }}}

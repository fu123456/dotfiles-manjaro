(setq browse-url-browser-function 'browse-url-generic
      engine/browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome-stable")
(evil-leader/set-key (kbd "s/") 'spacemacs/search-engine-select)
(provide 'fg-search-engine)

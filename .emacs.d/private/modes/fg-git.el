(require 'git-timemachine)
;; git-timestamp setting using hydra
(defhydra hydra-git-timestmap (:body-pre (git-timemachine-toggle)
                                         :post (git-timemachine-quit)
                                         :color pink :hint nil)
  "
^Git-timstamp^
_p_revious
_n_ext
_e_xit
"
  ("p" git-timemachine-show-previous-revision)
  ("n" git-timemachine-show-next-revision)
  ("e" git-timemachine-quit)
  ;; quit
  ("q" nil "cancel"))
(define-key evil-normal-state-map (kbd "<SPC>mm") 'hydra-git-timestmap/body)

(provide 'fg-git)
;; fg-git.el ends here

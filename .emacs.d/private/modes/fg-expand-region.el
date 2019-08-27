(require 'expand-region)
(eval-after-load "evil" '(setq expand-region-contract-fast-key "z"))
(evil-leader/set-key "xx" 'er/expand-region)

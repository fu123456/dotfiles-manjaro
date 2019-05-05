;; {{{ goldendict
(require 'goldendict)
;; (global-set-key (kbd "C-c C-g") 'goldendict-dwim)
;; please note that Goldendict default hotkey for search
(evil-leader/set-key (kbd "og") 'goldendict-dwim)
;; }}}

;; {{{ youdao
;; to see @ https://github.com/xuchunyang/youdao-dictionary.el
(add-to-list 'load-path "/home/fg/MEGA/dotfiles-manjaro/.emacs.d/private/myPackages/youdao-dictionary.el/")
(require 'youdao-dictionary)

;; Enable Cache
(setq url-automatic-caching t)

;; Key binding
(evil-leader/set-key (kbd "oo") 'youdao-dictionary-search-at-point)

;; Integrate with popwin-el (https://github.com/m2ym/popwin-el)
(push "*Youdao Dictionary*" popwin:special-display-config)

;; Set file path for saving search history
(setq youdao-dictionary-search-history-file "~/.emacs.d/.youdao")

;; Enable Chinese word segmentation support (支持中文分词)
(setq youdao-dictionary-use-chinese-word-segmentation t)
;; }}}

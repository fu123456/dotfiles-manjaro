;;{{{ Chinese input method, pyim
(require 'pyim)
;; (require 'pyim-basedict) ; 拼音词库设置，五笔用户 *不需要* 此行设置
;; (pyim-basedict-enable)   ; 拼音词库，五笔用户 *不需要* 此行设置
(setq default-input-method "pyim")
(use-package pyim
  :ensure nil
  :demand t
  :config
  ;; 激活 basedict 拼音词库
  (use-package pyim-basedict
    :ensure nil
    :config (pyim-basedict-enable))

  ;; 五笔用户使用 wbdict 词库
  ;; (use-package pyim-wbdict
  ;;   :ensure nil
  ;;   :config (pyim-wbdict-gbk-enable))

  (setq default-input-method "pyim")

  ;; 我使用全拼
  (setq pyim-default-scheme 'quanpin)

  ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换 :-)
  ;; 我自己使用的中英文动态切换规则是：
  ;; 1. 光标只有在注释里面时，才可以输入中文。
  ;; 2. 光标前是汉字字符时，才能输入中文。
  ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-evil-normal-mode
                  pyim-probe-org-structure-template))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

  ;; (setq pyim-punctuation-translate-p '(yes no auto))   ;使用全角标点。
  (setq pyim-punctuation-translate-p '(no yes auto))   ;使用半角标点。
  ;; (setq pyim-punctuation-translate-p '(auto yes no))   ;中文使用全角标点，英文使用半角标点。

  ;; 开启拼音搜索功能
  (pyim-isearch-mode 1)

  ;; 选词框显示5个候选词
  (setq pyim-page-length 5)

  ;; 让 Emacs 启动时自动加载 pyim 词库
  (add-hook 'emacs-startup-hook
            #'(lambda () (pyim-restart-1 t)))
  :bind
  (("C-c y" . pyim-convert-code-at-point) ;与 pyim-probe-dynamic-english 配合
   ("C-;" . pyim-delete-word-from-personal-buffer)))

(setq pyim-dicts
      '((:name "dict1" :file "/home/fg/MEGA/dotfiles-manjaro/.emacs.d/pyim-bigdict.pyim.gz")
        ))

(require 'pyim)
(defun eh-company-dabbrev--prefix (orig-fun)
  "取消中文补全"
  (let ((string (pyim-char-before-to-string 0)))
    (if (pyim-string-match-p "\\cc" string)
        nil
      (funcall orig-fun))))
(advice-add 'company-dabbrev--prefix :around #'eh-company-dabbrev--prefix)
;;}}}

;; (use-package liberime
;;   :load-path "/home/fg/Install/liberime-master/liberime-master/build/liberime.so"
;;   :config
;;   ;; 注意事项:
;;   ;; 1. 文件路径需要用 `expand-file-name' 函数处理。
;;   ;; 2. `librime-start' 的第一个参数说明 "rime 共享数据文件夹"
;;   ;;     的位置，不同的平台其位置也各不相同，可以参考：
;;   ;;     https://github.com/rime/home/wiki/RimeWithSchemata
;;   (liberime-start (expand-file-name "/usr/share/rime-data")
;;                   (expand-file-name "~/.emacs.d/pyim/rime/"))
;;   (liberime-select-schema "luna_pinyin_simp")
;;   (setq pyim-default-scheme 'rime))
;; (setq pyim-default-scheme 'rime-quanpin)

;; {{{ using posframe
;; 使用 pupup-el 来绘制选词框, 如果用 emacs26, 建议设置
;; 为 'posframe, 速度很快并且菜单不会变形，不过需要用户
;; 手动安装 posframe 包。
(add-to-list 'load-path "/home/fg/MEGA/dotfiles-manjaro/.emacs.d/private/myPackages/posframe")
(require 'posframe)
(setq pyim-page-tooltip 'posframe)
;; }}}


;; {{{ cnfonts
(use-package cnfonts
  :demand t
  :if (display-graphic-p)
  :init (setq cnfonts-verbose nil)
  :config
  (setq cnfonts-use-face-font-rescale
        (eq system-type 'gnu/linux))
  (cnfonts-enable)
  ;; :bind (("C--" . cnfonts-decrease-fontsize)
  ;;        ("C-=" . cnfonts-increase-fontsize)
  ;;        ("C-+" . cnfonts-next-profile))
  )
                                        ;;; }}}

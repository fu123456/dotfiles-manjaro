;; (require 'org)
;; (let ((current-prefix-arg 1))
;;   (call-interactively 'org-reload))

;; org-habit config
(add-to-list 'org-modules 'org-habit)

;; org-protocal
(require 'org-protocol)

;;*keys
;;** org-mode-map
(define-key org-mode-map (kbd "C-h") nil)
(global-set-key (kbd"C-c v") 'hydra-org-agenda-view/body)
(add-hook 'org-mode-hook (lambda ()
                           (flyspell-mode 1)
                           (auto-fill-mode 1)
                           ))
  ;;;;;;;;;;;;;;;;;;;;;;
;;zilongshanren gtd setting
(defun dotspacemacs/user-config ()
  "Configuration function for user code.
  This function is called at the very end of Spacemacs initialization after
  layers configuration.
  This is the place where most of your configurations should be done. Unless it is
  explicitly specified that a variable should be set before a package is loaded,
  you should place your code here."
  (setq tramp-ssh-controlmaster-options
        "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no")
  ;; define the refile targets
  (defvar org-agenda-dir "" "gtd org files location")
  (setq-default org-agenda-dir "~/MEGA/org")
  (setq org-agenda-file-bookmark (expand-file-name "bookmark.org" org-agenda-dir))
  (setq org-agenda-file-code (expand-file-name "codes.org" org-agenda-dir))
  (setq org-agenda-file-gtd (expand-file-name "gtd.org" org-agenda-dir))
  (setq org-agenda-file-paper (expand-file-name "paper.org" org-agenda-dir))
  (setq org-agenda-file-journal (expand-file-name "journal.org" org-agenda-dir))
  (setq org-agenda-file-gym (expand-file-name "gym.org" org-agenda-dir))
  (setq org-agenda-file-code-snippet (expand-file-name "snippet.org" org-agenda-dir))
  (setq org-default-notes-file (expand-file-name "gtd.org" org-agenda-dir))
  (setq org-agenda-file-internet (expand-file-name "surfInternet.org" org-agenda-dir))
  (setq org-agenda-files (list org-agenda-dir))

  (with-eval-after-load 'org-agenda
    (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro)
    (spacemacs/set-leader-keys-for-major-mode 'org-agenda-mode
      "." 'spacemacs/org-agenda-transient-state/body)
    )
  ;; the %i would copy the selected text into the template
  ;;http://www.howardism.org/Technical/Emacs/journaling-org.html
  ;;add multi-file journal
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline org-agenda-file-gtd "Workspace")
           "* TODO [#A] %?\n  %i\n"
           :empty-lines 1)
          ("a" "Paper" entry (file+headline org-agenda-file-paper "Paper")
           "* TODO [#B] %?\n %i\n %U"
           :empty-lines 1)
          ("b" "Bookmars" entry (file+headline org-agenda-file-bookmark "Bookmarks")
           "* %?\n   %i\n %i\n %U"
           :empty-lines 1)
          ("c" "Codes" entry (file+headline org-agenda-file-code "Codes")
           "* %?\n %i\n | code name, dir     |        |\n  | archieve package   |       |\n  | description        |       |\n  | code download link |       |\n  | project url        |       |\n\n %U"
           :empty-lines 1)
          ("i" "surfInternet" entry (file+headline org-agenda-file-internet "surfInternet")
           "* %?\n  %i\n %U"
           :empty-lines 1)
          ("s" "Code Snippet" entry
           (file org-agenda-file-code-snippet)
           "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
          ("p" "Protocol" entry (file+headline org-agenda-file-bookmark "Bookmarks")
           "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%? %U"
           :empty-lines 1)
          ("L" "Protocol Link" entry (file+headline org-agenda-file-bookmark "Bookmarks")
           "* %? [[%:link][%:description]] \nCaptured On: %U"
           :empty-lines 1)
          ))

  ;;An entry without a cookie is treated just like priority ' B '.
  ;;So when create new task, they are default 重要且紧急
  (setq org-agenda-custom-commands
        '(
          ("w" . "任务安排")
          ("wa" "重要且紧急的任务" tags-todo "+PRIORITY=\"A\"")

          ("wb" "重要且不紧急的任务" tags-todo "-Weekly-Monthly-Daily+PRIORITY=\"B\"")
          ("wc" "不重要且紧急的任务" tags-todo "+PRIORITY=\"C\"")
          ("b" "Blog" tags-todo "BLOG")
          ("p" . "项目安排")
          ("pw" tags-todo "PROJECT+WORK+CATEGORY=\"Papers\"")
          ;; ("pl" tags-todo "PROJECT+DREAM+CATEGORY=\"zilongshanren\"")
          ("W" "Weekly Review"
           ((stuck "") ;; review stuck projects as designated by org-stuck-projects
            (tags-todo "PROJECT") ;; review all projects (assuming you use todo keywords to designate projects)
            ))))
  )

;; 完成全部子任务时父任务自动完成
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)  ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook'org-after-todo-statistics-hook 'org-summary-todo)

;; todo keywords
(setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;start;;;;;;;;;;;;;;;;;;;;;
;; org ref setting; reftex setting
(setq reftex-default-bibliography '("/home/fg/MEGA/org/references.bib"))
;; 关闭\ref \pageref 的选择，^M代表Ctrl-m
(setq reftex-ref-macro-prompt nil)
(setq reftex-cite-format 'natbib) ;; set reftex cite format

;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "/home/fg/MEGA/org/refnotes.org"
      org-ref-default-bibliography '("/home/fg/MEGA/bibtex-pdfs/bib/references.bib")
      org-ref-pdf-directory "/home/fg/MEGA/bibtex-pdfs")
(require 'org-ref)

;; alternative
(setq bibtex-completion-pdf-open-function 'org-open-file)

;; org mode open pdf file link using pdf-tools
(eval-after-load 'org '(require 'org-pdfview))
(add-to-list 'org-file-apps '("\\.pdf\\'" . (lambda (file link) (org-pdfview-open link))))
(add-to-list 'org-file-apps '("\\.pdf::\\([[:digit:]]+\\)\\'" . (lambda (file link) (org-pdfview-open link))))
(setq org-file-apps
      '((auto-mode . emacs)
        ("\\.mp4\\'" . "mplayer \"%s\"")
        ("\\.mkv" . "mplayer \"%s\"")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; org mode, tags setting
;; (setq org-tag-alist '(("@singleimage" . ?s) ("@multiimages" . ?m) ("@withdepthcues" . ?w) ("@video" . ?v)))

;; 存盘前删除行末多余的空格/空行
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; {{{ org screenshot config
;; to see @ https://emacs-china.org/t/org-mode/79
;; to see @ https://blog.csdn.net/u011729865/article/details/52628417
(defun my-org-screenshot ()
  "Take a screenshot into a unique-named file in the current buffer file
: directory and insert a link to this file."
  (interactive)
  (setq filename
        (concat
         (make-temp-name
          (concat (file-name-nondirectory (buffer-file-name))
                  "_imgs/"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (unless (file-exists-p (file-name-directory filename))
    (make-directory (file-name-directory filename)))
  (call-process-shell-command "scrot" nil nil nil nil "-s" (concat
                                                            "\"" filename "\"" ))
  (insert (concat "[[" filename "]]"))
  (org-display-inline-images)
  )
(global-set-key (kbd "C-c s c") 'my-org-screenshot)
;; }}}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;在org-mode文件里面执行其他语言片段
(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (ruby . t)
     (matlab . t)
     (octave . t)
     (dot . t)
     (ditaa . t)
     (python . t)
     (shell . t)
     (latex . t)
     (plantuml . t)
     (R . t))))

;; org-ref 参考文献关键字的设定
;; variables that control bibtex key format for auto-generation
;; I want firstauthor-year-title-words
;; this usually makes a legitimate filename to store pdfs under.

(setq bibtex-autokey-year-length 4
      bibtex-autokey-name-year-separator "-"
      bibtex-autokey-year-title-separator "-"
      bibtex-autokey-titleword-separator "-"
      bibtex-autokey-titlewords 2
      bibtex-autokey-titlewords-stretch 1
      bibtex-autokey-titleword-length 5)

;; 加密文章
;; "http://coldnew.github.io/blog/2013/07/13_5b094.html"
;; org-mode 設定
(require 'org-crypt)
;; 當被加密的部份要存入硬碟時，自動加密回去
(org-crypt-use-before-save-magic)
;; 設定要加密的 tag 標籤為 secret
(setq org-crypt-tag-matcher "secret")
;; 避免 secret 這個 tag 被子項目繼承 造成重複加密
;; (但是子項目還是會被加密喔)
(setq org-tags-exclude-from-inheritance (quote ("secret")))
;; 用於加密的 GPG 金鑰
;; 可以設定任何 ID 或是設成 nil 來使用對稱式加密 (symmetric encryption)
(setq org-crypt-key nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode convert to pdf file for Chinese file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ox-publish)
(add-to-list 'org-latex-classes '("ctexart" "\\documentclass[11pt]{ctexart}
                                        [NO-DEFAULT-PACKAGES]
                                        \\usepackage[utf8]{inputenc}
                                        \\usepackage[T1]{fontenc}
                                        \\usepackage{fixltx2e}
                                        \\usepackage{graphicx}
                                        \\usepackage{longtable}
                                        \\usepackage{float}
                                        \\usepackage{wrapfig}
                                        \\usepackage{rotating}
                                        \\usepackage[normalem]{ulem}
                                        \\usepackage{amsmath}
                                        \\usepackage{textcomp}
                                        \\usepackage{marvosym}
                                        \\usepackage{wasysym}
                                        \\usepackage{amssymb}
                                        \\usepackage{booktabs}
                                        \\usepackage[colorlinks,linkcolor=black,anchorcolor=black,citecolor=black]{hyperref}
                                        \\tolerance=1000
                                        \\usepackage{listings}
                                        \\usepackage{xcolor}
                                        \\lstset{
                                        %行号
                                        numbers=left,
                                        %背景框
                                        framexleftmargin=10mm,
                                        frame=none,
                                        %背景色
                                        %backgroundcolor=\\color[rgb]{1,1,0.76},
                                        backgroundcolor=\\color[RGB]{245,245,244},
                                        %样式
                                        keywordstyle=\\bf\\color{blue},
                                        identifierstyle=\\bf,
                                        numberstyle=\\color[RGB]{0,192,192},
                                        commentstyle=\\it\\color[RGB]{0,96,96},
                                        stringstyle=\\rmfamily\\slshape\\color[RGB]{128,0,0},
                                        %显示空格
                                        showstringspaces=false
                                        }
                                        "
                                  ("\\section{%s}" . "\\section*{%s}")
                                  ("\\subsection{%s}" . "\\subsection*{%s}")
                                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                                  ("\\paragraph{%s}" . "\\paragraph*{%s}")
                                  ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; {{ export org-mode in Chinese into PDF
;; @see http://freizl.github.io/posts/tech/2012-04-06-export-orgmode-file-in-Chinese.html
;; and you need install texlive-xetex on different platforms
;; To install texlive-xetex:
;;    `sudo USE="cjk" emerge texlive-xetex` on Gentoo Linux
;; }}
(setq org-latex-default-class "ctexart")
(setq org-latex-pdf-process
      '(
        "xelatex --synctex=1  -interaction nonstopmode -output-directory %o %f"
        "bibtex %b"
        "xelatex --synctex=1 -interaction nonstopmode -output-directory %o %f"
        "xelatex --synctex=1 -interaction nonstopmode -output-directory %o %f"
        "rm -fr %b.out %b.log auto"))
;; (setq org-latex-pdf-process
;;       '(
;;         "xelatex --synctex=1  -interaction nonstopmode -output-directory %o %f"))
;; "rm -fr %b.out %b.log %b.tex auto"));;删除tex文件

(setq org-latex-listings t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'org-mode-hook 'auto-complete-mode)

;; by chenbin
;; How to take screen shot for business people efficiently in Emacs
;; 在org文件中自动插入screen shot image
(defun insert-file-link-from-clipboard ()
  "Make sure the full path of file exist in clipboard. This command will convert
The full path into relative path and insert it as a local file link in org-mode"
  (interactive)
  (let (str)
    (with-temp-buffer
      (shell-command
       (cond
        ((eq system-type 'cygwin) "getclip")
        ((eq system-type 'darwin) "pbpaste")
        (t "xsel -ob"))
       1)
      (setq str (buffer-string)))

    ;; convert to relative path (relative to current buffer) if possible
    (let ((m (string-match (file-name-directory (buffer-file-name)) str) ))
      (when m
        (if (= 0 m )
            (setq str (substring str (length (file-name-directory (buffer-file-name)))))
          ))
      (insert (format "[[file:%s]]" str)))
    ))
(define-key org-mode-map (kbd "C-k") 'insert-file-link-from-clipboard)

;;{{{ org -> docx
;; org v7 bundled with Emacs 24.3
(setq org-export-odt-preferred-output-format "doc")
;; org v8 bundled with Emacs 24.4
(setq org-odt-preferred-output-format "doc")
(setq org-odt-convert-processes '(("LibreOffice" "/usr/bin/libreoffice --headless --convert-to %f%x --outdir %d %i")))
;;}}}

;; highlight latex text in org file:
(setq org-highlight-latex-and-related '(latex script entities))

;; org download
(require 'org-download)
(org-download-enable)

;; org mode export latex math preview
(require 'org)
;; ;; lualatex preview
;; (setq org-latex-pdf-process
;;       '("lualatex -shell-escape -interaction nonstopmode %f"
;;         "lualatex -shell-escape -interaction nonstopmode %f"))
(setq luamagick '(luamagick :programs ("lualatex" "convert")
                            :description "pdf > png"
                            :message "you need to install lualatex and imagemagick."
                            :use-xcolor t
                            :image-input-type "pdf"
                            :image-output-type "png"
                            :image-size-adjust (1.0 . 1.0)
                            :latex-compiler ("lualatex -interaction nonstopmode -output-directory %o %f")
                            :image-converter ("convert -density %D -trim -antialias %f -quality 100 %O")))
(add-to-list 'org-preview-latex-process-alist luamagick)
(setq org-preview-latex-default-process 'luamagick)

;; archieve DONE and CANCELLED to a file
(defun fg/org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from
           (outline-previous-heading)))
   "/DONE" 'file))
(defun fg/org-archive-cancel-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from
           (outline-previous-heading)))
   "/CANCELLED" 'file))

(defun org-agenda-cts ()
  (and (eq major-mode 'org-agenda-mode)
       (let ((args (get-text-property
                    (min (1- (point-max)) (point))
                    'org-last-args)))
         (nth 2 args))))
(defhydra hydra-org-agenda-view (:hint none)
  "
_d_: ?d? day        _g_: time grid=?g?  _a_: arch-trees
_w_: ?w? week       _[_: inactive       _A_: arch-files
_t_: ?t? fortnight  _f_: follow=?f?     _r_: clock report=?r?
_m_: ?m? month      _e_: entry text=?e? _D_: include diary=?D?
_y_: ?y? year       _q_: quit           _L__l__c_: log = ?l?"
  ("SPC" org-agenda-reset-view)
  ("D" org-agenda-day-view (if (eq 'day (org-agenda-cts)) "[x]" "[ ]") :exit t)
  ("d" (org-agenda nil "d") (if (eq 'day (org-agenda-cts)) "[x]" "[ ]") :exit t)
  ("w" (org-agenda nil "w") (if (eq 'week (org-agenda-cts)) "[x]" "[ ]") :exit t)
  ("t" org-agenda-fortnight-view (if (eq 'fortnight (org-agenda-cts)) "[x]" "[ ]") :exit t)
  ("m" org-agenda-month-view (if (eq 'month (org-agenda-cts)) "[x]" "[ ]") :exit t)
  ("y" org-agenda-year-view (if (eq 'year (org-agenda-cts)) "[x]" "[ ]") :exit t)
  ("l" org-agenda-log-mode (format "% -3S" org-agenda-show-log))
  ("L" (org-agenda-log-mode '(4)))
  ("c" (org-agenda-log-mode 'clockcheck))
  ("f" org-agenda-follow-mode (format "% -3S" org-agenda-follow-mode))
  ("a" org-agenda-archives-mode)
  ("A" (org-agenda-archives-mode 'files))
  ("r" org-agenda-clockreport-mode (format "% -3S" org-agenda-clockreport-mode))
  ("e" org-agenda-entry-text-mode (format "% -3S" org-agenda-entry-text-mode))
  ("g" org-agenda-toggle-time-grid (format "% -3S" org-agenda-use-time-grid))
  ("D" org-agenda-toggle-diary (format "% -3S" org-agenda-include-diary))
  ("!" org-agenda-toggle-deadlines)
  ("[" (let ((org-agenda-include-inactive-timestamps t))
         (org-agenda-check-type t 'timeline 'agenda)
         (org-agenda-redo)
         (message "Display now includes inactive timestamps as well")))
  ("q" (message "Abort") :exit t)
  ("x" org-agenda-exit :exit t)
  ("v" nil))

;; {{{ drag and drop image
;; see @ http://kitchingroup.cheme.cmu.edu/blog/2015/07/10/Drag-images-and-files-onto-org-mode-and-insert-a-link-to-them/
(defun my-dnd-func (event)
  (interactive "e")
  (goto-char (nth 1 (event-start event)))
  (x-focus-frame nil)
  (let* ((payload (car (last event)))
         (type (car payload))
         (fname (cadr payload))
         (img-regexp "\\(png\\|jp[e]?g\\)\\>"))
    (cond
     ;; insert image link
     ((and  (eq 'drag-n-drop (car event))
            (eq 'file type)
            (string-match img-regexp fname))
      (insert (format "[[%s]]" fname))
      (org-display-inline-images t t))
     ;; insert image link with caption
     ((and  (eq 'C-drag-n-drop (car event))
            (eq 'file type)
            (string-match img-regexp fname))
      (insert "#+ATTR_ORG: :width 300\n")
      (insert (concat  "#+CAPTION: " (read-input "Caption: ") "\n"))
      (insert (format "[[%s]]" fname))
      (org-display-inline-images t t))
     ;; C-drag-n-drop to open a file
     ((and  (eq 'C-drag-n-drop (car event))
            (eq 'file type))
      (find-file fname))
     ((and (eq 'M-drag-n-drop (car event))
           (eq 'file type))
      (insert (format "[[attachfile:%s]]" fname)))
     ;; regular drag and drop on file
     ((eq 'file type)
      (insert (format "[[%s]]\n" fname)))
     (t
      (error "I am not equipped for dnd on %s" payload)))))


(define-key org-mode-map (kbd "<drag-n-drop>") 'my-dnd-func)
(define-key org-mode-map (kbd "<C-drag-n-drop>") 'my-dnd-func)
(define-key org-mode-map (kbd "<M-drag-n-drop>") 'my-dnd-func)
;; }}}

(provide 'fg-org)

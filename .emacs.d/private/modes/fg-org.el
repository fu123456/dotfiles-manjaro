;;*keys
;;** org-mode-map
(define-key org-mode-map (kbd "C-h") nil)

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
  (setq org-agenda-file-note (expand-file-name "notes.org" org-agenda-dir))
  (setq org-agenda-file-code (expand-file-name "codes.org" org-agenda-dir))
  (setq org-agenda-file-gtd (expand-file-name "gtd.org" org-agenda-dir))
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
          ("B" "Bookmars" entry (file+headline org-agenda-file-note "Bookmarks")
           "*  %?\n %i\n %i\n %U"
           :empty-lines 1)
          ("c" "Codes" entry (file+headline org-agenda-file-code "Codes")
           "*  %?\n  | code name, dir     |       |\n  | description        |       |\n  | code download link |       |\n  | project url        |       |\n\n %U"
           :empty-lines 1)
          ("p" "Papers Ideas" entry (file+headline org-agenda-file-note "Papers Ideas")
           "* TODO [#B] %?\n  %i\n %U"
           :empty-lines 1)
          ("i" "surfInternet" entry (file+headline org-agenda-file-internet "surfInternet")
           "* %?\n  %i\n %U"
           :empty-lines 1)
          ("b" "Blog Ideas" entry (file+headline org-agenda-file-note "Blog Ideas")
           "* TODO [#B] %?\n  %i\n %U"
           :empty-lines 1)
          ("s" "Code Snippet" entry
           (file org-agenda-file-code-snippet)
           "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
          ("n" "Quick notes" entry (file+headline org-agenda-file-note "Quick notes")
           "* TODO [#C] %?\n %i\n %i\n %U"
           :empty-lines 1)
          ;; my physical exercise
          ("g" "Physical Exercise" entry (file+headline org-agenda-file-gym "Gym")
           "* TODO [#B] %?\n %i\n"
           :empty-lines 1)
          ("j" "Journal Entry"
           entry (file+datetree org-agenda-file-journal)
           "* %?" :empty-lines 1)))

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
(setq reftex-default-bibliography '("/home/fg/MEGA/sync/org/references.bib"))
;; 关闭\ref \pageref 的选择，^M代表Ctrl-m
(setq reftex-ref-macro-prompt nil)
(setq reftex-cite-format 'natbib) ;; set reftex cite format

;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "/home/fg/MEGA/sync/org/refnotes.org"
      org-ref-default-bibliography '("/home/fg/MEGA/sync/org/references.bib")
      org-ref-pdf-directory "/home/fg/MEGA/sync/org/bibtex-pdfs")
(require 'org-ref)

;; alternative
(setq bibtex-completion-pdf-open-function 'org-open-file)

;; org mode open pdf file link using pdf-tools
(eval-after-load 'org '(require 'org-pdfview))
(add-to-list 'org-file-apps '("\\.pdf\\'" . (lambda (file link) (org-pdfview-open link))))
(add-to-list 'org-file-apps '("\\.pdf::\\([[:digit:]]+\\)\\'" . (lambda (file link) (org-pdfview-open link))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;end;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; org mode, tags setting
;; (setq org-tag-alist '(("@singleimage" . ?s) ("@multiimages" . ?m) ("@withdepthcues" . ?w) ("@video" . ?v)))

;; 存盘前删除行末多余的空格/空行
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; 使用emacs截图插入org-mode文件，并将图片保存在以org文件名
;;开头的“_imgs"的文件夹下，绑定的键位C-c C-s
(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (org-display-inline-images)
  (setq filename
        (concat
         (make-temp-name
          (concat (file-name-nondirectory (buffer-file-name))
                  "_imgs/"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (unless (file-exists-p (file-name-directory filename))
    (make-directory (file-name-directory filename)))
                                        ; take screenshot
  (if (eq system-type 'darwin)
      (progn
        (call-process-shell-command "screencapture" nil nil nil nil " -s " (concat
                                                                            "\"" filename "\"" ))
        (call-process-shell-command "convert" nil nil nil nil (concat "\"" filename "\" -resize  \"50%\"" ) (concat "\"" filename "\"" ))
        ))
  (if (eq system-type 'gnu/linux)
      (call-process "import" nil nil nil filename))
                                        ; insert into file if correctly taken
  (if (file-exists-p filename)
      (insert (concat "[[file:" filename "]]")))
  (org-display-inline-images)
  )

(global-set-key (kbd "C-c s c") 'my-org-screenshot)

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
        "biber %b"
        "xelatex --synctex=1 -interaction nonstopmode -output-directory %o %f"
        "xelatex --synctex=1 -interaction nonstopmode -output-directory %o %f"
        "rm -fr %b.out %b.log auto"))
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

;; This setup is tested on Emacs 24.3 & Emacs 24.4 on Linux/OSX
;; org v7 bundled with Emacs 24.3
(setq org-export-odt-preferred-output-format "doc")
;; org v8 bundled with Emacs 24.4
(setq org-odt-preferred-output-format "doc")
;; BTW, you can assign "pdf" in above variables if you prefer PDF format
;; Run the command "M-x org-export-as-odt".

;; If you need page break in exported document, insert below snippet into the org file:
;; #+ODT: <text:p text:style-name="PageBreak"/>

;; highlight latex text in org file:
(setq org-highlight-latex-and-related '(latex script entities))

;; org download
(require 'org-download)
(org-download-enable)

;; org mode export latex math preview
(require 'org)
;; lualatex preview
(setq org-latex-pdf-process
      '("lualatex -shell-escape -interaction nonstopmode %f"
        "lualatex -shell-escape -interaction nonstopmode %f"))
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

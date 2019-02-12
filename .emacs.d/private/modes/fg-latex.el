;;{{{ dependencies
;; magic-latex-buffer
;; smartparens
;; pdf-tools
;;}}}

;;{{{ magic-latex-buffer
(add-to-list 'load-path "~/.emacs.d/private/myPackages/magic-latex-buffer")
(require 'magic-latex-buffer)
(add-hook 'latex-mode-hook 'magic-latex-buffer)
;; You can disable some features independently, if they’re too fancy.
(setq magic-latex-enable-block-highlight nil
      magic-latex-enable-suscript        t
      magic-latex-enable-pretty-symbols  t
      magic-latex-enable-block-align     nil
      magic-latex-enable-inline-image    nil
      magic-latex-enable-minibuffer-echo nil)
;;}}}

(require 'tex)
(add-hook 'LaTeX-mode-hook (lambda ()
                             (setq font-lock-maximum-decoration 2)
                             (rainbow-delimiters-mode 1)
                             (magic-latex-buffer 1)
                             (aggressive-indent-mode 1)
                             (smartparens-mode 1)
                             (tex-fold-mode 1)
                             (hl-todo-mode 1)
                             ))

;; latex-mode
;; (add-to-list 'ac-modes 'latex-mode)
(defun ac-latex-mode-setup()
  (setq ac-sources (append '(ac-source-yasnippet) ac-sources)))
(add-hook 'latex-mode-hook 'ac-latex-mode-setup)

;; 设定打开PDF文件的软件
(cond
 ((string-equal system-type "darwin")
  (progn (setq TeX-view-program-selection '((output-pdf "pdf-tools")))))
 ((string-equal system-type "gnu/linux")
  (progn (setq TeX-view-program-selection '((output-pdf "pdf-tools"))))))

;; ;; 在tex文件和对应的pdf文件跳转
;; ;; |f6 |tex文档到pdf的跳转, pdf到tex的快捷键C-mouse
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-start-server t)
(setq TeX-source-correlate-method 'synctex)
(setq TeX-view-program-list '(("pdf-tools" "TeX-pdf-tools-sync-view")))
;; (setq TeX-view-program-list
;;       '(("Evince" "evince --unique %o#src:%n%b")
;;         ("Skim" "displayline -b -g %n %o %b")))
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(setq TeX-view-program-selection
      (quote
       ((output-pdf "pdf-tools")
        (output-dvi "pdf-tools")
        (output-html "pdf-tools"))))

;; revert the pdf buffer after tex compilation has finished
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
;; (add-hook 'LaTeX-mode-hook
;; (lambda () (local-set-key (kbd "<S-s-mouse-1>") #'TeX-view))
;; (lambda () (local-set-key (kbd "<f5>") #'TeX-view))
;; )

;; auctex setting
(load "auctex.el" nil t t)
;; avoiding indent
(setq LaTeX-indent-environment-check nil)
                                        ; (load "preview-latex.el" nil t t)
(add-hook 'LaTeX-mode-hook #'LaTeX-install-toolbar)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex) ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-reftex) ; with Emacs latex mode
;; Activate nice interface between RefTeX and AUCTeX
(setq reftex-plug-into-AUCTeX t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
;;;auctex other;;;
(setq preview-default-preamble (quote ("\\RequirePackage[" ("," . preview-default-option-list) "]{preview}[2004/11/05]" "\\PreviewEnvironment{center}" "\\PreviewEnvironment{enumerate}")))

;;cdlatex setting
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-cdlatex)   ; with Emacs latex mode
(define-key cdlatex-mode-map ";" 'cdlatex-tab)

(add-hook 'LaTeX-mode-hook 'turn-on-flyspell) ; with flyspell Latex(latex) mode
(add-hook 'plain-TeX-mode-hook 'LaTeX-mode) ; plainlatex automatically convert to Latex mode


(defun open-latex-symbol-file ()
  (interactive)
  (find-file "/home/fg/MEGA/linux-pdfs/Symbols.pdf")
  )

(defhydra hydra-latex-main (:color pink :hint nil)
  "
 ^Preview^        | ^Compile^     | ^Bibtex^       | ^citeRef^     | ^Outline^   | ^help^
-^-------^--------+-^-------^-----+-^------^-------+-^-------^-----+-^-------^-----^----^----------
  _m_: math       | _R_: PBP      | _b_: bibtex    | _f_: ref      | _o_: outline| _s_: mathSymbol
 _SPC_: delete    | _P_: pdflatex | ^ ^            | _H_: helmBib  | ^ ^         |
  _p_: auctex     | _X_: XBX      | ^ ^            | ^ ^           | ^ ^         |
  ^ ^             | _x_: xelatex  | ^ ^            | ^ ^           | ^ ^         |
  ^ ^             | _C_: clean    | ^ ^            | ^ ^           | ^ ^         |
"
  ;; latex math preview
  ("m" latex-math-preview-expression)
  ("SPC" latex-math-preview-delete-buffer)
  ("p" auctex-preview/body :color blue)
  ;; compile
  ("R" fg/compile-latex-file)
  ("X" fg/compile-chinese-latex-file)
  ("P" fg/pdflatex-file)
  ("x" fg/xelatex-file)
  ("C" fg/clean-latex-file)
  ;; bibtex
  ("b" bibtex-main/body :color blue)
  ;; reftex setting
  ("f" reftex-reference)
  ;; citeRef
  ("H" helm-bibtex)
  ("s" open-latex-symbol-file)
  ;; outline
  ("o" hydra-outline-main/body :color blue)
  ("q" nil "cancel")
  )
;; auctex-preview
(defhydra auctex-preview (:color teal :hint nil
                                 :after-exit (hydra-latex-main/body))
  "
 ^Preview^         | ^Clear^
-^-------^---------+-^-----^--------
  _p_: point       | _P_: point
  _e_: environment |
  _r_: region      |
  _s_: section     | _S_: section
  _d_: document    | _D_: document
  _a_: buffer      | _A_: buffer
-^-------^---------+-^-----^--------
"
  ("p" preview-at-point)
  ("P" preview-clearout-at-point)
  ("r" preview-region)
  ("e" preview-environment)
  ("s" preview-section)
  ("S" preview-clearout-section)
  ("d" preview-document)
  ("D" preview-clearout-document)
  ("a" preview-buffer)
  ("A" preview-clearout-buffer)
  ("q" nil "cancel")
  ("b" hydra-latex-main/body :color blue))
(defhydra bibtex-main (:color teal :hint nil)
  "
 ^Bibtex^
 _v_: validate
 _c_: clean
 _s_: sort
 _y_: orgBibYank
"
  ;; org-ref, bibtex, need org-ref package
  ("v" bibtex-validate)
  ("c" org-ref-clean-bibtex-entry)
  ("s" bibtex-sort-buffer)
  ("y" org-bibtex-yank)
  ("b" hydra-latex-main/body :color blue))
(defhydra hydra-outline-main (:color pink :hint nil)
  "
^Hide^              ^Show^          ^Jump^
^^^^^^^^----------------------------------------------------
_B_: body           _a_: all        _n_: next
_e_: entry          _E_: entry      _p_: previous
_o_: other          _c_: children   _f_: forward
_s_: subtree        _r_: branches   _k_: backward
_l_: leaves         _S_: subtree    _u_: up
_U_: sublevels      ^ ^             ^ ^
"
  ;; show
  ("a" show-all)
  ("c" show-children)
  ("E" show-entry)
  ("r" show-branches)
  ("S" show-subtree)
  ;; hide
  ("B" hide-body)
  ("o" hide-other)
  ("e" hide-entry)
  ("s" hide-subtree)
  ("l" hide-leaves)
  ("U" hide-sublevels)
  ;; outline move
  ("n" outline-next-visible-heading)
  ("p" outline-previous-visible-heading)
  ("f" outline-forward-same-level)
  ("k" outline-backward-same-level)
  ("u" outline-up-heading)
  ("b" hydra-latex-main/body :color blue)
  ;; quit
  ("q" nil "cancel"))

(evil-leader/set-key (kbd "l") 'hydra-latex-main/body)
;;}}}

;; fast to run and clean latex current buffer
;; run latex buffer
(defun fg/compile-latex-file ()
  "run a command on the current file and revert the buffer"
  (interactive)
  (save-buffer) ;; save a current file
  (shell-command
   (format "/home/fg/MEGA/dotfiles-manjaro/scripts/compile-latex compile %s"
           (shell-quote-argument (buffer-file-name))))
  (revert-buffer t t t)
  )
(defun fg/compile-chinese-latex-file ()
  (interactive)
  (save-buffer)
  (shell-command
   (format "/home/fg/MEGA/dotfiles-manjaro/scripts/compile-chinese-latex compile %s"
           (shell-quote-argument (buffer-file-name))))
  (revert-buffer t t t))
;; clean latex stuff
(defun fg/clean-latex-file ()
  (interactive)
  (shell-command
   (format "/home/fg/MEGA/dotfiles-manjaro/scripts/compile-latex clean %s"
           (shell-quote-argument (buffer-file-name))))
  (revert-buffer t t t))
(defun fg/pdflatex-file ()
  (interactive)
  (save-buffer)
  (shell-command
   (format "pdflatex -synctex=1 -interaction=nonstopmode  %s"
           (shell-quote-argument (buffer-file-name))))
  (revert-buffer t t t))
(defun fg/xelatex-file ()
  (interactive)
  (save-buffer)
  (shell-command
   (format "xelatex -synctex=1 -interaction=nonstopmode  %s"
           (shell-quote-argument (buffer-file-name))))
  (revert-buffer t t t))
;; latex keybindings
;; (evil-leader/set-key (kbd "or") 'fg/compile-latex-file)
;; (evil-leader/set-key (kbd "op") 'fg/pdflatex-file)
;; (evil-leader/set-key (kbd "ox") 'fg/compile-chinese-latex-file)
(evil-leader/set-key (kbd "oc") 'fg/clean-latex-file)

;; {{{ key config
(define-key LaTeX-mode-map (kbd "<f4>") 'fg/pdflatex-file)
(define-key LaTeX-mode-map (kbd "<f5>") 'fg/compile-latex-file)
(define-key LaTeX-mode-map (kbd "<f6>") 'fg/compile-chinese-latex-file)
(define-key LaTeX-mode-map (kbd "<f3>") nil)
(define-key LaTeX-mode-map (kbd "<f3>") 'fg/xelatex-file)
;; }}}


;;disable auto-fill-mode when editing equations
(defvar my-LaTeX-no-autofill-environments
  '("equation" "equation*" "align" "align*" "split" "split*" "eqnarray" "eqnarray*" "cases" "cases*" "figure" "figure*" "table" "table*")
  "A list of LaTeX environment names in which `auto-fill-mode' should be inhibited.")

(defun my-LaTeX-auto-fill-function ()
  "This function checks whether point is currently inside one of
  the LaTeX environments listed in
  `my-LaTeX-no-autofill-environments'. If so, it inhibits automatic
  filling of the current paragraph."
  (let ((do-auto-fill t)
        (current-environment "")
        (level 0))
    (while (and do-auto-fill (not (string= current-environment "document")))
      (setq level (1+ level)
            current-environment (LaTeX-current-environment level)
            do-auto-fill (not (member current-environment my-LaTeX-no-autofill-environments))))
    (when do-auto-fill
      (do-auto-fill)))
  )

(defun my-LaTeX-setup-auto-fill ()
  "This function turns on auto-fill-mode and sets the function
used to fill a paragraph to `my-LaTeX-auto-fill-function'."
  (auto-fill-mode)
  (setq auto-fill-function 'my-LaTeX-auto-fill-function))

;; (add-hook 'LaTeX-mode-hook 'my-LaTeX-setup-auto-fill)

;;{{{ latex-math-preview
;; see @ https://www.emacswiki.org/emacs/LaTeXMathPreview
(add-to-list 'load-path "~/.emacs.d/private/latex-math-preview")
(load "latex-math-preview")
(load "latex-math-preview-extra-data")
(autoload 'latex-math-preview-expression "latex-math-preview" nil t)
(autoload 'latex-math-preview-insert-symbol "latex-math-preview" nil t)
(autoload 'latex-math-preview-save-image-file "latex-math-preview" nil t)
(autoload 'latex-math-preview-beamer-frame "latex-math-preview" nil t)
(defvar latex-math-preview-latex-template-header
  "\\documentclass{article}\n \\usepackage{amsmath}\n \\usepackage{multirow}\n \\usepackage{float}\n \\usepackage{algorithm}\n \\usepackage{algorithmic}\n"
  )

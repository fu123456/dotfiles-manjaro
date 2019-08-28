;; chords borrowed from prelude.
(use-package key-chord
  :ensure t
  :config
  (key-chord-mode 1)
  (key-chord-define-global "JJ" 'previous-buffer)
  (key-chord-define-global "KK" 'next-buffer)
  (key-chord-define-global "uu" 'undo-tree-visualize)
  (key-chord-define-global ";;" ";")
  (key-chord-define-global "''" 'indent-for-comment)
  (key-chord-define latex-mode-map ";;"  'pdf-sync-forward-search)


  ;; This create a prefix keymap
  ;; https://stackoverflow.com/questions/25473660/how-do-i-use-a-key-chord-combination-as-a-prefix-binding
  ;; (let
  ;;     ((sub-keymap (make-sparse-keymap)))
  ;;   (define-key sub-keymap "a" 'org-agenda)
  ;;   (define-key sub-keymap "c" 'org-capture)
  ;;   (key-chord-define-global "cc" sub-keymap))

  (defvar key-chord-tips
    '(
      "Press <JJ> quickly to go to previous buffer."
      "Press <uu> quickly to visualize the undo tree."
      "Press <,,> quickly to comment a line code"
      ))
  )

(add-hook 'org-mode-hook
          (lambda ()
            (key-chord-mode 1)
            ))
(add-hook 'matlab-mode-hook
          (lambda ()
            (key-chord-mode 1)
            ))
(add-hook 'octave-mode-hook
          (lambda ()
            (key-chord-mode 1)
            ))
(add-hook 'latex-mode-hook
          (lambda ()
            (key-chord-mode 1)
            ))
(add-hook 'text-mode-hook
          (lambda ()
            (key-chord-mode 1)
            ))
(add-hook 'python-mode-hook
          (lambda ()
            (key-chord-mode 1)
            ))
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (key-chord-mode 1)
            ))
(add-hook 'pdf-view-mode
          (lambda ()
            (key-chord-mode 1)
            ))
(add-hook 'doc-view-mode
          (lambda ()
            (key-chord-mode 1)
            ))
(add-hook 'sh-mode
          (lambda ()
            (key-chord-mode 1)
            ))
(add-hook 'Shell-script-mode
          (lambda ()
            (key-chord-mode 1)
            ))
(add-hook 'sh-mode
          (lambda ()
            (key-chord-mode 1)
            ))

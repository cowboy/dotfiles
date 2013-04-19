(define-derived-mode cheetah-mode html-mode "cheetah"
  (make-face 'cheetah-variable-face)
  (font-lock-add-keywords
   nil
   '(
     ("\\(#\\(from\\|else\\|include\\|extends\\|set\\|def\\|import\\|for\\|if\\|end\\|elif\\|call\\|block\\|attr\\|silent\\|echo\\|return\\)+\\)\\>" 1 font-lock-type-face)
     ("\\(#\\(from\\|for\\|end\\|else\\)\\).* \\<\\(for\\|import\\|def\\|if\\|in\\|block\\|call\\)\\>" 3 font-lock-type-face)
     ("\\(##.*\\)\n" 1 font-lock-comment-face)
     ("\\(\\$\\(?:\\sw\\|}\\|{\\|\\s_\\)+\\)" 1 font-lock-variable-name-face))
   )
  (font-lock-mode 1)
 )

(define-derived-mode cheetah-css-mode css-mode "cheetah-css"
  (make-face 'cheetah-css-variable-face)
  (font-lock-add-keywords
   nil
   '(("\\(##.*\\)\n" font-lock-comment-face)) (font-lock-mode 1))
  (modify-syntax-entry ?# "' 12b" cheetah-css-mode-syntax-table)
  (modify-syntax-entry ?\n "> b" cheetah-css-mode-syntax-table))

(setq auto-mode-alist (cons '( "\\.tmpl\\'" . cheetah-mode ) auto-mode-alist ))
(setq auto-mode-alist (cons '( "\\.css.tmpl\\'" . cheetah-css-mode ) auto-mode-alist ))

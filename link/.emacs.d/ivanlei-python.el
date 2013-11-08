; Emacs-For-Python
(load-file "~/.emacs.d/emacs-for-python/epy-init.el")
(epy-setup-ipython)
(epy-setup-checker "pyflakes %f")

; Use Yelp pagination in python mode
(defun customize-py-tabs ()
  (setq tab-width 4
        py-indent-offset 4
                python-indent-offset 4
        indent-tabs-mode nil
        py-smart-indentation nil
        python-indent 4))
(add-hook 'python-mode-hook 'customize-py-tabs)

; Highlight useless whitespace
(defun customize-py-show-whitespace ()
  (setq show-trailing-whitespace t))
(add-hook 'python-mode-hook 'customize-py-show-whitespace)

(require 'python)
(defun python--add-debug-highlight ()
  "Adds a highlighter for use by `python--pudb-breakpoint-string'"
  (highlight-lines-matching-regexp "## DEBUG ##\\s-*$" 'hi-red-b))
 
(add-hook 'python-mode-hook 'python--add-debug-highlight)
 
(defvar python--pudb-breakpoint-string "import pudb; pudb.set_trace() ## DEBUG ##"
  "Python breakpoint string used by `python-insert-breakpoint'")
 
(defun python-insert-breakpoint ()
  "Inserts a python breakpoint using `pdb'"
  (interactive)
  (back-to-indentation)
  ;; this preserves the correct indentation in case the line above
  ;; point is a nested block
  (split-line)
  (insert python--pudb-breakpoint-string))
(define-key python-mode-map (kbd "C-c <f5>") 'python-insert-breakpoint)

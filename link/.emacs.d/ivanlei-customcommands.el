;; Command Notes:
;;   C-c C-g     : Goto Python Definition
;;   C-x C-SPC   : Goto Previous Mark
;;   M-s o       : Find Occurances
;;   C-x z       : Repeat Previous Command
;;   M-x re-builder : Start Regexp Builder

(defun join-region (beg end)
  "Apply join-line over region."
  (interactive "r")
  (if mark-active
          (let ((beg (region-beginning))
                        (end (copy-marker (region-end))))
                (goto-char beg)
                (while (< (point) end)
                  (join-line 1)))))

(require 're-builder)
(setq reb-re-syntax 'string)
(global-set-key (kbd "C-c <f6>") 're-builder)


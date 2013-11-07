; Colorize the shell
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

; Supress startup & toolbar
(setq inhibit-startup-message t 
          inhibit-startup-echo-area-message t
          tool-bar-mode -1)

; Render before processing input
(setq redisplay-dont-pause t)

; Always show line numbers on the status bar
(setq-default line-number-mode 1)
(setq line-number-mode 1)

; Always show line numbers in the left column
(require 'linum)
(global-linum-mode 1)
(setq linum-format "%4d \u2502 ")

; Always show column position
(column-number-mode 1)

; Highlight lines
(global-hl-line-mode t) ;; To enable
; (set-face-background 'hl-line "gray8")

(require 'highlight-chars)
(add-hook 'font-lock-mode-hook 'hc-highlight-tabs)


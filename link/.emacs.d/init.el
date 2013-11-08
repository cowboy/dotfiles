; Congratulations! You're customizing your editor
(add-to-list 'load-path "~/.emacs.d/")

; Add all top-level subdirectories of .emacs.d to the load path
(progn (cd "~/.emacs.d")
       (normal-top-level-add-subdirs-to-load-path))

(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")

; Store backups in their own directory instead of littering the
; whole filesystem with goddamn ~ files.
(setq backup-by-copying t ; don't clobber symlinks
          backup-directory-alist
          '(("." . "~/.emacs.d/emacs_backups")) ; don't litter my fs tree
          version-control t ; use versioned numbers for backup files
          kept-new-versions 6 ; number of newest versions to keep
          kept-old-versions 2 ; number of oldest versions to keep
          delete-old-versions t) ; delete excess backup versions silently

; Look and feel enhancements
(load-library "ivanlei-lookandfeel")

; Custom emacs commands
(load-library "ivanlei-customcommands")

; Python-specific enhancements
(load-library "ivanlei-python")

; Cheetah specific enhancements
(load-library "ivanlei-cheetah")

; Puppet specific enhancements
; (load-library "puppet-syntax-emacs/puppet-mode")
; (load-library "puppet-syntax-emacs/puppet-mode-init")

; Vagrant can use ruby
(setq auto-mode-alist (cons '("Vagrantfile$" . ruby-mode) auto-mode-alist))

(load-theme 'solarized-dark t)

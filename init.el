;; before you use this .emacs
;; Please follow the following instructions:-
;; If you are on Ubuntu please run the following commands
;; # apt-get install emacs-goodies-el
;; for enabling ecb mode
;; # apt-get install ecb
;; for enabling org mode
;; # apt-get install org-mode
;; If you are on Fedora please run the following commands
;; # yum install emacs-color-theme
;; For auto-complete to work properly, download the package from the following site and install it using the instructions given on the site
;; http://cx4a.org/software/auto-complete/
;; For auto-parenthesis to work properly, download the package .el file from the following site and put in the load path -> ~/.emacs.d/
;; http://code.google.com/p/autopair/


(load "server")
(defvar emacs-numeric-version (string-to-number (nth 2 (split-string (version)))))
(unless (server-running-p) (server-start))
;; redefining emacs keybindings to generic keyboard shortcuts
(cua-mode 1) ;; C-c and C-x are for copying and pasting if a  region has been selected other-wise they perform the normal emacs functions
(global-visual-line-mode 1)                             ;; enabling word wrapping 
(global-set-key (kbd "C-l") 'goto-line)			;; for going to line number
(global-set-key (kbd "C-s") 'save-buffer)		;; for saving a buffer
(global-set-key (kbd "C-f") 'isearch-forward)	        ;; for finding in a buffer
;; once you entered the text in C-f, you can just go through the finds using the pgup and pgdwn key
(define-key isearch-mode-map [next]
  'isearch-repeat-forward)
(define-key isearch-mode-map [prior]
  'isearch-repeat-backward)
(global-set-key (kbd "C-<prior>") 'previous-buffer)		;; going to the previous buffer
(global-set-key (kbd "C-<next>") 'next-buffer)			;; going to the next buffer
(global-set-key (kbd "C-a") 'mark-whole-buffer)			;; Ctrl + a to select all
(global-set-key (kbd "C-o") 'ido-find-file)			;; for opening a file
(global-set-key (kbd "C-<f4>") 'kill-this-buffer)		;; for closing a tab (browser like behaviour)
(global-set-key (kbd "M-f") 'menu-bar-open)			;; for opening the file menu
(global-set-key (kbd "<f9>")  'ecb-minor-mode)			;; for opening the ecb (emacs code browser menu)
;; navigating windows using arrow keys
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(setq x-select-enable-clipboard t)				;; enabling copying and pasting between applications

;; indentation
(define-key global-map (kbd "RET") 'reindent-then-newline-and-indent) ;; indents on going to the newline
;; pasted lines are automatically indented
(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
	   (and (not current-prefix-arg)
		(member major-mode '(emacs-lisp-mode lisp-mode
						     clojure-mode    scheme-mode
						     haskell-mode    ruby-mode
						     rspec-mode      python-mode
						     c-mode          c++-mode
						     objc-mode       latex-mode
						     html-mode       css-mode
						     plain-tex-mode))
		(let ((mark-even-if-inactive transient-mark-mode))
		  (indent-region (region-beginning) (region-end) nil))))))

;; splitting windows
(global-set-key (kbd "C-x |") 'split-window-horizontally)		;; for splitting a window horizontally
(global-set-key (kbd "C-x _") 'split-window-vertically)		;; for splitting a window vertically

(ido-mode 1)			;; enabling listing of file names
(show-paren-mode 1)		;; enabling highlighting of parenthesis
(desktop-save-mode 1)		;; enabling desktop save mode
(tool-bar-mode 0)		;; disabling the toolbar
(scroll-bar-mode 0)		;; disabling the scrollbar
(put 'upcase-region 'disabled nil)
(put 'scroll-left 'disabled nil)

;; ERC (Emacs iRC) settings
(setq erc-log-channels-directory (expand-file-name "~/logs/"))
(setq erc-save-buffer-on-part t)

;(global-linum-mode 1)           ;; enabling seeing line numbers in the l.h.s. buffer margin
(set-default-font "-unknown-Monaco-normal-normal-normal-*-17-*-*-*-m-0-iso10646-1") ;; setting the default font to monaco
;;(set-default-font "-unknown-Ubuntu Mono-normal-normal-normal-*-17-*-*-*-m-0-iso10646-1") ;; setting the default font to ubuntu mono

;; loading the emacs load path from where the extension libraries are loaded
(add-to-list 'load-path (expand-file-name "~/.emacs.d/"))


;;To add a directory to the 'load-path' the current directory has to be temporarily changed by binding 'default-directory'. To recursively add the sub-directories of the current directory to the end of the 'load-path' do this:
(let ((default-directory "~/.emacs.d/plugins/"))
   (normal-top-level-add-subdirs-to-load-path))

;; color-themes
(if (< emacs-numeric-version 24)
    (progn 
      (require 'color-theme)
      (color-theme-initialize)	        ;; initializing color themes
      (color-theme-midnight)		;; using the midnight color theme
      )
  (load-theme 'manoj-dark t)
  )

;; golden-ratio
(require 'golden-ratio)
(global-set-key (kbd "<f8>") 'golden-ratio)

;; yasnippet
(if (> emacs-numeric-version 24)
    (progn
      (require 'yasnippet)
      (yas-global-mode 1)))

;; auto-suggestions as we type
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (expand-file-name "~/.emacs.d/ac-dict"))
(ac-config-default)

;; simulating the electric-pair-mode, auto parenthesis
(if (< emacs-numeric-version 24)
    (progn
      (require 'autopair)
      (autopair-global-mode)                                     ;; enable autopair in all buffers
      )
  (electric-pair-mode 1)
  )

;; Planning and Organization
(diary)				;; enabling diary mode
(add-hook 'diary-display-hook 'diary-fancy-display)

;; org mode settings, org mode is for note taking and project planning (www.orgmode.org)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-agenda-files (file-expand-wildcards "~/.org/*.org"))

;; find files recursively
(require 'find-recursive)

;; opens less style files in css mode
(add-to-list 'auto-mode-alist '("\\.less" . css-mode))

;; opens markdown files in markdown mode
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; for cucumber files
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/feature-mode"))
;; optional configurations
;; default language if .feature doesn't have "# language: fi"
(setq feature-default-language "en")
;; point to cucumber languages.yml or gherkin i18n.yml to use
;; exactly the same localization your cucumber uses
(setq feature-default-i18n-file (expand-file-name "~/.emacs.d/plugins/gherkin/feature-mode/i18n.yml"))
;; and load feature-mode
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\\.feature" . feature-mode))
(add-hook 'feature-mode-hook 'flyspell-mode)

;; for loading rails minor mode
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/rails-minor-mode"))
(require 'rails)

;; opens rake files in ruby mode
(add-to-list 'auto-mode-alist '("\\.rake" . ruby-mode))
;; opens rackup files in ruby mode
(add-to-list 'auto-mode-alist '("\\.ru" . ruby-mode))

;; for html erb mode
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/rhtml-minor-mode"))
(require 'rhtml-mode)

;; for haml mode
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/haml-mode"))
(require 'haml-mode)
(add-to-list 'auto-mode-alist '("\\.haml" . haml-mode))
;; sets tabs to spaces for haml files
(add-hook 'haml-mode-hook
	  '(lambda ()
	     (setq indent-tabs-mode nil)
	     (define-key haml-mode-map "\C-m" 'newline-and-indent)))

;; slime settings for exterior LISP dev
;; (add-to-list 'load-path "~/.emacs.d/plugins/lisp/slime")
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(require 'slime)
(slime-setup '(slime-fancy))

;; turning on scheme mode for scheme files
(add-to-list 'auto-mode-alist '("\\.scheme" . scheme-mode))

;; for scala mode
;; (add-to-list 'load-path "~/.emacs.d/plugins/scala/scala-mode")
(require 'scala-mode-auto)

;; for sbt mode
;; (add-to-list 'load-path "~/.emacs.d/plugins/scala/ensime/elisp")
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; for json mode
;; (add-to-list 'load-path "~/.emacs.d/plugins/ecmascript/json-mode")
(require 'json-mode)

;; js2-mode
(if (< emacs-numeric-version 24)
    (progn
      (autoload 'js2-mode "js2-mode" nil t)
      (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))))

;; for swank-js mode
;; (global-set-key [f5] 'slime-js-reload)
;; (add-hook 'js2-mode-hook
;;           (lambda ()
;;             (slime-js-minor-mode 1)))

;; for javascript REPL
(require 'js-comint)
(setq inferior-js-program-command "/usr/bin/rhino")
(add-hook 'js2-mode-hook '(lambda () 
			    (local-set-key "\C-x\C-e" 'js-send-last-sexp)
			    (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
			    (local-set-key "\C-cb" 'js-send-buffer)
			    (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
			    (local-set-key "\C-cl" 'js-load-file-and-go)
			    ))

;; for nodejs repl
;; (add-to-list 'load-path "~/.emacs.d/plugins/ecmascript/nodejs-repl")
(require 'nodejs-repl)

;; for nxhtml mode
;; (load (expand-file-name "~/.emacs.d/nxhtml/autostart"))

;; haskell mode configuration
;; (setq auto-mode-alist
;;       (append auto-mode-alist
;;               '(("\\.[hg]s$"  . haskell-mode)
;;                 ("\\.hic?$"   . haskell-mode)
;;                 ("\\.hsc$"    . haskell-mode)
;;                 ("\\.chs$"    . haskell-mode)
;;                 ("\\.l[hg]s$" . literate-haskell-mode))))
;; (autoload 'haskell-mode "haskell-mode"
;;    "Major mode for editing Haskell scripts." t)
;; (autoload 'literate-haskell-mode "haskell-mode"
;;    "Major mode for editing literate Haskell scripts." t)

;; ;adding the following lines according to which modules you want to use:
;; (require 'inf-haskell)

;; (add-hook 'haskell-mode-hook 'turn-on-font-lock)
;; (add-hook 'haskell-mode-hook 'turn-off-haskell-decl-scan)
;; (add-hook 'haskell-mode-hook 'turn-off-haskell-doc-mode)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-hugs)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)
;; (add-hook 'haskell-mode-hook 
;;    (function
;;     (lambda ()
;;       (setq haskell-program-name "ghci")
;;       (setq haskell-ghci-program-name "ghci6"))))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(rails-ws:default-server-type "mongrel"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

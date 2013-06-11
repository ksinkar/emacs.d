;; for loading rails minor mode
(add-to-list 'load-path (expand-file-name "./rails-minor-mode"))
(require 'rails)

;; opens rake files in ruby mode
(add-to-list 'auto-mode-alist '("\\.rake" . ruby-mode))
;; opens rackup files in ruby mode
(add-to-list 'auto-mode-alist '("\\.ru" . ruby-mode))

;; for html erb mode
(add-to-list 'load-path (expand-file-name "./rhtml-minor-mode"))
(require 'rhtml-mode)

;; for haml mode
(add-to-list 'load-path (expand-file-name "./haml-mode"))
(require 'haml-mode)
(add-to-list 'auto-mode-alist '("\\.haml" . haml-mode))
;; sets tabs to spaces for haml files
(add-hook 'haml-mode-hook
	  '(lambda ()
	     (setq indent-tabs-mode nil)
	     (define-key haml-mode-map "\C-m" 'newline-and-indent)))
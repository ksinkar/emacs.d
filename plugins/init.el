;; for cucumber files
(add-to-list 'load-path (expand-file-name "./feature-mode"))
;; optional configurations
;; default language if .feature doesn't have "# language: fi"
(setq feature-default-language "en")
;; point to cucumber languages.yml or gherkin i18n.yml to use
;; exactly the same localization your cucumber uses
(setq feature-default-i18n-file (expand-file-name "./feature-mode/i18n.yml"))
;; and load feature-mode
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\\.feature" . feature-mode))
(add-hook 'feature-mode-hook 'flyspell-mode)

;; auto-suggestions as we type
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (expand-file-name "./ac-dict"))
(ac-config-default)
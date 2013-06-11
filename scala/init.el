;; for scala mode
(add-to-list 'load-path "./scala-mode")
(require 'scala-mode-auto)

;; for sbt mode
(add-to-list 'load-path "./ensime/elisp")
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
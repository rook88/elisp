
(setq w32-apps-modifier 'hyper)

(setq w32-pass-lwindow-to-system nil)
(setq w32-lwindow-modifier 'super)

(setq w32-pass-rwindow-to-system nil)
(setq w32-lwindow-modifier 'super)

(defun keys-el-avaa ()
  (interactive)
  (open-module "keys.el"))

(global-set-key (kbd "H-o k") (lambda () (interactive) (open-module "keys.el")))
(global-set-key (kbd "H-o l") (lambda () (interactive) (open-module "load.el")))

(global-set-key (kbd "C-s-e") 'eval-buffer)
(global-set-key (kbd "C-s-s") 'save-buffer)
(global-set-key (kbd "H-C-c") 'vie-leikemuisti-oletus)
(global-set-key (kbd "H-c") 'tuo-leikemuisti-oletus)
(global-set-key (kbd "H-e") 'eval-last-sexp)
(global-set-key (kbd "H-C-e") 'eval-print-last-sexp)

;(replace-string (char-to-string (read-char)) (char-to-string (read-char)))

(global-set-key (kbd "s-?") (lambda () (interactive) (message "Super painettu")))
(global-set-key (kbd "M-?") (lambda () (interactive) (message "Meta painettu")))
(global-set-key (kbd "H-?") (lambda () (interactive) (message "Hyper painettu")))
(global-set-key (kbd "C-?") (lambda () (interactive) (message "Control  painettu")))


(message "keys.el ladattu")

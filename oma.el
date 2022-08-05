
; M-o

(provide 'oma)

(defun kokeilu(z)
  (+ 1 z))


(defun oma-nayta ()
  (interactive)
  (open-module "oma.el"))

(defun oma-dir (kansio &optional siisti-kansion-nimi-pois)
  (interactive "fKansio : ")
  (shell-command 
   (concat "dir \"" 
	   (replace-regexp-in-string "/" "\\\\" kansio)
	   "\" /b /s /a:-d"))
  (switch-to-buffer "*Shell Command Output*")
  (if (not siisti-kansion-nimi-pois)
      (goto-char (point-min))
    (replace-string 
     (replace-regexp-in-string "/" "\\\\" kansio)
   ""))
  (rename-buffer 
   (concat "dir-" kansio)))


(defun oma-alleviivaus (merkki)
  (interactive "cAlleviivauksen merkki:")
  (setq viiva (make-string (-
		(line-end-position)
		(line-beginning-position)) merkki))
  (end-of-line)
  (insert "\n")
  (insert viiva)
)



(defun oma-pvm ()
  (format-time-string "%d.%m.%Y"))
;(oma-pvm)

(defun oma-klo ()
  (format-time-string "%H.%M"))
;(oma-klo)

(global-set-key (kbd "M-o =") 'oma-nayta)
(global-set-key (kbd "M-o d") 'oma-dir)
;(global-set-key (kbd "M-o u =") (lambda () (interactive) (oma-alleviivaus ?=)))
(global-set-key (kbd "M--") (lambda () (interactive) (oma-alleviivaus ?-)))
(global-set-key (kbd "M-o M-o") (lambda () (interactive) (oma-alleviivaus ?=)))
;(global-unset-key (kbd "M-o u")

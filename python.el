
;
; c:/Users/rook/python/python.el
;

(setq python-polku "c:/users/rook/python/")

(defun python-puskuri-tiedostoon (tiedosto)
  (interactive "sTallennetaan Python kansioon tiedostoon : ")
  (setq mjono (buffer-string))
  (find-file (concat python-polku tiedosto))
  (delete-region (point-min) (point-max))
  (insert mjono)
  (save-buffer)
  (kill-buffer (current-buffer)))

(defun python-skripti-toiseen-ikkunaan ()
  (interactive)
  (other-window 1)
  (python-puskuri-tiedostoon "data.input")
  (other-window -1)
  (python-puskuri-tiedostoon "temp.py")
  (shell-command (concat python-polku "skriptaa.py"))
  (python-shell-tulos-nayta))

(defun python-shell-tulos-nayta ()
  (interactive)
  (switch-to-buffer "*Shell Command Output*")
  (rename-buffer "*Python*"))

(defun python-tallenna-ja-aja ()
  (interactive)
  (save-buffer)
  (shell-command (concat "\"C:\\Python27\\python\" " (buffer-name))
  (save-excursion
    (other-window 1)
    (switch-to-buffer "*Shell Command Output*")    
    (other-window -1))))

(defun python-lisaa-kommentti ()
  (interactive)
  (insert "/*------------------------------------------------------------*/"))

(defun python-kommentoi-rivi ()
  (interactive)
  (beginning-of-line)
  (insert "#"))

(defun python-pura-kommentti ()
  (interactive)
  (beginning-of-line)
  (delete-char 1))

(setq python-polku "C:/Users/rook/python/")
(setq python-polku-arkisto "C:/Users/rook/python/arkisto/")

(defun python-versio-julkaise ()
  (interactive)
  (setq koodi (buffer-string))
  (save-excursion
    (if (setq versio-numero (python-kasvata-versio-puskurissa))
	(progn 
	  (find-file (concat python-polku-arkisto (python-nimi-lisaa-versio versio-numero)))
	  (insert koodi)
	  (save-buffer)
	  (kill-buffer)))))

(defun python-nimi-lisaa-versio (versio-numero)
  (concat
   (nth 0 (split-string (buffer-name) "\\\."))
   "_"
   versio-numero
   "."
      (nth 1 (split-string (buffer-name) "\\\."))))

(defun python-kasvata-versio-puskurissa ()
  (goto-char (point-min))
;  (if (search-forward-regexp "versio +\\([0-9]+\.[0-9]+\\)")
  (if (search-forward-regexp "versio +\\([0-9]\\)")
      (progn 
	(setq versio-numero (python-kasvata-versio-numero (match-string 1)))
	(delete-region (match-beginning 1) (match-end 1))
        (insert versio-numero)
	versio-numero)
    nil)
)

(defun python-kasvata-versio-numero (versio-numero)
  (number-to-string (+ 1 (string-to-number versio-numero))))

(defun python-help ()
  (interactive)
  (apropos-command "python"))

(global-unset-key (kbd "C--"))
(global-set-key (kbd "<f1>") 'python-help)
(global-set-key (kbd "<f4>") 'python-tallenna-ja-aja)
(global-set-key (kbd "C-+ l") 'python-lisaa-kommentti)
(global-set-key (kbd "C-+ v") 'python-versio-julkaise)
(global-set-key (kbd "C-+ k") 'python-kommentoi-rivi)
(global-set-key (kbd "C-- k") 'python-pura-kommentti)

(setq python-hakemisto "C:/Users/rook/python/")

;(delete-other-windows)
;(split-window-horizontally)
;(other-window 1)
;(switch-to-buffer (get-buffer-create "*python*"))
;(insert "Ladattu c:/Users/rook/python/python.el")Ladattu c:/Users/rook/pythonython.elLadattu c:/Users/rook/python/python.el

;
; lista.el
;
; apuvalineita listojen kasittelyyn
;

(defun blankot-rivinvaihdoiksi ()
  (interactive)
  (goto-char 1)
  (replace-regexp "[ \t]+" "\n")
  (goto-char 1)
  (replace-regexp "\n+" "\n"))

;(defun tuo-eri-sanat (buffer)
;  (interactive "bbuffer:")
;  (switch-to-buffer buffer)
(defun tuo-eri-sanat (maara)
  "Luettelee puskurin eri sanat ja niiden määrän"
  (interactive)
  (setq taulu (split-string (buffer-string) "[', \t\n]+"))
  (setq myhash (make-hash-table :test 'equal))
  (dolist (alkio taulu)
    (if (gethash alkio myhash)
	(puthash alkio (+ 1 (gethash alkio myhash)) myhash)
      (puthash alkio 1 myhash)))
  (defun pullkeys (kk vv)
    "prepend the key kk to the list allkeys"
    (setq allkeys (cons kk allkeys)))
  (defvar allkeys '())
  (setq allkeys '())
  (maphash 'pullkeys myhash)
  (setq sortatut (sort allkeys (lambda (a b) (> (gethash a myhash) (gethash b myhash)))))
  (switch-to-buffer "avaimet")
  (dolist (alkio sortatut)
    (insert alkio)
    (if maara
	(progn (insert " ")
	       (insert (number-to-string (gethash alkio myhash)))))
; TODO	kirjoita osumien maara
    (insert "\n")))


(defun tuo-eri-rivit (maara)
  "Luettelee puskurin eri rivit ja niiden määrän"
  (interactive)
  (setq taulu (split-string (buffer-string) "\n+"))
  (setq myhash (make-hash-table :test 'equal))
  (dolist (alkio taulu)
    (if (gethash alkio myhash)
	(puthash alkio (+ 1 (gethash alkio myhash)) myhash)
      (puthash alkio 1 myhash)))
  (defun pullkeys (kk vv)
    "prepend the key kk to the list allkeys"
    (setq allkeys (cons kk allkeys)))
  (defvar allkeys '())
  (setq allkeys '())
  (maphash 'pullkeys myhash)
  (setq sortatut (sort allkeys (lambda (a b) (> (gethash a myhash) (gethash b myhash)))))
  (switch-to-buffer "avaimet")
  (dolist (alkio sortatut)
    (insert alkio)
    (if maara
	(progn (insert " ")
	       (insert (number-to-string (gethash alkio myhash)))))
; TODO	kirjoita osumien maara
    (insert "\n")))

(defun tuo-vain-eri-rivit ()
  (interactive)
  (tuo-eri-rivit nil))
(global-set-key (kbd "<M-f8>") 'tuo-vain-eri-rivit)


(defun tuo-vain-eri-sanat ()
  (interactive)
  (tuo-eri-sanat nil))
(global-set-key (kbd "<S-f8>") 'tuo-vain-eri-sanat)

(defun tuo-eri-sanat-maara ()
  (interactive)
  (tuo-eri-sanat t))
(global-set-key (kbd "<C-f8>") 'tuo-eri-sanat-maara)

(defun iter-lista-puskurissa (erotin)
  "Muuntaa listan erottimen"
  (interactive "sErotin:")
  (goto-char 1)
  (replace-regexp "[;', \t\n]+" erotin))

;(global-set-key (kbd "<f8>") 'iter-lista-puskurissa)

(defun iter-listat-riveilla-puskurissa (erotin)
  (interactive "sErotin:")
  (goto-char 1)
  (replace-regexp "[;', \t]+" erotin))

;(global-set-key (kbd "<M-f8>") 'iter-listat-riveilla-puskurissa)

(defun iter-desimaalierotin (erotin)
  (interactive "sDesimaalierotin:")
  (goto-char 1)
  (if (eq erotin ".")
      (replace-string "," ".")
    (replace-string "." ",")))

(global-set-key (kbd "<M-f8>") 'iter-listat-riveilla-puskurissa)
(global-set-key (kbd "C-p i") 'iter-lista-puskurissa)


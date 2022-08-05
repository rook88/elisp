
(defun puskuri-taulukkoon (puskuri)
  (interactive "bPuskuri:")
  (switch-to-buffer puskuri)
  (split-string (buffer-string) "\n"))

(defun vertaa-puskuriin (puskuri_2)
  (interactive "bPuskuri 2 :")
  (setq puskuri_1 (buffer-name))
  (setq alkiot_1 (puskuri-taulukkoon puskuri_1))
  (setq alkiot_2 (puskuri-taulukkoon puskuri_2))
  (setq myhash (make-hash-table :test 'equal))
  (dolist (alkio alkiot_1)
    (puthash alkio "1" myhash))
  (dolist (alkio alkiot_2)
    (if (or (string-equal "1" (gethash alkio myhash)) (string-equal "12" (gethash alkio myhash)))
      (puthash alkio "12" myhash)
      (puthash alkio "2" myhash)))
  (defun pullkeys (kk vv)
    (setq allkeys (cons kk allkeys)))
  (defvar allkeys '())
  (setq allkeys '())
  (maphash 'pullkeys myhash)
  (dolist (alkio allkeys)
    (setq joukko (gethash alkio myhash))
    (if (string-equal "1" joukko)
	(setq joukko (concat puskuri_1 "-not-" puskuri_2)))
    (if (string-equal "2" joukko)
	(setq joukko (concat puskuri_2 "-not-" puskuri_1)))
    (if (string-equal "12" joukko)
	(setq joukko (concat puskuri_1 "-and-" puskuri_2)))
    (switch-to-buffer joukko)
    (insert alkio)
    (insert "\n")))

;(global-set-key (kbd "S-<f6>") 'vertaa-puskuriin)

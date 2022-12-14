(setq salasana -1)
(defun kysy-salasana ()
  (if (eq salasana -1)
      (setq salasana (read-passwd "Salasana : ")))
    salasana)

(defun tuo-tiedosto (tiedosto)
  (interactive "sTuodaan tiedosto kehitysmypäristöstä :")
  (find-file "m:/data/siirto/elisp/pohja.ftp")
  (goto-char 0)
  (replace-string "<tiedosto>" tiedosto)
  (goto-char 0)
  (replace-string "<pwd>" (kysy-salasana))
  (write-file "m:/data/siirto/elisp/temp.ftp")
  (kill-buffer "temp.ftp")
  (shell-command "ftp -s:m:/data/siirto/elisp/temp.ftp" )
  (shell-command "del m:\\data\\siirto\\elisp\\temp.ftp" )
  (find-file "m:/data/siirto/elisp/haettu.txt")
  (write-file (concat "m:/data/siirto/elisp/" tiedosto))
  (switch-to-buffer tiedosto))

(defun tuo-hakemisto (hakemisto)
  (interactive "sTuodaan hakemiston jäsenet kehitysmypäristöstä :")
  (find-file "m:/data/siirto/elisp/pohja_dir.ftp")
  (goto-char 0)
  (replace-string "<hakemisto>" hakemisto)
  (goto-char 0)
  (replace-string "<pwd>" (kysy-salasana))
  (write-file "m:/data/siirto/elisp/temp.ftp")
  (kill-buffer "temp.ftp")
  (shell-command "ftp -s:m:/data/siirto/elisp/temp.ftp" )
  (shell-command "del m:\\data\\siirto\\elisp\\temp.ftp" )
  (find-file "m:/data/siirto/elisp/haettu.txt")
  (write-file (concat "m:/data/siirto/elisp/" hakemisto))
  (switch-to-buffer hakemisto))


(defun tuo-sdsf-out ()
  (interactive)
  (tuo-tiedosto "sdsf.out"))

(defun tuo-srchfor-out ()
  (interactive)
  (tuo-tiedosto "srchfor.list"))

(defun tuo-spufi-out ()
  (interactive)
  (tuo-tiedosto "spufi.out")
  (putsaa-sql-tulos))

(defun tuo-tiedosto-pro ()
  (interactive)
  (find-file "m:/data/siirto/elisp/pohja_pro.ftp")
  (goto-char 0)
  (replace-string "<tiedosto>" (setq tiedosto (read-from-minibuffer "Tiedosto: ")))
  (goto-char 0)
  (replace-string "<pwd>" (kysy-salasana))
  (write-file "m:/data/siirto/elisp/temp_pro.ftp")
  (kill-buffer "temp_pro.ftp")
  (shell-command "ftp -s:m:/data/siirto/elisp/temp_pro.ftp" )
  (shell-command "del m:\data\siirto\elisp\temp_pro.ftp" )
  (find-file "m:/data/siirto/elisp/haettu.txt")
  (write-file (concat "m:/data/siirto/elisp/" tiedosto))
  (switch-to-buffer tiedosto))

(defun ftp-lue-host ()
  (completing-read "Host : " '("sysa.oct.fi" "anna.oct.fi")))

(defun ftp-hae-tiedosto ()
  (interactive)
  (find-file "c:/data/siirto/elisp/pohja_ftp.ftp")
  (goto-char 0) (replace-string "<host>" (ftp-lue-host))
  (goto-char 0) (replace-string "<pwd>" (kysy-salasana))
  (goto-char 0) (replace-string "<tiedosto>" (setq tiedosto (read-from-minibuffer "Tiedosto: ")))
  (write-file "c:/data/siirto/elisp/temp_pro.ftp")
  (kill-buffer "temp_pro.ftp")
  (shell-command "ftp -s:c:/data/siirto/elisp/temp_pro.ftp" )
  (delete-file "c:/data/siirto/elisp/temp_pro.ftp")
  (switch-to-buffer tiedosto)
  (insert-file-contents "c:/data/siirto/elisp/haettu.txt"))
 

;(global-set-key (kbd "H-f") 'ftp-hae-tiedosto)

(defun vie-tiedosto ()
  (interactive)
  (write-file "m:/data/siirto/elisp/viety.txt")
  (find-file "m:/data/siirto/elisp/pohja_vie.ftp")
  (goto-char 0)
  (replace-string "<tiedosto>" (setq tiedosto (read-from-minibuffer "Tiedosto: ")))
  (goto-char 0)
  (replace-string "<pwd>" (kysy-salasana))
  (write-file "m:/data/siirto/elisp/temp.ftp")
  (kill-buffer "temp.ftp")
  (shell-command "ftp -s:m:/data/siirto/elisp/temp.ftp" )
  (shell-command "del m:\data\siirto\elisp\temp.ftp" )
  (write-file (concat "m:/data/siirto/elisp/" tiedosto)))


(defun vie-tiedosto-pro ()
  (interactive)
  (write-file "m:/data/siirto/elisp/viety.txt")
  (find-file "m:/data/siirto/elisp/pohja_vie_pro.ftp")
  (goto-char 0)
  (replace-string "<tiedosto>" (read-from-minibuffer "Tiedosto: "))
  (goto-char 0)
  (replace-string "<pwd>" (kysy-salasana))
  (write-file "m:/data/siirto/elisp/temp_pro.ftp")
  (kill-buffer "temp_pro.ftp")
  (shell-command "ftp -s:m:/data/siirto/elisp/temp_pro.ftp" )
  (shell-command "del m:\data\siirto\elisp\temp_pro.ftp" ))

(defun viimeksi-siirretyt ()
  "Luettelee viimeksi siirretyt tiedostot"
  (interactive)
  (shell-command (concat "dir \"m:\\data\\siirto\\elisp\" /b /o:-d"))
  (switch-to-buffer "*Shell Command Output*")
  (goto-char (point-min))
  (insert "m:/data/siirto/elisp/")
  (flush-lines "~")
  (goto-char (point-min))
  (flush-lines "#")
  (write-file (concat "m:/data/siirto/elisp/dir.txt")))

(global-unset-key (kbd "C-f"))
(global-set-key (kbd "C-f t") 'tuo-tiedosto)
(global-set-key (kbd "C-f h") 'tuo-hakemisto)
(global-set-key (kbd "C-f s d") 'tuo-sdsf-out)
(global-set-key (kbd "C-f s p") 'tuo-spufi-out)
(global-set-key (kbd "C-f s f") 'tuo-srchfor-out)
(global-set-key (kbd "C-f v") 'vie-tiedosto)
(global-set-key (kbd "C-f p t") 'tuo-tiedosto-pro)
(global-set-key (kbd "C-f p v") 'vie-tiedosto-pro)

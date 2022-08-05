

(defun on-mjono-leikepoydalla (mjono)
  (interactive "smjono : ")
;  (member mjono (split-string (leikepoyta-merkkijonoksi) "
  (member mjono (split-string (car kill-ring) "
")))

;(on-mjono-leikepoydalla "L")
;(on-mjono-leikepoydalla "L201O01")

(defun merkitse-leikepoydalla-olevat ()
  (interactive)
  (leikepoyta-merkkijonoksi)
  (save-excursion
    (while (search-forward-regexp ".+" nil t)
      (setq uusi (match-string 0))
      (if (on-mjono-leikepoydalla uusi)
	  (insert ";x"))
      (forward-char))))

(defun clipboard-koko ()
  (interactive)
  (with-temp-buffer
    (yank)
    (puskuri-koko)))

(defun clipboard-el-avaa ()
  (interactive)
  (open-module "clipboard.el"))

(defun sensuroi-leikepoyta ()
  (interactive)
  (nayta-leikepoyta)
  (goto-char (point-min))
  (replace-regexp "\\w" "x")
  (leikepoyta-puskurista-puskuri-sulkien))

(defun leikepoyta-merkkijonoksi ()
  (save-excursion
    (set-buffer (get-buffer-create "yank"))
    (yank)
    (kill-buffer "yank"))
  (car kill-ring))

(defun leikepoyta-merkkijonosta (mjono)
  (kill-new mjono)
  (message mjono))

;(leikepoyta-merkkijonosta "abc")

(defun leikepoyta-korvaa-vakio-tagit ()
  (interactive)
  (leikepoyta-merkkijonosta
   (message (merkkijono-korvaa-vakio-tagit
    (leikepoyta-merkkijonoksi)))))

(defun leikepoyta-korvaa-aalto ()
  (interactive)
  (leikepoyta-merkkijonosta
   (message (concat "{{" (leikepoyta-merkkijonoksi) "}}"))))


(defun leikepoyta-korvaa-vakio-mjonot ()
  (interactive)
  (leikepoyta-merkkijonosta
   (message (merkkijono-korvaa-vakio-mjonot
    (leikepoyta-merkkijonoksi)))))

;(merkkijono-korvaa-tagit "Tänään <pvm>, hauskaa päivänjatkoa")

(defun merkkijono-korvaa-vakio-tagit (mjono)
  (replace-regexp-in-string  "<pvm>" (format-time-string "%-d.%-m.%Y")
  (replace-regexp-in-string  "<apvm>" (format-time-string "%Ana %-d.%-m.")
  (replace-regexp-in-string  "<vsvukkpp>" (format-time-string "%Y%m%d")
   mjono))))

;seuraava ei toimi
;(defun merkkijono-korvaa-vakio-mjonot (mjono)
;  (replace-regexp-in-string  "95\\jok" "m:" mjono))
;  (replace-regexp-in-string  "ws000095\\jok" "m:" mjono))
;  (replace-regexp-in-string  "ws000095\\jokemjaa\\$" "m:" mjono))
;  (replace-regexp-in-string  "\\\\ws000095\\jokemjaa\\$" "m:" mjono))

(defun nayta-leikepoyta-puskurissa ()
  (interactive)
  (if (string= (substring (concat (buffer-name) "         ")  0 9) "clipboard")
      (leikepoyta-puskurista-puskuri-sulkien)
    (nayta-leikepoyta)))

(defun nayta-leikepoyta ()
  (interactive)
  (other-window 1)
;  (switch-to-buffer-other-window "clipboard")
  (switch-to-buffer "clipboard")
  (delete-region (point-min) (point-max))
  (yank))

(defun pituus-leikepoyta ()
  (nayta-leikepoyta)
  (setq pituus (length (buffer-string)))
  (insert (concat "\npituus = " (number-to-string pituus))))

(defun leikepoyta-tiedostoon (tiedosto)
  (setq current-directory "m:/data/leikkeet/")
  (interactive "FPaste to File: ")
  (find-file tiedosto)
  (delete-region (point-min) (point-max))
  (yank)
  (save-buffer)
  (kill-buffer (current-buffer))
  (nayta-leikepoyta))

(defun leikepoyta-tiedostosta (tiedosto)
;  (setq current-directory "m:/data/leikkeet/")
  (interactive "fCopy from File: ")
  (find-file tiedosto)
  (leikepoyta-puskurista)
  (kill-buffer (current-buffer))
  (nayta-leikepoyta))

(defun leikepoyta-puskurista ()
  (interactive)
  (kill-new (buffer-string)))

(defun leikepoyta-puskurista-tag-korvaten ()
  "Korvaa <tag> merkinnän erikseen kysyttävällä merkkijonolla leikepöydällä."
  (interactive)
  (leikepoyta-puskurista-nayta)
  (goto-char (point-min))
  (while (search-forward-regexp "<[^>]+>" nil t)
 	(replace-match
	 (read-from-minibuffer (concat (match-string 0) " = "))))
  (leikepoyta-puskurista))

(defun leikepoyta-puskurista-nayta ()
  (interactive)
  (leikepoyta-puskurista)
  (nayta-leikepoyta))

(defun leikepoyta-puskurista-puskuri-tallettaen-sulkien ()
  (interactive)
  (save-buffer)
  (leikepoyta-puskurista-puskuri-sulkien))

(defun leikepoyta-puskurista-puskuri-sulkien ()
  (interactive)
  (kill-new (buffer-string))
  (kill-buffer (current-buffer)))

(defun leike-tiedosto-nimi-puskuri-sulkien ()
  (interactive)
  (leike-tiedosto-nimi)
  (kill-buffer (current-buffer)))

(defun leikepoyta-puskurista-otsikko ()
  (interactive)
  (kill-new (concat "otsikko\n" (buffer-string)))
  (nayta-leikepoyta))

(defun leike-tiedosto-nimi ()
  (interactive)
  (kill-new (buffer-file-name)))


(defun leike-puskuri-nimi ()
  (interactive)
  (kill-new (buffer-name)))

(defun avaa-tiedosto-rivilla ()
  (interactive)
  (beginning-of-line)
  (setq rivin-alku (point))
  (end-of-line)
  (setq rivin-loppu (point))
  (setq nimi (buffer-substring rivin-alku rivin-loppu))
  (find-file nimi))

(defun avaa-tiedosto-leikepoydalla-vanha ()
  (interactive)
  (setq tiedosto (leikepoyta-merkkijonoksi))
  (if (string= ".doc" (substring tiedosto 
		 (- (length tiedosto) 4)
		 (length tiedosto)))
      (browse-url tiedosto)
      (find-file tiedosto)))

(defun avaa-tiedosto-leikepoydalla ()
  (interactive)
  (avaa-tiedosto (leikepoyta-merkkijonoksi)))

;(avaa-tiedosto "https://teamer.tieto.com/3/tesy_terp-raportit/Pages/default.aspx")

(defun avaa-tiedosto (tiedosto)
  (shell-command (concat "explorer " tiedosto)))

(setq leikemuisti (make-hash-table :test 'equal))
(setq leikemuisti-erotin "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n")

(defun leikemuisti-oletus-nayta ()
  (interactive)
  (switch-to-buffer "leikemuisti")
  (setq leikemuisti-oletus-indeksi-temp 0)
  (while (< leikemuisti-oletus-indeksi-temp leikemuisti-oletus-indeksi-in)
    (if (< 0 leikemuisti-oletus-indeksi-temp)
	(insert leikemuisti-erotin))
    (setq leikemuisti-oletus-indeksi-temp (+ 1 leikemuisti-oletus-indeksi-temp))
    (insert   (tuo-leikemuisti (leikemuisti-oletus-avain leikemuisti-oletus-indeksi-temp)))))

(defun leikemuisti-oletus-alusta ()
  (interactive)
  (setq leikemuisti-oletus-indeksi-in 0)
  (setq leikemuisti-oletus-indeksi-out 0)
  (message "oletusleikemuisti alustettu"))
(leikemuisti-oletus-alusta)

(defun leikemuisti-oletus-avain (ind)
  (concat "oletus-" (number-to-string ind)))
;(leikemuisti-oletus-avain 1)

(defun vie-leikemuisti-oletus ()
  (interactive)
  (setq leikemuisti-oletus-indeksi-in (+ 1 leikemuisti-oletus-indeksi-in))
  (vie-leikemuisti (leikemuisti-oletus-avain leikemuisti-oletus-indeksi-in)))

(defun tuo-leikemuisti-oletus ()
  (interactive)
  (setq leikemuisti-oletus-indeksi-out (+ 1 leikemuisti-oletus-indeksi-out))
  (if (> leikemuisti-oletus-indeksi-out leikemuisti-oletus-indeksi-in)
      (setq leikemuisti-oletus-indeksi-out 1))
  (tuo-leikemuisti (leikemuisti-oletus-avain leikemuisti-oletus-indeksi-out)))

(defun vie-leikemuisti (nimi)
  (interactive "sVie leike nimelle : ")
  (puthash nimi (leikepoyta-merkkijonoksi) leikemuisti))

(defun tuo-leikemuisti (nimi)
  (interactive "sTuo leike nimellä : ")
  (leike-aseta-merkkijono (gethash nimi leikemuisti)))

(setq leikepoyta-edellinen "")
(defun iter-arkistoi-leikepoyta ()
  (setq leikepoyta (leikepoyta-merkkijonoksi))
  (iter-check leikepoyta)
  (if (equal leikepoyta leikepoyta-edellinen)
      nil
    (arkistoi-leikepoyta))
    (setq leikepoyta-edellinen leikepoyta))

(defun iter-kasittele-leikepoyta (funktio)
  (setq leikepoyta (leikepoyta-merkkijonoksi))
  (if (equal leikepoyta leikepoyta-edellinen)
      nil
    (funcall funktio leikepoyta))
    (setq leikepoyta-edellinen leikepoyta))

(defun lp-kirjoita (mjono)
  (interactive)
  (message "kirjoitettu")
  (insert mjono))

(defun iter-check (mjono)
  (if (string= (buffer-name) "check")
      (progn
	(goto-char (point-min))
	(replace-string mjono ""))))

;tretyt
;(iter-check "tretyt")

(defun katkaise (merkkijono)
  (substring merkkijono 0 
	     (min 2000 
		  (length merkkijono))))

(defun arkistoi-leikepoyta ()
  (interactive)
  (save-excursion
    (set-buffer "clipboard-archive")
    (goto-char (point-max))
    (insert "------------------------------")
    (insert (format-time-string "%d.%m.%Y %T" (current-time)))
    (insert "------------------------------\n")
    (insert (katkaise (leikepoyta-merkkijonoksi)))
    (insert "\n"))
  (if on-arkistoi-aktiiviseen
     (progn 
       (insert (katkaise (leikepoyta-merkkijonoksi)))
       (insert "\n"))))

(defun aloita-arkistointi ()
  (interactive)
  (nayta-arkisto)
  (set-buffer (get-buffer-create "clipboard-archive"))
  (message "Arkistointi aloitettu")
;  (nayta-arkisto)
  (run-at-time 1 1 'iter-arkistoi-leikepoyta))

(defun aloita-kasittely (funktio)
  (interactive "aKäsittele leikepöytää funktiolla :")
  (run-at-time 1 1 'iter-kasittele-leikepoyta funktio))

(defun lopeta-arkistointi ()
  (interactive)
  (message "Arkistointi lopetettu")
  (cancel-function-timers 'iter-arkistoi-leikepoyta))

(defun lopeta-kasittely ()
  (interactive)
  (message "Käsittely lopetettu")
  (cancel-function-timers 'iter-kasittele-leikepoyta))

(setq on-arkistoi-aktiiviseen nil)

(defun aloita-arkistointi-aktiiviseen ()
  (interactive)
  (setq on-arkistoi-aktiiviseen t)
  (aloita-arkistointi))

(defun lopeta-arkistointi-aktiiviseen ()
  (interactive)
  (setq on-arkistoi-aktiiviseen nil))

(defun nayta-arkisto ()
  (interactive)
  (set-buffer (get-buffer-create "clipboard-archive"))
  (switch-to-buffer "clipboard-archive")
  (goto-char (point-max)))

(defun tuo-aikaleima ()
  (interactive)
  (kill-new
   (format "'%d-%02d-%02d-%02d.%02d.%02d.000000'" 
	  (nth 5 (decode-time (current-time)))
	  (nth 4 (decode-time (current-time)))
  	  (nth 3 (decode-time (current-time)))
	  (nth 2 (decode-time (current-time)))
	  (nth 1 (decode-time (current-time)))
  	  (nth 0 (decode-time (current-time))))))

(defun aikaleima-leikepoydalle ()
  (interactive)
  (setq muoto (completing-read "Muoto : " '(
   "iso_2 == %Y-%m-%d %T"
   "db2 == %Y-%m-%d-%H.%M.%S.000000"
   "sql_server == %Y-%m-%d %H:%M:%S.000"
   "valtuus == %d.%m.%Y KLO %H.%M."
   "iso == %Y-%m-%d"
   "normi == %d.%m.%Y"
   "viikko == %W"
   "cobol_vuosi == %y%m%d"
   "cobol_paiva == %d%m%y"
   "versio == %Y%m%d"
   )))
  (setq muoto-format (nth 1 (split-string muoto " == ")))
  (leike-aseta-merkkijono (format-time-string muoto-format)))


(defun leikepoydan-koko ()
  (interactive)
  (message (concat 
	    "merkkejä : "
	    (number-to-string (length (leikepoyta-merkkijonoksi)))
	    " sanoja : "
	    (number-to-string (length (split-string (leikepoyta-merkkijonoksi) "[ \t\n]+")))
	   "  rivejä : "
	    (number-to-string (length (split-string (leikepoyta-merkkijonoksi) "
"))))))

(defun lisaa-leikepoyta-oikealle ()
  (interactive)
  (setq leikepoydan-rivit 
	(split-string (leikepoyta-merkkijonoksi) "\n"))
  (dolist (rivi leikepoydan-rivit)
    (end-of-line)
    (insert rivi)
    (if (eq 1 (forward-line)) (insert "\n"))))

(defun avaa-liita-sarake-taulukko ()
  (interactive)
;  (browse-url "m:/data/excel/liita_sarake.xltm"))
  (browse-url "m:/data/excel/pohjat"))

(defun lisaa-leikepoyta-puskurin-loppuun ()
  (interactive)
  (setq ed-point (point))
  (goto-char (point-max))
  (insert "\n")
  (kirjoita-viiva)
  (yank)
  (goto-char ed-point))

(defun otsikon-tiedot-leikepoydalle (otsikko)
  "Etsii annetun otsikon jälkeiset tiedot"
  (interactive "sOtsikko : ")
  (save-excursion
    (goto-char (point-min))
    (if (search-forward (concat otsikko ";") nil t)
	(progn
	  (setq alku (point))	
	  (if (search-forward "\n\n" nil t)
	      (setq loppu (point)))
	  (kill-new (substring (buffer-string) alku loppu))))))

(defun leikepoyta-monista (lkm)
  (interactive "sMonista leikepoyta lkm :")
  (if (string= lkm "")
      (setq lkm-int 25)
      (setq lkm-int (number-to-string lkm)))
  (nayta-leikepoyta)
  (setq i 1)
  (while (< i lkm-int)
    (setq i (+ i 1))
    (insert "\n")
    (yank))
  (leikepoyta-puskurista))

(setq leiketiedosto-rivi 99999)

(defun current-line ()
  "Return the vertical position of point..."
  (+ (count-lines (window-start) (point))
     (if (= (current-column) 0) 1 0)))

(defun leiketiedosto-siirry (siirtyma)
  (find-file "m:/data/temp_testi.txt")
  (goto-line (+ leiketiedosto-rivi siirtyma))
  (setq leiketiedosto-rivi (current-line))
  (setq rivi (rivi-merkkijonona))
  (kill-buffer "temp_testi.txt")
  rivi)

(defun leiketiedosto-edellinen ()
  (interactive)
  (leiketiedosto-nayta-rivi (leiketiedosto-siirry -1)))

(defun leiketiedosto-seuraava ()
  (interactive)
  (leiketiedosto-nayta-rivi (leiketiedosto-siirry 1)))

(defun leiketiedosto-nayta-rivi (rivi)
  (switch-to-buffer "leiketiedosto")
  (kill-buffer "leiketiedosto")
  (switch-to-buffer "leiketiedosto")
  (insert rivi)
  (goto-char (point-min))
  (replace-regexp "\\(................................................................................\\)" "\\1
"))

(defun kopioi-alue ()
  "Kopioi valitun alueen"
  (interactive)
  (copy-region-as-kill (mark) (point))
  (message (concat "----- : kopioitu : -----\n" (leikepoyta-merkkijonoksi))))

(setq leike-viimeisin "")
(defun leike-aseta-merkkijono (mjono)
  (message "%s" (kill-new (setq leike-viimeisin mjono))))

(defun leike-aseta-viimeisin-osuma ()
  (interactive)
  (leike-aseta-merkkijono (match-string 0)))

(defun leike-aseta-viimeisin ()
  (interactive)
  (leike-aseta-merkkijono leike-viimeisin))

(defun leike-iter (funktio)
  (interactive "aIteroidaan funktiolla : ")
  (setq leike-iter-last-funktio funktio)
  (leikepoyta-merkkijonosta (funcall funktio (leikepoyta-merkkijonoksi))))

(defun leike-iter-last ()
  (interactive)
  (leikepoyta-merkkijonosta (funcall leike-iter-last-funktio (leikepoyta-merkkijonoksi))))

(defun leike-iter-test (arg)
  (interactive)
  "x")

(defun leikepoyta-grep (regexp)
  (interactive "spoimi leikepöydälle regexp : ")
  (setq puskuri-sisalto (buffer-string))
  (switch-to-buffer "temp-grep")
  (insert puskuri-sisalto)
  (goto-char 0)
  (keep-lines regexp)
  (leikepoyta-merkkijonosta (buffer-string))
  (kill-buffer (current-buffer))
  (nayta-leikepoyta))



(setq leikepoyta-hae-regexp-string "")

(defun leikepoyta-hae-regexp-init (regexp)
  (interactive "sHae regexp leikepöydältä : ")
  (setq leikepoyta-hae-regexp-string regexp)
  (leikepoyta-hae-regexp regexp))

(defun leikepoyta-hae-regexp-iter ()
  (interactive)
  (if (string= leikepoyta-hae-regexp-string "")
    (message "Ei oletushakua")
      (leikepoyta-hae-regexp leikepoyta-hae-regexp-string)))

(defun leikepoyta-hae-regexp (regexp)
  (nayta-leikepoyta)
  (goto-char (point-min))
  (if (re-search-forward regexp 99999 t)
	(leike-aseta-merkkijono (match-string 1))
    (message "Ei osumaa")))

(defun gg-select-all ()
  (interactive)
  (leike-aseta-merkkijono (concat
   "select
    *
from
    " (leikepoyta-merkkijonoksi))))

(defun kasittely-muotoile-sql (mjono)
  (interactive)
  (puskuri-luo-temp)
  (yank)
  (puskuri-muokkaa-sql)
  (leikepoyta-puskurista)
  (kill-buffer (current-buffer)))

(defun evaluoi-leikepoydalle ()
  (interactive)
  (leike-aseta-merkkijono (format "%s" (eval-last-sexp nil))))

;(+ 1 2)

;(global-unset-key (kbd "C-c o"))
(global-unset-key (kbd "C-c"))
(global-unset-key (kbd "<f3>"))

(global-set-key (kbd "C-c g") 'leikepoyta-hae-regexp-init)
(global-set-key (kbd "C-c C-e") 'evaluoi-leikepoydalle)
(global-set-key (kbd "C-c C-g") 'leikepoyta-hae-regexp-iter)
(global-set-key (kbd "C-c + l") 'lisaa-leikepoyta-puskurin-loppuun)
(global-set-key (kbd "C-c + o") 'lisaa-leikepoyta-oikealle)
(global-set-key (kbd "C-c =") 'clipboard-el-avaa)
(global-set-key (kbd "C-c ?") 'clipboard-koko)
(global-set-key (kbd "C-c a +") 'aloita-arkistointi)
(global-set-key (kbd "C-c k +") 'aloita-kasittely)
(global-set-key (kbd "C-c a -") 'lopeta-arkistointi)
(global-set-key (kbd "C-c k -") 'lopeta-kasittely)
(global-set-key (kbd "C-c a =") 'nayta-arkisto)
(global-set-key (kbd "C-c a c +") 'aloita-arkistointi-aktiiviseen)
(global-set-key (kbd "C-c a c -") 'lopeta-arkistointi-aktiiviseen)
(global-set-key (kbd "C-c ?") 'leikemuisti-oletus-nayta)
(global-set-key (kbd "C-c -") 'leikemuisti-oletus-alusta)
(global-set-key (kbd "C-c c") 'vie-leikemuisti-oletus)
(global-set-key (kbd "H-v") 'tuo-leikemuisti-oletus)
(global-set-key (kbd "M-1") 'tuo-leikemuisti-oletus)
(global-set-key (kbd "C-c C-c") 'tuo-leikemuisti-oletus)
;(global-set-key (kbd "M-c") 'tuo-leikemuisti-oletus)
(global-set-key (kbd "C-c h +") 'vie-leikemuisti)
(global-set-key (kbd "C-c h =") 'tuo-leikemuisti)
(global-set-key (kbd "C-c i") 'leike-iter-last)
(global-set-key (kbd "C-c C-i") 'leike-iter-last)
(global-set-key (kbd "C-c l =") 'leikepoydan-koko)
;(global-set-key (kbd "C-c ?") 'leikepoydan-koko)
(global-set-key (kbd "C-c l s") 'avaa-liita-sarake-taulukko)
(global-set-key (kbd "C-c m x") 'merkitse-leikepoydalla-olevat)
(global-set-key (kbd "C-c o t") 'otsikon-tiedot-leikepoydalle)
(global-set-key (kbd "C-c o +") 'leike-aseta-viimeisin-osuma)
(global-set-key (kbd "C-c r") 'kopioi-alue)
(global-set-key (kbd "H-c") 'kopioi-alue)
(global-set-key (kbd "C-c s") 'sensuroi-leikepoyta)
(global-set-key (kbd "C-c C-t") 'aikaleima-leikepoydalle)
(global-set-key (kbd "C-c t s") 'tuo-aikaleima)
(global-set-key (kbd "C-c t k") 'leikepoyta-puskurista-tag-korvaten)
(global-set-key (kbd "C-c t v") 'leikepoyta-korvaa-vakio-tagit)
(global-set-key (kbd "C-c t m") 'leikepoyta-korvaa-vakio-mjonot)
(global-set-key (kbd "C-c *") 'leikepoyta-monista)

(global-set-key (kbd "C-f o c") 'avaa-tiedosto-leikepoydalla)
(global-set-key (kbd "C-c C-o") 'avaa-tiedosto-leikepoydalla)
(global-set-key (kbd "C-c }") 'leikepoyta-korvaa-aalto)
(global-set-key (kbd "<f8>") 'avaa-tiedosto-leikepoydalla)

;(global-set-key (kbd "S-C-<f5>") 'leikepoyta-puskurista-puskuri-sulkien)
(global-set-key (kbd "C-M-<f5>") 'leikepoyta-grep)
(global-set-key (kbd "M-<insert>") 'leikepoyta-grep)
;(global-set-key (kbd "C-M-<f5>") 'leikepoyta-puskurista-puskuri-tallettaen-sulkien)
(global-set-key (kbd "S-M-<f5>") 'leike-tiedosto-nimi-puskuri-sulkien)
(global-set-key (kbd "M-<f5>") 'leike-tiedosto-nimi)
(global-set-key (kbd "<f5>") 'nayta-leikepoyta-puskurissa)
(global-set-key (kbd "<insert>") 'nayta-leikepoyta-puskurissa)
(global-set-key (kbd "s-i") 'nayta-leikepoyta-puskurissa)
(global-set-key (kbd "C-<f5>") 'leike-puskuri-nimi)
(global-set-key (kbd "C-<insert>") 'leikepoyta-puskurista)
(global-set-key (kbd "S-C-<insert>") 'leikepoyta-puskurista-puskuri-sulkien)
;(global-set-key (kbd "C-M-<f5>") 'leikepoyta-puskurista-nayta)

(global-set-key (kbd "<f7>") 'leike-aseta-viimeisin)


;(global-set-key (kbd "<C-M-f5>") 'avaa-tiedosto-leikepoydalla)
(global-set-key (kbd "C-c C-f") 'leikepoyta-tiedostosta)
;(global-set-key (kbd "C-c = b") 'leikepoyta-puskurista)
;(global-set-key (kbd "S-M-<f5>") 'avaa-tiedosto-rivilla)
;(global-set-key (kbd "S-M-<f5>") 'leikepoyta-tiedostoon)


(global-set-key (kbd "<f3> <up>") 'leiketiedosto-edellinen)
(global-set-key (kbd "<f3> <down>") 'leiketiedosto-seuraava)

;elisp_testit_clipboard

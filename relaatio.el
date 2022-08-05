
;
; 
;

(defun relaatio-el-avaa ()
  (interactive)
  (open-module "relaatio.el"))


(defun regex-alkio-pari ()
; rivinvaihto on merkityksellinen
  "^\\([^;]+\\)\\(;?\\)\\(.*?\\)\\(;?\\)\\([^;
]*\\)$")

(defun regex-yhdistelma-pari ()
  "^\\([^_]+\\)\\(_\\)\\(.*\\)")

(defun regex-alkio ()
  "\\([^;]+\\);")

(defun rel-flush-2 (regex)
  (interactive "sPoistetaan 2. sarakkeen tieto :")
  (goto-char (point-min))
  (flush-lines (concat "^" (regex-alkio) regex)))

(defun vasen-puoli (alkio-pari)
  (if (string-match (regex-alkio-pari) alkio-pari)
      (match-string 1 alkio-pari)
    nil))

(defun oikea-puoli (alkio-pari)
  (if (string-match (regex-alkio-pari) alkio-pari)
      (match-string 5 alkio-pari)
    nil))

(defun alkiopari-listana (alkio-pari)
  (cons (vasen-puoli alkio-pari) (cons (oikea-puoli alkio-pari) nil)))

;(alkiopari-listana "x;y")

(defun alkiojono-listana (alkio-jono)
  (split-string alkio-jono ";"))

;(alkiojono-listana "x;y;z;w")

(defun vasen-loput (alkio-pari)
  (if (string-match (regex-alkio-pari) alkio-pari)
      (concat 
       (match-string 1 alkio-pari)
       (match-string 2 alkio-pari)
       (match-string 3 alkio-pari))
    nil))

(defun oikea-loput (alkio-pari)
  (if (string-match (regex-alkio-pari) alkio-pari)
      (concat 
       (match-string 3 alkio-pari)
       (match-string 4 alkio-pari)
       (match-string 5 alkio-pari))
    nil))

(defun vasen-sarake-2 (alkio-pari)
  (if (oikea-loput alkio-pari)
      (vasen-puoli (oikea-loput alkio-pari))
    nil))
  
(defun pida-vasen-puoli ()
  "poistaa muut kuin vasemman sarakkeen"
  (interactive)
  (goto-char (point-min))
  (replace-regexp (regex-alkio-pari) "\\1"))

(defun pida-oikea-puoli ()
  "poistaa muut kuin oikean sarakkeen"
  (interactive)
  (goto-char (point-min))
  (replace-regexp (regex-alkio-pari) "\\5"))

(defun pida-vasen-loput ()
  "poistaa sarakkeen oikealta"
  (interactive)
  (goto-char (point-min))
  (replace-regexp (regex-alkio-pari) "\\1\\4\\3"))

(defun pida-oikea-loput ()
  "poistaa sarakkeen vasemmalta"
  (interactive)
  (goto-char (point-min))
  (replace-regexp (regex-alkio-pari) "\\3\\4\\5"))

(defun siirra-oikea-vasen ()
  "siirt‰‰ oikean sarakkeen vasemmalle"
  (interactive)
  (goto-char (point-min))
  (replace-regexp (regex-alkio-pari) "\\5\\2\\1\\4\\3"))

(defun siirra-vasen-oikea ()
  "siirt‰‰ vasemman sarakkeen oikealle"
  (interactive)
  (goto-char (point-min))
  (replace-regexp (regex-alkio-pari) "\\3\\4\\5\\2\\1"))

(defun vaihda-vasen ()
  (interactive)
  (goto-char (point-min))
  (replace-regexp (regex-alkio-pari) "\\3\\2\\1\\4\\5"))

(defun yhdista-vasen ()
  "yhdist‰‰ vasemman puoleiset sarakkeet"
  (interactive)
  (goto-char (point-min))
  (replace-regexp (regex-alkio-pari) "\\1_\\3\\4\\5"))

(defun yhdista-oikea ()
  "yhdist‰‰ oikean puoleiset sarakkeet"
  (interactive)
  (goto-char (point-min))
  (replace-regexp (regex-alkio-pari) "\\1\\2\\3_\\5"))

(defun yhdista-tyhjat ()
  "yhdist‰‰ v‰lilyˆnnill‰ erotetut merkkijonot"
  (interactive)
  (goto-char (point-min))
  (replace-regexp "^ +" "")
  (goto-char (point-min))
  (replace-regexp " +$" "")
  (goto-char (point-min))
  (replace-regexp " +" "_"))

(defun yhdista-kaikki ()
  "yhdist‰‰ kaikki sarakkeet"
  (interactive)
  (goto-char (point-min))
  (replace-regexp ";" "_"))

(defun erota-vasen ()
  "erottaa vasemman sarakkeen"
  (interactive)
  (goto-char (point-min))
  (replace-regexp (regex-yhdistelma-pari) "\\1;\\3"))

(defun erota-oikea ()
  "erottaa oikean sarakkeen"
  (interactive)
  (goto-char (point-min))
  (replace-regexp "_\\([^_]+\\)$" ";\\1"))

(defun erota-kaikki ()
  "erottaa kaikki sarakkeet"
  (interactive)
  (goto-char (point-min))
  (replace-regexp "_" ";"))

(defun erota-tabulaattorit ()
  "erottaa tabulaattorilla erotetut sarakkeet"
  (interactive)
  (goto-char (point-min))
  (replace-regexp "\t" ";"))

(defun korvaa-kaikki-tabulaattorit ()
  "hakee tabulaattorilla erotetuista sarakkeista ensimm‰isen ja viimeisen"
  (interactive)
  (goto-char (point-min))
  (replace-regexp "\t.*\t" ";"))

(defun tee-relaatio (regex_vasen regex_oikea)
  "etsii puskurin riveilt‰ relaation osumia ja kirjoittaa relaation"
  (interactive "sRegex vasen : \nsRegex oikea : ")
  (setq taulu (split-string (buffer-string) "\n"))
  (switch-to-buffer "relaatio")
  (setq vasen "?")
  (dolist (rivi taulu)
    (if (string-match regex_vasen rivi)
	(setq vasen (match-string 1 rivi)))
    (if (string-match regex_oikea rivi)
	(progn 
	  (setq oikea (match-string 1 rivi))
	  (insert (concat vasen ";" oikea "\n"))))))

(defun tee-relaatio-table ()
  (interactive)
  (tee-relaatio "create table \\([a-z0-9_]+\\)" "\t\\([a-z0-9_]+ \\w+\\)"))

(defun tee-relaatio-srchfor (regex_oikea)
  "tekee relaation isokoneen srchfor tiedostosta"
  (interactive "sRegex oikea : ")
  (tee-relaatio "\\(\\w+\\) +-+ STRING" regex_oikea))

(defun vaihda-puolet ()
  (interactive)
  (setq regex_relaatio "\\([^;]+\\);\\([^;]+\\)") 
  (setq taulu (split-string (buffer-string) "\n"))
  (switch-to-buffer "relaatio")
  (kill-buffer "relaatio")
  (switch-to-buffer "relaatio")
  (dolist (rivi taulu)
    (if (string-match regex_relaatio rivi)
	(progn
	  (setq vasen (match-string 1 rivi))
	  (setq oikea (match-string 2 rivi))
	  (insert (concat oikea ";" vasen "\n"))))))

(defun relaatio-taulukkoon (puskuri)
  (setq regex_relaatio "\\([^;]+\\);\\([^;]+\\)") 
  (setq myhash (make-hash-table :test 'equal))
  (with-current-buffer puskuri 
    (setq taulu (split-string (buffer-string) "\n"))
    (dolist (rivi taulu)
      (if (string-match regex_relaatio rivi)
	  (progn
	    (setq vasen (match-string 1 rivi))
	    (setq oikea (match-string 2 rivi))
	    (puthash vasen oikea myhash))))
    myhash))

(defun relaatio-taulukkoon-2 (puskuri)
  (setq myhash (make-hash-table :test 'equal))
  (with-current-buffer puskuri 
    (setq taulu (split-string (buffer-string) "\n"))
    (dolist (rivi taulu)
      (if (setq vasen (vasen-puoli rivi))
	  (if (setq oikea-loput (oikea-loput rivi))
	      (progn
		(setq oikea (vasen-puoli oikea-loput))
		(setq arvo (oikea-puoli oikea-loput))
		(puthash (concat vasen "_" oikea) arvo myhash)))))
    myhash))

(defun relaatio-taulukkoon-3 (puskuri)
  (setq myhash (make-hash-table :test 'equal))
  (with-current-buffer puskuri 
    (setq taulu (split-string (buffer-string) "\n"))
    (dolist (rivi taulu)
      (if (setq vasen (vasen-puoli rivi))
	  (if (setq oikea-loput (oikea-loput rivi))
	      (progn
		(setq oikea (vasen-puoli oikea-loput))
		(setq arvo (oikea-puoli oikea-loput))
		(if (setq vanha_arvo (gethash (concat vasen "_" oikea) myhash))
		    (puthash (concat vasen "_" oikea) (concat vanha_arvo " " arvo) myhash)
		(puthash (concat vasen "_" oikea) arvo myhash))))))
    myhash))

(defun relaatio-taso-taulukkoon ()
  "muuntaa relaation taulukoksi"
  (interactive)
  (setq arvot (relaatio-taulukkoon-3 (current-buffer)))
  (setq otsikot (nreverse (avaimet-vasen-2 (current-buffer))))
  (setq rivit (nreverse (avaimet-vasen (current-buffer))))
  (with-current-buffer (switch-to-buffer (get-buffer-create (concat "taso-" (buffer-name))))
    (dolist (otsikko otsikot)
      (insert ";")
      (insert otsikko))
    (dolist (vasen rivit)
      (insert "\n")
      (insert vasen)
      (dolist (otsikko otsikot)
	(insert ";")
	(if (setq arvo (gethash (concat vasen "_" otsikko) arvot))
	    (insert arvo)))))
  (buffer-name))

(defun avaimet-vasen (puskuri)
  (setq myhash (make-hash-table :test 'equal))
  (with-current-buffer puskuri 
    (setq taulu (split-string (buffer-string) "\n"))
    (dolist (rivi taulu)
      (if (setq vasen (vasen-puoli rivi))
	      (if (setq arvo (gethash vasen myhash))
		(puthash vasen (+ 1 arvo) myhash)
		(puthash vasen 1 myhash))))
    (setq allkeys '())
    (maphash 'pullkeys myhash)
    allkeys))

(defun avaimet-vasen-2 (puskuri)
  (setq myhash (make-hash-table :test 'equal))
  (with-current-buffer puskuri 
    (setq taulu (split-string (buffer-string) "\n"))
    (dolist (rivi taulu)
      (if (setq vasen (vasen-sarake-2 rivi))
	      (if (setq arvo (gethash vasen myhash))
		(puthash vasen (+ 1 arvo) myhash)
		(puthash vasen 1 myhash))))
    (setq allkeys '())
    (maphash 'pullkeys myhash)
    allkeys))

(defun vanhentunut-pida-vasen-puoli ()
  (interactive)
  (setq regex_relaatio "\\([^;]+\\);\\([^;]+\\)") 
  (setq taulu (split-string (buffer-string) "\n"))
  (switch-to-buffer "avaimet")
  (kill-buffer "avaimet")
  (switch-to-buffer "avaimet")
  (dolist (rivi taulu)
    (if (string-match regex_relaatio rivi)
	(progn
	  (setq vasen (match-string 1 rivi))
	  (insert (concat vasen "\n"))))))


(defun tuo-relaatiosta (puskuri)
  (interactive "bHae oikea puoli relaatiosta : ")
;  (setq nykyinen (current-buffer))
  (setq myhash (relaatio-taulukkoon puskuri))
;  (switch-to-buffer nykyinen)
  (setq taulu (split-string (buffer-string) "\n"))
;  (get-buffer-create (concat (current-buffer) "-" puskuri))
;  (get-buffer-create (concat "xxx"))
;  (switch-to-buffer (concat "x" (buffer-name puskuri)))
  (switch-to-buffer (concat (buffer-name) "-rel"))
  (dolist (rivi taulu)
    (if (gethash rivi myhash)
	(insert (concat rivi ";" (gethash (vasen-puoli rivi) myhash)) "\n")
;	(insert (concat rivi ";" (gethash rivi myhash)) "\n")
      (insert (concat rivi ";?\n")))))

(defun korvaa-relaatiosta (tiedosto)
  (interactive "fKorvaa relaatiosta : ")
  (find-file tiedosto)
  (setq parit (split-string (buffer-string) "\n"))
  (kill-buffer (current-buffer))
  (setq regex_relaatio "\\([^;]+\\);\\([^;]+\\)") 
  (dolist (rivi parit)
    (if (string-match regex_relaatio rivi)
	(progn
	  (setq vasen (match-string 1 rivi))
	  (setq oikea (match-string 2 rivi))
	  (goto-char 0)
	  (replace-regexp vasen oikea)))))  

(defun tuplaa-oikea (puskuri)
  (interactive "bKopioidaan oikea puoli relaatiossa : ")
  (switch-to-buffer puskuri)
  (goto-char 0)
  (replace-regexp "\\(\.*;\\)?\\(.*\\)$" "\\1\\2;\\2"))

(defun lisaa-sana-loppuun (sana)
  (interactive "sLis‰‰ rivin loppuun sana")
  (goto-char 0)
  (replace-regexp "$" sana))

(defun tee-indikaattori-relaatio ()
  (interactive)
  (setq puskuri (buffer-name))
  (rename-buffer (concat "ind" puskuri))
  (goto-char (point-min))
  (replace-regexp "$" (concat ";" puskuri)))

(defun yhdista (a b)
  (concat a " " b))

(defun regex-relaatio ()
  (setq regex_relaatio "\\([^;]+\\);\\([^;]+\\)"))

(defun pullkeys (kk vv)
  (setq allkeys (cons kk allkeys)))

(defun relaatio-funktioi-yhdista ()
  (interactive)
  (relaatio-funktioi 'yhdista))

(defun relaatio-funktioi (funktio)
  (interactive "aFunktioi relaatio funktiolla : ")
  (setq taulu (split-string (buffer-string) "\n"))
  (switch-to-buffer (concat "fun-" (buffer-name)))
  (setq myhash (make-hash-table :test 'equal))
  (dolist (rivi taulu)
    (if (string-match (regex-relaatio) rivi)
	(progn
	  (setq vasen (match-string 1 rivi))
	  (setq oikea (match-string 2 rivi))
	  (if (gethash vasen myhash)
	      (puthash vasen (funcall funktio (gethash vasen myhash) oikea) myhash)
	      (puthash vasen oikea myhash)))))
  (setq allkeys '())
  (maphash 'pullkeys myhash)
  (dolist (vasen allkeys)
    (setq oikea (gethash vasen myhash))
    (insert (concat vasen ";" oikea "\n"))))

(defun vanhentunut-tuo-oikealle-puolelle ()
  (interactive)
  (goto-char (point-min))
  (replace-regexp "$" 
		  (concat ";" (read-from-minibuffer "Lis‰‰ oikea puoli : "))))

(defun lisaa-oikea-puoli-merkkijono ()
  (interactive)
  (replace-regexp "$" 
		  (concat ";" (read-from-minibuffer "Lis‰‰ oikea puoli : "))))

(defun lisaa-vasen-puoli-merkkijono ()
  (interactive)
  (goto-char (point-min))
  (replace-regexp "^" 
		  (concat (read-from-minibuffer "Lis‰‰ vasen puoli : ") ";")))

(defun lisaa-vasen-puoli-jarjestysnumero ()
  (interactive)
  (goto-char (point-min))
  (setq rivino 1)
  (insert (concat (number-to-string rivino) ";"))
  (while (search-forward-regexp "^" nil t)
    (setq rivino (+ 1 rivino))
    (insert (concat (number-to-string rivino) ";"))))

(defun lisaa-vasen-puoli-jarjestysnumero-reg (reg)
  (interactive "sregexp:")
  (goto-char (point-min))
  (setq rivino 1)
  (insert (concat (number-to-string rivino) ";"))
  (while (search-forward-regexp (concat "^" reg) nil t)
    (setq rivino (+ 1 rivino))
    (insert (concat (number-to-string rivino) ";"))))

(defun lisaa-oikea-puoli-jarjestysnumero ()
  (interactive)
  (goto-char (point-min))
  (end-of-line)
  (setq rivino 1)
  (insert (concat ";" (number-to-string rivino)))
  (while (search-forward-regexp "^" nil t)
    (setq rivino (+ 1 rivino))
    (end-of-line)
    (insert (concat ";" (number-to-string rivino)))))

(defun lisaa-oikea-puoli-jarjestysnumero-reg (reg)
  (interactive "sregexp:")
  (goto-char (point-min))
  (end-of-line)
  (setq rivino 1)
  (insert (concat ";" (number-to-string rivino)))
  (while (search-forward-regexp (concat "^" reg) nil t)
    (setq rivino (+ 1 rivino))
    (end-of-line)
    (insert (concat ";" (number-to-string rivino)))))

(defun avaa-testi-tiedosto ()
  (interactive)
  (find-file "m:/data/relaatiot/testi.rel"))

(defun avaa-muistiinpanot ()
  (interactive)
  (find-file "m:/data/relaatiot/muistiinpanot.txt"))

(defun nimea-relaatioksi ()
  (interactive)
  (rename-buffer 
   (concat
    "rel-"
    (format-time-string "%Y-%m-%d-%H.%M.%S" (current-time)))))

(defun muuta-erotin (erotin)
  (interactive "sErotin (oletus SPC):")
  (if (string= erotin "")
    (setq erotin " "))
  (goto-char (point-min))
  (replace-regexp (concat "^\\(.*?\\)" erotin) "\\1;"))

(defun relaatio-grep (grep-mjono)
  (interactive "sGrep relaatiosta : ")
  (goto-char (point-min))
  (keep-lines (concat ";" grep-mjono ";"))
  (goto-char (point-min))
  (replace-string  (concat ";" grep-mjono ";") ";"))

(defun relaatio-lisaa-riveja ()
  (interactive)
  (insert
   (with-temp-buffer
     (yank)
     (goto-char 0)
     (lisaa-oikea-puoli-merkkijono)
     (buffer-string))))

(defun relaatio-grep-lines (regexp)
  (interactive "srelaatio grep : (1=2) ")
  (setq sisalto (buffer-string))
  (switch-to-buffer (concat (buffer-name) "-" regexp))
  (insert sisalto)
  (goto-char (point-min))
  (keep-lines "^[^;]*;\\(.*\\);\\1"))

(defun relaatio-flush-lines (regexp)
  (interactive "srelaatio flush : (1=2) ")
  (setq sisalto (buffer-string))
  (switch-to-buffer (concat (buffer-name) "-" regexp))
  (insert sisalto)
  (goto-char (point-min))
  (flush-lines "^[^;]*;\\(.*\\);\\1"))

(global-unset-key (kbd "C-r"))

(global-set-key (kbd "C-r =") 'relaatio-el-avaa)
(global-set-key (kbd "C-r +") 'relaatio-lisaa-riveja)
;(global-set-key (kbd "<f9>") 'tee-relaatio)
(global-set-key (kbd "C-r r") 'tee-relaatio)
(global-set-key (kbd "C-r s f") 'tee-relaatio-srchfor)
;(global-set-key (kbd "<S-C-f9>") 'tuplaa-oikea)
;(global-set-key (kbd "<C-f9>") 'pida-vasen-puoli)
(global-set-key (kbd "C-r ?") 'tuo-relaatiosta)
(global-set-key (kbd "C-r o t") 'tuo-relaatiosta)
;(global-set-key (kbd "<S-M-f9>") 'korvaa-relaatiosta)
;(global-set-key (kbd "C-r v o") 'vaihda-puolet)
(global-set-key (kbd "C-r v =") 'pida-vasen-puoli)
(global-set-key (kbd "C-r o +") 'lisaa-oikea-puoli-merkkijono)
(global-set-key (kbd "C-r C-<right>") 'lisaa-oikea-puoli-merkkijono)
(global-set-key (kbd "C-r v +") 'lisaa-vasen-puoli-merkkijono)
(global-set-key (kbd "C-r C-<left>") 'lisaa-vasen-puoli-merkkijono)
(global-set-key (kbd "C-r n") 'lisaa-vasen-puoli-jarjestysnumero)
(global-set-key (kbd "C-r C-n") 'lisaa-oikea-puoli-jarjestysnumero)

(global-set-key (kbd "C-r g") 'relaatio-grep)
(global-set-key (kbd "C-r C-g") 'relaatio-grep-lines)
(global-set-key (kbd "C-r C-f") 'relaatio-flush-lines)

(global-set-key (kbd "C-r v =") 'pida-vasen-puoli)
(global-set-key (kbd "C-r o =") 'pida-oikea-puoli)
(global-set-key (kbd "C-r o -") 'pida-vasen-loput)
(global-set-key (kbd "C-r <right> -") 'pida-vasen-loput)
(global-set-key (kbd "C-r v -") 'pida-oikea-loput)
(global-set-key (kbd "C-r 1 -") 'pida-oikea-loput)
(global-set-key (kbd "C-r <left> -") 'pida-oikea-loput)
(global-set-key (kbd "C-r - 1") 'pida-oikea-loput)
(global-set-key (kbd "C-r o v") 'siirra-oikea-vasen)
(global-set-key (kbd "C-r <right> <left>") 'siirra-oikea-vasen)
(global-set-key (kbd "C-r v o") 'siirra-vasen-oikea)
(global-set-key (kbd "C-r <left> <right>") 'siirra-vasen-oikea)
(global-set-key (kbd "C-r v _") 'yhdista-vasen)
(global-set-key (kbd "C-r o _") 'yhdista-oikea)
(global-set-key (kbd "C-r SPC _") 'yhdista-tyhjat)
(global-set-key (kbd "C-r ; _") 'yhdista-kaikki)
(global-set-key (kbd "C-r v ;") 'erota-vasen)
(global-set-key (kbd "C-r _ s") 'erota-vasen)
(global-set-key (kbd "C-r o s") 'erota-oikea)
(global-set-key (kbd "C-r o ;") 'erota-oikea)
(global-set-key (kbd "C-r o ;") 'erota-oikea)
(global-set-key (kbd "C-r TAB ;") 'erota-tabulaattorit)
(global-set-key (kbd "C-r <C-tab>") 'korvaa-kaikki-tabulaattorit)
(global-set-key (kbd "C-r 1 2") 'vaihda-vasen)
(global-set-key (kbd "C-r SPC _") 'yhdista-tyhjat)

(global-set-key (kbd "C-r t =") 'avaa-testi-tiedosto)
(global-set-key (kbd "C-r m =") 'avaa-muistiinpanot)

(global-set-key (kbd "C-r f y") 'relaatio-funktioi-yhdista)
(global-set-key (kbd "C-r t t") 'relaatio-taso-taulukkoon)
(global-set-key (kbd "C-r d") 'nimea-relaatioksi)

(global-set-key (kbd "C-r SPC ;") 'muuta-erotin)
(global-set-key (kbd "C-r - 2") 'rel-flush-2)

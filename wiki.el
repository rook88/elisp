;
(if (string= (system-name) "Jaakko-MacBook-Pro.local")
    (defvar wiki-sivu-polku "~/Google Drive/Oma Drive/wiki/" "*wiki sivujen kirjasto")
    (defvar wiki-sivu-polku "c:/wiki/sivut/" "*wiki sivujen kirjasto"))

(defvar wiki-el "c:/wiki/elisp/wiki.el" "wiki.el moduulin sijainti")
;(defvar wiki-avaa-sivu-toimet 'wiki-varita-sivut "*sivun avaukseen liittyvä funktio")
(defvar wiki-avaa-sivu-toimet nil "*sivun avaukseen liittyvä funktio")
(defvar wiki-avaa-tyhja-sivu-toimet nil "*Tyhjän sivun avaukseen liittyvä funktio")

(defvar wiki-kaikki-sanat nil "lista, joka sisältää kaikki wiki sivut")

(defvar wiki-regexp-sana ".A-Za-zÅÄÖåäö0-9_-" "*merkit, jotka muodostavat sanan")
(defvar wiki-regexp-paivamaara "^\\([0-9]+\\)\\.\\([0-9]+\\)\\.\\([0-9]+\\)" "Regexp, joka tunnistaa päivämäärän") 

(make-face 'wiki-linkki)

(set-face-attribute 'wiki-linkki nil :underline t)

; (wiki-ylasivu-nimi "testi_abc_xyz")

(defun wiki-ylasivu-nimi (sivu-nimi)
  (setq tulos nil)
  (dolist (osa (reverse (cdr (reverse (wiki-sivun-nimen-osat sivu-nimi)))) tulos)
    (if tulos
	(setq tulos (concat tulos "_" osa))
      (setq tulos osa))))

(setq wiki-favorite-sivu nil)

(defun wiki-favorite-aseta ()
  (interactive)
  (setq wiki-favorite-sivu (buffer-name)))

(defun wiki-favorite-avaa ()
  (interactive)
  (other-window 1)
  (wiki-avaa-sivu wiki-favorite-sivu))

(defun wiki-favorite-linkita ()
  (interactive)
  (setq nykyinen-sivu (buffer-file-name))
  (wiki-favorite-avaa)
  (save-excursion
    (goto-char (point-max))
    (insert "\n")
    (insert (wiki-linkki-sivulle nykyinen-sivu))))

(defun wiki-avaa-sivu (sivu &optional samassa)
  "Avaa syötteenä annetun wiki sivun"
  (interactive "sAvaa wiki sivu : ")
  (if (equal (substring sivu 0 1) "_")
      (setq sivu-avattava (concat (buffer-name) sivu))
 (if (equal (substring sivu 0 1) "-")
      (setq sivu-avattava (concat (wiki-ylasivu-nimi (buffer-name)) "_" (substring sivu 1 (length sivu))))
      (setq sivu-avattava sivu)))
  (if samassa
      nil
    (other-window 1))
;  (find-file (concat wiki-sivu-polku sivu-avattava))
  (wiki-avaa-tiedosto (concat wiki-sivu-polku sivu-avattava))
  (if wiki-avaa-sivu-toimet
      (funcall wiki-avaa-sivu-toimet))
  (if (wiki-aktiivinen-puskuri-on-tyhja)
      (if wiki-avaa-tyhja-sivu-toimet 
	  (wiki-tee-toimet wiki-avaa-tyhja-sivu-toimet))))

(defun wiki-avaa-tiedosto (tiedosto)
;  (if (string-match "\\(.+\\)\\.\\(\\w+\\)" tiedosto)
;      (browse-url tiedosto) ;message (concat "tyyppi" (match-string 2 tiedosto)))
  (find-file tiedosto))

(defun wiki-tee-toimet (toimet)
  "Kutsutaan annettuja funktioita"
  (setq iter-toimet toimet)
  (while iter-toimet
    (setq toimi (car iter-toimet))
    (setq iter-toimet (cdr iter-toimet))
    (funcall toimi)))

(defun wiki-lisaa-leikepoyta ()
  "Lisätään leikepöytä, jos sivulla on merkkijono 'leikepöytä:'"
  (goto-char (point-min))
  (if (search-forward "leikepöytä:" nil t)
      (progn
	(insert "\n")
	(yank))))

(defun wiki-mallipohjan-tiedot (malli)
  "Hakee mallipohjasta tiedot"
  (find-file (concat wiki-sivu-polku "mallipohja_" malli))
  (setq paluu (buffer-string))
  (kill-buffer (current-buffer))
  (if (string= "" paluu)
      nil
    paluu))

(defun wiki-sivun-nimen-osat (sivu)
  "Lista sivun nimen osista"
  (if (< 1 (length (setq paluu (split-string sivu "_"))))
      paluu))

(defun wiki-tuo-mallipohjan-tiedot ()
  "Haetaan mallipohjista tiedot sivulle"
  (if (setq nimen-osat (wiki-sivun-nimen-osat (buffer-name)))
      (if (string= (nth 0 nimen-osat) "mallipohja")
	  nil
	(setq haettu nil)
	(dolist (nimen-osa (reverse nimen-osat) nil)
	  (if (not haettu)
	      (progn
		(setq haettu (wiki-mallipohjan-tiedot nimen-osa))
		(if haettu (insert haettu))))))))

(defun wiki-avaa-sivu-leikepoydalla ()
  "Avaa sivun, joka on leikepoydalla"
  (interactive)
  (wiki-avaa-sivu (leikepoyta-merkkijonoksi)))

(defun wiki-aktiivinen-puskuri-on-sivu ()
  "Tosi, jos aktiivinen puskuri on sivu"
  (string= (file-name-directory (buffer-file-name)) wiki-sivu-polku))

(defun wiki-aktiivinen-puskuri-on-tyhja ()
  "Tosi, jos aktiivinen puskuri on tyhja"
  (string= (buffer-string) ""))

(defun wiki-ylasivu (sivu)
  "Palauttaa ylasivun nimen, joka on viimeisen _ merkkiin saakka sivun nimessä"
  (if (string-match "^\\(.*\\)_" sivu)
      (match-string 1 sivu)))

(defun wiki-avaa-ylasivu ()
  "Avaa sivun, jonka nimi on ylasivun nimi"
  (interactive)
  (if (wiki-aktiivinen-puskuri-on-sivu)
      (if (setq ylasivu (wiki-ylasivu (buffer-name)))
	  (wiki-avaa-sivu ylasivu)
	(message "Yläsivua ei ole"))
  (message "Et ole wiki-sivulla")))
			   
(defun wiki-avaa-ylasivu-tallenna-ja-sulje ()
  "Avaa sivun, jonka nimi on viimeisen _ merkkiin saakka aktiivisen sivun nimessä, sulkee tallentae aktiivisen puskurin"
  (interactive)
  (if (string= (file-name-directory (buffer-file-name)) wiki-sivu-polku)
      (progn 
	(string-match "^\\(.*\\)_" (buffer-name))
	(if (setq ylasivu (match-string 1 (buffer-name)))
	    (message "Yläsivua ei ole"))
	(wiki-tallenna-ja-sulje)
	(wiki-avaa-sivu ylasivu))
    (message "Et ole wiki-sivulla")))
			   
(defun wiki-avaa-paivamaara ()
  "Avaa kursoirin kohdalla olevan päiväkirjamerkinnän"
  (interactive)
  (setq sana (wiki-sana-tassa))
  (if (string-match wiki-regexp-paivamaara sana)
      (wiki-avaa-sivu 
       (concat "pk_" 
	       (format "%04d" (string-to-number (match-string 3 sana)))
	       (format "%02d" (string-to-number (match-string 2 sana)))
	       (format "%02d" (string-to-number (match-string 1 sana)))))
  (message "Ei päivämäärää kursorin kohdalla")))

(defun wiki-avaa-paivamaara-kalenterista ()
  "Avaa kalenterissa kursorin kohdalla olevan päivän päiväkirjan"
  (interactive)
  (if (string= (buffer-name) "*Calendar*")
  (wiki-avaa-sivu 
   (format "pk_04%d%02d%02d" 
	   (extract-calendar-year (calendar-cursor-to-date t))
	   (extract-calendar-month (calendar-cursor-to-date t))
	   (extract-calendar-day (calendar-cursor-to-date t))))
  (message (concat "Et ole kalenterissa, vaan puskurissa " (buffer-name)))))

(defun wiki-avaa-paivamaara-seuraava ()
  "Jos aktiivinen puskuri on päiväkirjan sivu, niin avaa seuraavan päivän sivun"
  (interactive)
  (wiki-avaa-paivamaara-lisays 1))

(defun wiki-avaa-paivamaara-edellinen ()
  "Jos aktiivinen puskuri on päiväkirja sivu, niin avaa edellisen päivän sivun"
  (interactive)
  (wiki-avaa-paivamaara-lisays -1))

(defun wiki-avaa-paivamaara-lisays (lisays)
  (if (string-match "^pk_\\([0-9]+\\)" (buffer-name))
      (progn
	(setq pvm (match-string 1 (buffer-name)))
	(setq pvm_seuraava (wiki-pvm-lisaa pvm lisays))
	(wiki-avaa-sivu (concat "pk_" pvm_seuraava)))
  (message "Aktiivinen puskuri ei ole päiväkirja sivu!")))

(defun wiki-pvm-lisaa (pvm lisays)
  "Lisää päivämäärään lisäyksen osoittaman määrän päiviä"
; toteutus on aika sekava, mutta päivämäärien käsittelyyn ei taida olla apuvälineitä elispissä
  (setq pvm-viiva 
	(concat
	 (substring pvm 0 4) "-"
	 (substring pvm 4 6) "-"
	 (substring pvm 6 8)))
  (format-time-string "%Y%m%d" 
		     (time-add 
		      (date-to-time (concat pvm-viiva " 0:0:0")) 
		      (days-to-time lisays))))

(defun wiki-avaa-sivu-kasin ()
  "Avataan sivu antamalla sivun nimi"
  (interactive)
  (wiki-avaa-sivu
     (completing-read "sivu : " wiki-kaikki-sanat)))

(defun wiki-linkki-sivulle (sivu)
  (if (string= (file-name-directory sivu) wiki-sivu-polku)
    (file-name-nondirectory sivu)
    sivu))

(defun wiki-linkita-sivulle ()
  "Lisätään nykyisen sivun linkki kysytylle sivulle"
  (interactive)
  (setq nykyinen-sivu (buffer-file-name))
  (wiki-avaa-sivu-kasin)
  (save-excursion
    (goto-char (point-max))
    (insert "\n")
    (insert (wiki-linkki-sivulle nykyinen-sivu))))

(defun wiki-linkita-toiseen-ikkunaan ()
  "Lisätään nykyisen sivun linkki toiseen ikkunaan"
  (interactive)
  (setq nykyinen-sivu (buffer-file-name))
  (save-excursion
    (other-window 1)
    (insert (wiki-linkki-sivulle nykyinen-sivu))
    (insert "\n")
    (other-window -1)))

(defun wiki-linkita-paivakirjaan ()
  "Lisää aktiivisen sivun tämän päivän päiväkirjan loppuun"
  (interactive)
  (setq nykyinen-sivu (buffer-file-name))
  (wiki-avaa-paivakirja)
  (save-excursion
    (goto-char (point-max))
    (insert "\n")
    (insert (wiki-linkki-sivulle nykyinen-sivu))))

(defun wiki-linkita-paivakirjaan-huominen ()
  "Lisää aktiivisen sivun huomisen päivän päiväkirjan loppuun"
  (interactive)
  (setq nykyinen-sivu (buffer-file-name))
  (wiki-avaa-paivakirja-huominen)
  (save-excursion
    (goto-char (point-max))
    (insert "\n")
    (insert (wiki-linkki-sivulle nykyinen-sivu))))

(defun wiki-linkita-todo ()
  (interactive)
  (setq nykyinen-sivu (buffer-file-name))
  (wiki-avaa-sivu "todo")
  (save-excursion
    (goto-char (point-max))
    (insert "\n")
    (insert (wiki-linkki-sivulle nykyinen-sivu))))


(defun wiki-nayta-wiki-el ()
  "Avaa wiki.el tiedoston"
  (interactive)
  (open-module "wiki.el"))

(defun wiki-sanan-alkuun ()
  "Siirrytään wiki-sanan alkuun"
  (if (search-backward-regexp (concat "[^" wiki-regexp-sana "]") nil t)
      nil
    (goto-char (point-min))))

(defun wiki-sanan-loppuun ()
  "Siirrytään wiki-sanan loppuun. Sivuvaikutuksena etsittiin sana."
  (search-forward-regexp (concat "[" wiki-regexp-sana "]+")))

(defun wiki-sana-tassa ()
  "määrittää kursorin kohdalla olevan sanan"
  (interactive)
  (save-excursion
    (wiki-sanan-alkuun)
    (wiki-sanan-loppuun)
    (setq alku (- (match-beginning 0) 1))
    (setq loppu (match-end 0)))
  (setq sana (substring (buffer-string) alku (- loppu 1)))
  (message sana))

(defun wiki-avaa-sivu-sana-tassa (&optional samassa-ikkunassa)
  "Avaa sanan kohdalla olevan wiki sivun"
  (interactive)
  (setq sivu (wiki-sana-tassa))
  (if (string= (substring (concat (buffer-name) "    ") 0 4) "temp")
      (kill-buffer (current-buffer)))
  (wiki-avaa-sivu sivu samassa-ikkunassa))

(defun wiki-avaa-sivu-sana-tassa-ikkunassa ()
  "Avaa sanan kohdalla olevan wiki sivun samassa ikkunassa"
  (interactive)
  (wiki-avaa-sivu-sana-tassa t))

(defun wiki-avaa-moduuli-sana-tassa ()
  "Avaa sanan kohdalla olevan wiki sivun ja lisää aktiivien sivun päätteen"
  (interactive)
  (setq sivu (wiki-sana-tassa))
  (if (string-match "\\(\\.[^.]+$\\)" (buffer-name))
      (progn
	(setq paate (match-string 1 (buffer-name)))
	(wiki-avaa-sivu (concat sivu paate)))))

(defun wiki-avaa-sivu-sana-tassa-iter ()
  "Jos kursorin kohdalla oleva sanaa päättyy lukuun, niin funktio kasvattaa lukua yhdellä, kirjoittaa uuden sanan ja avaa vastaava sivun"
  (interactive)
  (if (setq sana_iteroitu (wiki-iteroi-sivu (wiki-sana-tassa)))
      (progn
	(end-of-line)
	(insert "\n")
	(insert sana_iteroitu)
	(wiki-avaa-sivu-sana-tassa))
    (message "Kursorin kohdalla ei ole iteroitavaa sanaa!")))

(defun wiki-iteroi-sivu (sivu)
  "Kasvattaa sanan päässä ennen päätettä olevaa lukua. Palauttaa nil, jos lukua ei ole"
  (if (string-match "^\\(.*\\)_\\([^_]+\\)$" sivu)
      (progn (setq alku (match-string 1 sivu))
      (if (setq uusi (wiki-iteroi-sana (match-string 2 sivu)))
	  (concat alku "_" uusi)))))

(defun wiki-avaa-sivu-sanan-alku (n)
  (interactive "nAvaa sivun alku (n) :")
  (if (wiki-sana-tassa) 
      (wiki-avaa-sivu (wiki-sana-alku (wiki-sana-tassa) n))))

(defun wiki-avaa-sivu-sanan-alku-1 ()
  (interactive)
  (wiki-avaa-sivu-sanan-alku 1))

(defun wiki-avaa-sivu-sanan-alku-2 ()
  (interactive)
  (wiki-avaa-sivu-sanan-alku 2))

(defun wiki-avaa-sivu-sanan-alku-3 ()
  (interactive)
  (wiki-avaa-sivu-sanan-alku 3))


;(wiki-sana-alku "xxx_ccc_sss" 2)
;(wiki-sana-alku "xxx_ccc_sss" 4)

(defun wiki-sana-alku (sana n)
  (setq ali-sanat (split-string sana "_"))
  (setq sana-alku nil)
  (dotimes (x n sana-alku)
    (if ali-sanat
	(if sana-alku
	(setq sana-alku (concat sana-alku "_" (pop ali-sanat)))
	(setq sana-alku (pop ali-sanat))))))


(defun wiki-iteroi-sana (sana)
  "Palauttaa sanan seuraajan"
  (setq seuraajat '(("Varma" "E-F") ("E-F" "Veritas") ("Veritas" "Alandia") ("Alandia" "Varma")))
  (if (string-match "^[0-9]+$" sana)
      (number-to-string (+ 1 (string-to-number sana)))
    (if (setq pari (assoc sana seuraajat))
	(nth 1 pari))))


(defun wiki-tiedosto-paate (tiedosto)
  "Palauttaa merkkijonossa viimeisen pisteen ja sitä seuraavat merkit"
  (if (string-match "\\(\\.[^.]+$\\)" tiedosto)
      (match-string 1 tiedosto)))

(defun wiki-kaikki-sanat-taulukossa ()
  "Palauttaa kaikki wikin sanat taulukossa"
  (wiki-avaa-sivu "kaikki_sanat")
  (setq paluu (split-string (buffer-string) "\n"))
  (kill-buffer (current-buffer))
  paluu)

(defun wiki-paivita-kaikki-sanat ()
  "Päivittää muuttujaan wiki-kaikki-sanat kaikki wikin sanat"
  (interactive)
  (shell-command (concat "dir \"" wiki-sivu-polku "\" /b /o:-d"))
  (switch-to-buffer "*Shell Command Output*")
  (goto-char (point-min))
  (flush-lines "~")
  (goto-char (point-min))
  (flush-lines "#")
  (write-file (concat wiki-sivu-polku "kaikki_sanat"))
  (kill-buffer (current-buffer))
  (setq wiki-kaikki-sanat (wiki-kaikki-sanat-taulukossa)))

(defun wiki-temp-puskuri ()
  (switch-to-buffer (get-buffer-create (format-time-string "temp-%T"))))

(defun wiki-suodata-sanat (regexp)
  "Listaa annettuun säännölliseen lausekkeeseen sopivat sanat"
  (interactive "sListaa sivut regexp:")
  (setq temp (wiki-temp-puskuri))
  (setq suodatetut (directory-files wiki-sivu-polku nil regexp))
  (dolist (sana suodatetut nil)
    (if (member "~" (split-string sana ""))
	nil
	(insert (concat sana "\n")))))

(defun wiki-avaa-kaikki-sanat ()
  "Avaa kaikki wiki sanat muokkausjärjestyksessä tuorein ensin"
  (interactive)
  (wiki-paivita-kaikki-sanat)
  (other-window 1)
  (wiki-avaa-sivu "kaikki_sanat"))

(defun wiki-listaa-alisivut-aktiivisesta ()
  "Listaa aktiivisen sivun alisivut"
  (interactive)
  (wiki-listaa-alisivut (buffer-name)))

(defun wiki-listaa-alisivut (sivu)
  "Listaa aktiivisen sivun alisivut"
  (interactive)
  (wiki-suodata-sanat (concat "^" sivu)))


(defun wiki-avaa-kehitysideat ()
  "Avaa sivun wiki_kehitysideat"
  (interactive)
  (wiki-avaa-sivu "wiki_kehitysideat"))

(defun wiki-avaa-elisp-kokeilut ()
  "Avaa sivun elisp_kokeilut"
  (interactive)
  (wiki-avaa-sivu "elisp_kokeilut"))

(defun wiki-avaa-testit ()
  "Avaa sivun wiki_testit"
  (interactive)
  (wiki-avaa-sivu "wiki_testit"))

(defun wiki-varita-sivut ()
  "Värittää sanat, joita vastaa wiki sivu"
  (interactive)
  (facemenu-remove-all (point-min) (point-max))
  (save-excursion
    (goto-char (point-min))
    (while (search-forward-regexp (concat "[" wiki-regexp-sana "]+") nil t)
      (if (or 
	   (member (match-string 0) wiki-kaikki-sanat) 
	   (member (concat (buffer-name) (match-string 0)) wiki-kaikki-sanat))
	  (facemenu-set-face 'wiki-linkki
			     (match-beginning 0)
			     (match-end 0))))))

(defun wiki-avaa-paivakirja ()
  "Avaa kuluvan päivän päivämäärän päiväkirjan"
  (interactive)
  (wiki-avaa-sivu (concat "pk_" (format-time-string "%Y%m%d"))))

(defun wiki-avaa-paivakirja-huominen ()
  "Avaa huomisen päivän päivämäärän päiväkirjan"
  (interactive)
  (wiki-avaa-sivu (concat "pk_" (format-time-string "%Y%m%d" (time-add (current-time) (days-to-time 1))))))

(defun wiki-avaa-viikonpaiva ()
  "Avaa kuluvan päivän viikonpäivän päiväkirjan"
  (interactive)
  (wiki-avaa-sivu (concat "pk_" (format-time-string "%A"))))

(defun wiki-linkita-paivakirjaan-ja-sulje ()
  (interactive)
  (wiki-linkita-paivakirjaan)
  (other-window -1)
  (wiki-tallenna-ja-sulje))

(defun wiki-tallenna-ja-sulje ()
  "Tallentaa aktiivisen puskurin, sulkee sen ja vaihtaa ikkunaa"
  (interactive)
  (save-buffer)
  (kill-buffer (current-buffer))
  (other-window -1))

(defun wiki-sulje-ja-siirry ()
  "Sulkee aktiivisen puskurin ja vaihtaa ikkunaa"
  (interactive)
  (kill-buffer (current-buffer))
  (other-window -1))

(defun wiki-sulje ()
  "Sulkee aktiivisen puskurin, ei vaihda ikkunaa"
  (interactive)
  (kill-buffer (current-buffer)))

(defun wiki-aja-ohjelma ()
  "Ajaa kursorin kohdalla olevan ohjelman"
  (interactive)
  (setq ohjelma (wiki-sana-tassa))
  (setq komento (wiki-ohjelma-komento ohjelma))
  (if komento
      (progn
	(shell-command komento)
	(other-window 1)
	(switch-to-buffer "*Shell Command Output*")
	(message (concat "ajetaan:" komento)))
    (message (concat "ohjelman : " ohjelma " ajo ei onnistu"))))

(defun wiki-tallenna-ja-aja-ohjelma ()
  "Tallentaa aktiivisen puskurin ja ajaa siinä olevan ohjelman"
  (interactive)
  (save-buffer)
  (setq ohjelma (buffer-name))
  (setq komento (wiki-ohjelma-komento ohjelma))
  (shell-command komento)
  (other-window 1)
  (switch-to-buffer "*Shell Command Output*"))

(defun wiki-ohjelma-komento (ohjelma)
  "Palauttaa tiedoston päätteen mukaan komennon, jolla tiedosto ajetaan oikealla ohjelmalla"
  (interactive)
  (setq komento nil)
  (if (string-match "\\.py$" ohjelma)
   (setq komento (concat "C:\\Python27\\python " wiki-sivu-polku ohjelma)))
;      (setq komento (concat "python " wiki-sivu-polku))) 
  (if (string-match "\\.rexx$" ohjelma)
      (setq komento (concat "C:\\Regina\\rexx " wiki-sivu-polku ohjelma)))
  komento)

(defun wiki-help ()
  "Avaa wiki funktioiden kuvauksen apropos komennon avulla"
  (interactive)
  (command-apropos "wiki")
  (setq help-tiedot (buffer-string))
  (kill-buffer (current-buffer))
  (other-window 1)
  (switch-to-buffer "*Wiki-help*")
  (insert help-tiedot)
  (goto-char (point-min))
  (replace-regexp "
 +" ";")
  (goto-char (point-min))
  (keep-lines "wiki")
  (goto-char (point-min))
  (replace-regexp "\\(^wiki[a-z-]+\\)\\( \\|\t\\)+" "\\1;"))

(defun wiki-kopioi-sivu-leikepoydalle ()
  (interactive)
  (wiki-avaa-sivu-sana-tassa t)
  (leike-aseta-merkkijono (buffer-string))
  (kill-buffer (current-buffer)))

(defun wiki-avaa-kopioi-sivu-leikepoydalle ()
  (interactive)
  (wiki-avaa-sivu-kasin)
  (leike-aseta-merkkijono (buffer-string))
  (kill-buffer (current-buffer)))

(defun wiki-vie-loput-sivulle ()
  (interactive)
  (setq loput (substring (buffer-string) (point) (- (point-max) 1)))
  (wiki-avaa-sivu-sana-tassa)
  (goto-char (point-max))
  (insert "\n")
  (insert loput))

(defun wiki-grep (grep-merkkijono)
  (interactive "sgrep:")
; window tyylinen polku
  (setq uusi-puskuri (concat "grep-" grep-merkkijono))
  (message (concat "luodaan " uusi-puskuri))
  (setq grep-polku "C:\\cygwin\\bin\\grep")
; unix tyylinen polku
;  (setq grep-tiedostot "C:/wiki/sivut/")
; cygwin tyylinen polku
  (setq grep-tiedostot "/cygdrive/c/wiki/sivut/")
  (setq grep-parametrit "-r -l -i")
  (shell-command (concat grep-polku
			 " " grep-parametrit
			 " " grep-merkkijono
			 " " grep-tiedostot))
  (other-window 1)
  (switch-to-buffer "*Shell Command Output*")
  (rename-buffer uusi-puskuri)
  (goto-char (point-min))
;  (replace-string grep-tiedostot ""))
  (replace-regexp "^.*/" ""))

(defun wiki-todo ()
  (interactive)
  (wiki-avaa-sivu "todo")
  (wiki-grep "todo"))

(defun wiki-tulosta-alisivut ()
  (interactive)
  (shell-command (concat "type " (buffer-file-name) "*")))

(global-unset-key (kbd "M-w"))
(global-unset-key (kbd "C-w"))
(global-set-key (kbd "C-w -")      'kill-region) 

(global-set-key (kbd "C-w =")      'wiki-nayta-wiki-el)

(global-set-key (kbd "C-w C-q")    'wiki-sulje-ja-siirry)
(global-set-key (kbd "C-w q")      'wiki-sulje)
(global-set-key (kbd "C-w C-w")    'wiki-avaa-sivu-sana-tassa)
(global-set-key (kbd "C-w w")      'wiki-avaa-sivu-sana-tassa-ikkunassa)
(global-set-key (kbd "C-w RET")    'wiki-tallenna-ja-sulje)

(global-set-key (kbd "C-w _")      'wiki-listaa-alisivut-aktiivisesta)
(global-set-key (kbd "C-w <down>")      'wiki-listaa-alisivut-aktiivisesta)

(global-set-key (kbd "C-w + C-w")  'wiki-vie-loput-sivulle)

(global-set-key (kbd "C-w a c")    'wiki-avaa-sivu-leikepoydalla)
(global-set-key (kbd "M-w M-c")    'wiki-avaa-sivu-leikepoydalla)
(global-set-key (kbd "C-w a e k")  'wiki-avaa-elisp-kokeilut)
(global-set-key (kbd "C-w a k i")  'wiki-avaa-kehitysideat)
(global-set-key (kbd "C-w a t")    'wiki-avaa-testit)
(global-set-key (kbd "C-w a k s")  'wiki-avaa-kaikki-sanat)
(global-set-key (kbd "M-w M-a")  'wiki-avaa-kaikki-sanat)
(global-set-key (kbd "C-w a r")    'wiki-suodata-sanat)
(global-set-key (kbd "M-w g")    'wiki-suodata-sanat)
(global-set-key (kbd "C-w a s")    'wiki-avaa-sivu-kasin)
(global-set-key (kbd "M-w M-w")    'wiki-avaa-sivu-kasin)

(global-set-key (kbd "C-w C-c")    'wiki-kopioi-sivu-leikepoydalle)
;(global-set-key (kbd "M-c")        'wiki-avaa-kopioi-sivu-leikepoydalle)

(global-set-key (kbd "C-w <up>")   'wiki-avaa-ylasivu)
(global-set-key (kbd "C-w <C-up>") 'wiki-avaa-ylasivu-tallenna-ja-sulje)

(global-set-key (kbd "C-w f +")    'wiki-favorite-aseta)
(global-set-key (kbd "C-w f =")    'wiki-favorite-avaa)
(global-set-key (kbd "C-w f l")    'wiki-favorite-linkita)

(global-set-key (kbd "C-w g")      'wiki-grep)

(global-set-key (kbd "C-w i")      'wiki-avaa-sivu-sana-tassa-iter)

(global-set-key (kbd "C-w h")      'wiki-help)

(global-set-key (kbd "C-w l p")    'wiki-linkita-paivakirjaan)
(global-set-key (kbd "C-w l h")    'wiki-linkita-paivakirjaan-huominen)
(global-set-key (kbd "C-w l s")    'wiki-linkita-sivulle)
(global-set-key (kbd "C-w l <right>")    'wiki-linkita-toiseen-ikkunaan)

(global-set-key (kbd "C-w m")      'wiki-avaa-moduuli-sana-tassa)

(global-set-key (kbd "C-w o a")    'wiki-aja-ohjelma)
(global-set-key (kbd "C-w o s")    'wiki-tallenna-ja-aja-ohjelma)

(global-set-key (kbd "C-w s v")    'wiki-varita-sivut)

;(global-set-key (kbd "C-w p =")    'wiki-avaa-paivakirja)
;(global-set-key (kbd "C-w p a")    'wiki-avaa-paivakirja)
(global-set-key (kbd "C-w C-p")    'wiki-avaa-paivakirja)
(global-set-key (kbd "C-w p l")    'wiki-avaa-paivamaara)
(global-set-key (kbd "C-w p p")    'wiki-avaa-paivamaara-kalenterista)
(global-set-key (kbd "C-w p RET")  'wiki-linkita-paivakirjaan-ja-sulje)
(global-set-key (kbd "C-w p s")    'wiki-avaa-paivamaara-seuraava)
(global-set-key (kbd "C-w p +")    'wiki-avaa-paivamaara-seuraava)
(global-set-key (kbd "C-w p e")    'wiki-avaa-paivamaara-edellinen)
(global-set-key (kbd "C-w p -")    'wiki-avaa-paivamaara-edellinen)
(global-set-key (kbd "C-w p v")    'wiki-avaa-viikonpaiva)

(global-set-key (kbd "C-w t a")    'wiki-tulosta-alisivut)
(global-set-key (kbd "C-w t d")    'wiki-todo)
(global-set-key (kbd "C-w + t d")    'wiki-linkita-todo)

(global-set-key (kbd "C-w 1")    'wiki-avaa-sivu-sanan-alku-1)
(global-set-key (kbd "C-w 2")    'wiki-avaa-sivu-sanan-alku-2)
(global-set-key (kbd "C-w 3")    'wiki-avaa-sivu-sanan-alku-3)

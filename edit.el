
(defvar etumerkit nil)

(defun avaa-temp ()
  (interactive)
  (if (string= "temp-muistiinpanot" (buffer-name))
      (progn
	(save-buffer "temp-muistiinpanot")
	(kill-buffer "temp-muistiinpanot"))
    (progn
      (find-file "C:/temp/temp-muistiinpanot")
      (puskuri-kaanna t)
      (goto-char (point-max)))))

(defun siirry-ylos-korostaen ()
  "Poistaa kursorin rivin korostuksen, siirtyy ylˆs ja korostaa uuden rivin."
  (interactive)
  (korosta-rivi-pois)
  (previous-line)
  (korosta-rivi "yellow"))

(defun siirry-alas-korostaen ()
  "Poistaa kursorin rivin korostuksen, siirtyy alas ja korostaa uuden rivin."
  (interactive)
  (korosta-rivi-pois)
  (next-line)
  (korosta-rivi "yellow"))

(defun korosta-rivi (&optional vari)
  "V‰ritt‰‰ kursorin rivin keltaiseksi"
  (interactive)
  (if vari
      nil
    (setq vari "light green"))
  (facemenu-set-background vari (line-beginning-position) (line-end-position)))

(defun korosta-rivi-pois ()
  "V‰ritt‰‰ kursorin rivin valkoiseksi"
  (interactive)
  (facemenu-set-background "white" (line-beginning-position) (line-end-position)))

(defun lisaa-rivi ()
  (interactive)
  (insert "\n")
  (if etumerkit
      (insert etumerkit)))

(defun lisaa-rivi-leikepoyta ()
  (interactive)
  (insert "\n")
  (yank))

(defun rivi-etumerkiksi ()
  (interactive)
  (setq etumerkit (rivi-merkkijonoksi)))

(defun etumerkit-tyhjenna ()
  (interactive)
  (setq etumerkit ""))

(defun rivin-pituus ()
   (- (line-end-position) (line-beginning-position)))

(defun rivi-siisti ()
  (interactive)
  (replace-regexp " +" " " nil (line-beginning-position) (line-end-position)))

(defun rivi-siisti-kunnolla ()
  (interactive)
  (replace-regexp "‰" "a" nil (line-beginning-position) (line-end-position))
  (replace-regexp "ˆ" "o" nil (line-beginning-position) (line-end-position))
  (replace-regexp "[^a-z0-9_]" "_" nil (line-beginning-position) (line-end-position))
  (replace-regexp "[ _]+" "_" nil (line-beginning-position) (line-end-position)))

(defun edit-el-avaa ()
  "avaa edit.el moduulin"
  (interactive)
  (open-module "edit.el"))

(defun kommentoi ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (insert ";")))

(defun kommentoi-kopioi ()
  (interactive)
  (beginning-of-line)
  (kill-line)
  (insert ";")
  (yank)
  (insert "\n")
;  (yank))
  (yank))

(defun poista-loput-puskurista ()
  (interactive)
  (kill-region (point) (point-max)))

(defun poista-kaikki-puskurista ()
  (interactive)
  (goto-char (point-min))
  (kill-region (point) (point-max))
  (kill-new ""))

(defun tuplaa-rivi ()
  (interactive)
  (save-excursion 
    (setq rivin-teksti (rivi-merkkijonona))
    (end-of-line)
    (insert "\n")
    (insert rivin-teksti)))

(defun tuplaa-rivit (maara)
  (interactive "nKopioitavien rivien maara : ")
  (setq alku (line-beginning-position))
  (dotimes (temp maara nil)
    (forward-line))
  (setq rivit (substring (buffer-string) (- alku 1) (- (point) 1)))
  (insert rivit)
)

(defun monista-rivi (kerrat)
  (interactive "nMonista rivi (x kertaa) :")
  (save-excursion 
    (setq rivin-teksti (rivi-merkkijonona))
    (end-of-line)
    (dotimes (x kerrat)
      (insert "\n")
      (insert rivin-teksti))))

(defun siirra-rivi-ylos ()
  (interactive)
  (setq paikka-rivilla (- (point) (line-beginning-position)))
  (beginning-of-line)
  (if (eq (char-after (point)) 10)
      nil
    (progn 
      (kill-line)
      (if (char-after (point))
	  (delete-char 1))
      (forward-line -1)
      (yank)
      (insert "\n")
      (forward-line -1)
      (forward-char paikka-rivilla))))

(defun siirra-rivi-alas ()
  (interactive)
  (setq paikka-rivilla (- (point) (line-beginning-position)))
;  (if (eq (char-after (point)) 10)
;      nil
    (progn 
      (beginning-of-line)
      (kill-line)
      (delete-char 1)
      (end-of-line)
      (insert "\n")
      (yank)
      (insert "\n")
      (delete-char 1)
      (forward-line -1)
      (forward-char paikka-rivilla)))
;)

(defun poista-rivi ()
  (interactive)
  (beginning-of-line)
  (kill-line)
  (kill-line))

(defun rivi-merkkijonoksi ()
  (substring 
   (buffer-string)
   (- (line-beginning-position) 1)
   (- (line-end-position) 1)))


(defun poimi-rivi ()
  (interactive)
  (setq rivi-mjono (rivi-merkkijonoksi))
  (save-excursion
    (set-buffer (get-buffer-create "poimitut"))
    (insert rivi-mjono)))

(defun poimi-ja-poista-rivi ()
  (interactive)
  (poimi-rivi)
  (poista-rivi))


(defun kirjoita-viiva ()
  (interactive)
  (insert "--------------------------------------------------------------------------------\n"))

(defun tuplaa-kappale ()
  "Kopioi alueen kursorin rivin alusta kappaleen loppuun"
  (interactive)
  (beginning-of-line)
  (re-search-forward "\\(\\(.+\\)\n\\)+" 99999 t)
  (kill-new (match-string 0))
  (forward-char)
  (yank))

(defun kirjoita-aikaleima ()
  (interactive)
  (insert (format-time-string "%d.%m.%Y %T" (current-time))))

(defun kirjoita-aikaleima-pvm ()
  (interactive)
  (insert (format-time-string "%d.%m.%Y : " (current-time))))

(defun kirjoita-vsvukkpp ()
  (interactive)
  (insert (format-time-string "%Y%m%d" (current-time))))


(defun poista-vasemmalta-merkkiin (merkki)
  (interactive "sPoistetaan vasemmalta merkkiin : ")
  (goto-char (point-min))
  (replace-regexp (concat "^.*?" merkki) merkki))

(defun puskuri-tasaa-oikealta ()
  (interactive)
  (setq puskurin-rivit (split-string (buffer-string) "\n"))
  (setq max-pituus 0)
  (mapcar '(lambda (x) (if (> (length x) max-pituus) (setq max-pituus (length x)))) puskurin-rivit)
  (goto-char (point-min))
  (end-of-line)
  (insert-char 32 (- max-pituus (rivin-pituus)))
  (while (eq 0 (forward-line)) 
    (end-of-line)
    (insert-char 32 (- max-pituus (rivin-pituus)))))

(defun poista-oikealta-1-merkki ()
  (interactive)
  (goto-char (point-min))
  (replace-regexp ".$" ""))

(defun puskuri-tasaa-rivit (pituus)
  (interactive "nTastaan puskuri. Anna puskurin leveys : ")
  (set-fill-column pituus)
  (fill-region (point-min) (point-max)))

(defun vaknot-hipsuta ()
  "Lis‰‰ hipsut ja pilkut luetteloon sek‰ sulut ymp‰rille"
  (interactive)
  (goto-char (point-min))
  (replace-regexp "\\(.*\\)" ",'\\1'")
  (set-fill-column 60)
  (fill-region (point-min) (point-max))
  (insert ")")
  (goto-char (point-min))
  (delete-char 1)
  (insert "("))
  

(defun rivit-hipsuta ()
  "Lis‰‰ hipsut ja pilkut luetteloon"
  (interactive)
  (goto-char (point-min))
  (replace-regexp "\\(.*\\)" ",'\\1'"))

(defun putsaa-sql-ecxelista ()
  (interactive)
  (goto-char (point-min))
  (replace-string "\"" " ")
  (goto-char (point-min))
  (keep-lines "."))

(defun putsaa-hipsut ()
  (interactive)
  (goto-char (point-min))
  (keep-lines "\\w")
  (goto-char (point-min))
  (replace-string "\"" ""))

(defun taulukko-temp-puskuriin (taulu)
  (luo-temp-puskuri)
  (dolist (rivi taulu nil)
    (insert rivi)
    (insert "\n")))

; t‰m‰n voi poistaa, koska puskuri.el kirjastossa on funktio puskuri-luo-temp, mutta t‰m‰ saataa olla jossain k‰ytˆss‰
(defun luo-temp-puskuri (&optional samaan-puskuriin)
  (interactive)
  (if (not samaan-puskuriin)
      (other-window 1))
  (switch-to-buffer (get-buffer-create (format-time-string "temp-%T"))))

(defun luo-temp-puskuri-taustalle ()
  (set-buffer (get-buffer-create (format-time-string "temp-%T"))))

(defun nimea-temp-puskuri ()
  (interactive)
  (write-file (concat "c:/temp/" (format-time-string "temp_%Y_%m_%d_%H%M%S"))))

(defun tyhjenna-puskuri ()
  (interactive)
  (goto-char (point-min))
  (delete-char (- (point-max) (point-min))))

(defun putsaa-takanollat ()
  "poistaa tiedoston lopusta nollat (t‰sm‰lleen 8 nollaa ja tyhj‰t)"
  (interactive)
  (goto-char (point-min))
  (replace-regexp " +\*?[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] ?$" ""))

(defun putsaa-sql-muunna-lista-in ()
  "Muuntaa listan muotoon, jota voi k‰ytt‰‰ in m‰‰reen kanssa eli muodossa '55-1A', '55-1B' ...
'551-E', ..."
  (interactive)
  (iter-lista-puskurissa "', '")
  (goto-char (point-min))
  (insert "'")
  (goto-char (point-max))
  (insert "'")
  (puskuri-tasaa-rivit 60))

(defun putsaa-sql-csv-avaa ()
  "Siistii csv; muotoisen sql poiminnan ja avaa sen Exceliss‰"
  (putsaa-sql-csv)
  (write-file "m:/data/siirto/elisp/temp.csv")
  (avaa-excelissa))

(defun putsaa-sql-csv ()
  "siistii sql-lauseen tuloksen, jossa on csv; tunniste poimittujen rivien alussa"
  (interactive)
  (goto-char (point-min))
  (keep-lines "^csv")
  (goto-char (point-min))
  (replace-regexp "^csv;" "")
  (goto-char (point-min))
  (replace-string " " ""))

(defun putsaa-sql-csv-tasoon ()
  "siistii sql-lauseen, jossa csv; suoraan tasotaulukkoon"
  (interactive)
  (putsaa-sql-csv)
  (relaatio-taso-taulukkoon))

(defun putsaa-sql-tulos ()
  "siisii sql-lauseen tuloksen"
  (interactive)
  (goto-char (point-min))
  (flush-lines "^---------\\+")
  (goto-char (point-min))
  (flush-lines "^DSNE")
  (goto-char (point-min))
  (replace-regexp " +[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$" "")
  (replace-regexp " +" " "))

(defun sisenna-sql ()
  (interactive)
  (downcase-region (point-min) (point-max))
  (goto-char (point-min))
  (replace-regexp "\\(delete\\|select\\|from\\|where\\)" "\n\\1\n        "))

;(tasaa-rivit 1)

(setq toimeksianto "")
(defun toimeksianto-aseta ()
  (interactive)
  (setq toimeksianto (read-from-minibuffer "Toimeksianto:")))

(defun toimeksianto-lisays-leikepoydalle ()
  (interactive)
  (setq paluu (concat "<< Toim. " toimeksianto " >>
<</ Toim. " toimeksianto " >>"))
  (kill-new paluu))

(defun toimeksianto-poisto-leikepoydalle ()
  (interactive)
  (setq paluu (concat "<< Toim. " toimeksianto ", poistettu >>
<</ Toim. " toimeksianto ", poistettu >>"))
  (kill-new paluu))
  

(defun goto-fibo-iter ()
  (interactive)
  (setq puskurin-koko (- (point-max) (point-min)))
  (setq phii (/ (- (sqrt 5) 1) 2))
  (setq uusi-point (+ (point) (round (* phii puskurin-koko))))
  ( if (> uusi-point puskurin-koko)
      (setq uusi-point (- uusi-point puskurin-koko)))
  (goto-char uusi-point))

(defun lorem-ipsum-puskuriin (maara)
  "Lis‰‰ puskuriin annetun merkkim‰‰r‰n satunnaista teksti‰"
  (interactive "nLorem Ipsum merkkej‰ : ")
  (open-module "lorem_ipsum.txt")
  (setq teksti (substring (buffer-string) 0 maara))
  (kill-buffer (current-buffer))
  (insert teksti))

(defun lorem-ipsum-relaatio ()
  (interactive)
  (find-file "m:/data/elisp/lorem_ipsum.rel"))


(defun korvaa-omat-rivilla ()
  "Korvaa rivill‰ olevat itse m‰‰ritetyt merkkijono"
  (interactive)
  (replace-string "\\\\esyfs01\\asiakas\\" "S:\\" nil (line-beginning-position) (line-end-position)))
  
(defun korvaa-rivi-regexp-leikepoydalla ()
  (interactive)
  (setq korvaava (leikepoyta-merkkijonoksi))
  (goto-char (point-min))
  (replace-regexp "\\(.*\\)" korvaava))

(defun korvaa-rivi-regexp (korvaava)
  (interactive "sKorvaa rivit regexp : ")
  (goto-char (point-min))
  (replace-regexp "\\(.*\\)" korvaava))


(defun kopioi-rivi-toiseean-ikkunaan ()
  (interactive)
  (setq mjono (rivi-merkkijonona))
  (other-window 1)
  (insert mjono)
  (insert "\n")
  (other-window -1)
  (forward-line))

(defun kirjoita-ellipsis-toiseen-ikkunaan ()
  (interactive)
  (other-window 1)
  (insert "...\n")
  (other-window -1))

(defun kopioi-rivi-toiseen-ikkunaan-vakio-tagit-korvaten ()
  (interactive)
  (setq mjono (rivi-merkkijonona))
  (other-window 1)
  (insert (merkkijono-korvaa-vakio-tagit mjono))
  (insert "\n")
  (other-window -1)
  (forward-line))

(defun kopioi-rivi-toisesta-ikkunasta ()
  (interactive)
  (other-window 1)
  (setq mjono (rivi-merkkijonona))
  (forward-line)
  (other-window -1)
  (insert mjono)
  (insert "\n"))

(defun lisaa-rivi-toiseen-ikkunaan ()
  (interactive)
  (other-window 1)
  (insert "\n")
  (other-window -1))

(defun lisaa-leike-toiseen-ikkunaan ()
  (interactive)
  (other-window 1)
  (yank)
  (other-window -1))

(defun lisaa-rivi-aikaleimalla-tunti ()
  (interactive)
  (insert "\n")
  (insert (format-time-string "%H:%M:%S ")))

(defun lisaa-rivi-aikaleimalla-paiva ()
  (interactive)
  (insert "\n")
  (insert (format-time-string "%Y-%m-%d ")))

(defun lisaa-rivi-aikaleimalla ()
  (interactive)
  (insert "\n")
  (insert (format-time-string "%Y-%m-%d-%H.%M.%S ")))

(defun siirry-rivi-alas-toisessa-ikkunassa ()
  (interactive)
  (other-window 1)
  (forward-line)
  (other-window -1))

(defun siirry-rivi-ylos-toisessa-ikkunassa ()
  (interactive)
  (other-window 1)
  (forward-line -1)
  (other-window -1))

; alla oleva ei toimi
(defun toggle-truncate ()
  (interactive)
  (setq truncate-partial-width-windows nil)
  (if truncate-lines
      (progn
	(setq truncate-lines nil)
	(message "Katkaistaan rivit"))
    (progn
	(setq truncate-lines t)
	(message "Ei katkaista rivej‰"))))

(defun puskuri-siirra-toiseen-ikkunaan ()
  (interactive)
  (setq nykyinen (current-buffer))
  (next-buffer)
  (other-window 1)
  (switch-to-buffer nykyinen))

(defun korvaa-rivi-toisessa-ikkunassa (regexp)
  (interactive "korvaa rivi toisessa ikkunassa regexp:")
  (other-window 1)
  (goto-char (point-min))
  (replace-regexp "\\(.*\\)" regexp)
  (other-window -1))

(defun korosta-puolipiste-otsikot ()
  (interactive)
  (highlight-regexp ".+;" 'hi-yellow))
;(korvaa-rivi-toisessa-ikkunassa "*\\1*")

(defun korvaa-kaikkialta (r1 r2)
  (goto-char (point-min))
  (replace-regexp r1 r2))

(defun korvaa-ajojono-osakas-x ()
  (interactive)
  (korvaa-kaikkialta "^B." "BX"))

(defun korvaa-kenoviiva-vinoviiva ()
  (interactive)
  (korvaa-kaikkialta "\\\\" "/"))

(defun korvaa-vinoviiva-kenoviiva ()
  (interactive)
  (korvaa-kaikkialta "/" "\\\\"))

(defun rivi-leikepoydalle-hipsuissa ()
  (interactive)
  (leike-aseta-merkkijono (concat "='" (rivi-merkkijonona) "'")))

(defun rivi-leikepoydalle ()
  (interactive)
  (leike-aseta-merkkijono (rivi-merkkijonona))
  (forward-line))

(defun keep-words (erotin sana)
  (interactive "skeep erotin:\nskeep sana:")
  (goto-char (point-min))
  (replace-string erotin "
")
  (goto-char (point-min))
  (keep-lines sana)
  (goto-char (point-min))
  (replace-string "
" erotin))
  

(defun puskuri-kaanna (&optional ala-nimea)
  (interactive)
  (setq mjono (mapconcat 'identity (nreverse (split-string (buffer-string) "")) ""))
  (if (not ala-nimea)
      (switch-to-buffer (concat (buffer-name) "-rev"))
    (delete-region (point-min) (point-max)))
  (insert mjono))

(defun puskuri-kaanna-rivit (&optional ala-nimea)
  (interactive)
  (setq mjono (mapconcat 'identity (nreverse (split-string (buffer-string) "\n")) "\n"))
  (if (not ala-nimea)
      (switch-to-buffer (concat (buffer-name) "-rev"))
    (delete-region (point-min) (point-max)))
  (insert mjono))

(defun puskuri-lisaa-mjono-rivien-loppuun (mjono)
  (interactive "smjono : ")
  (save-excursion
    (goto-char (point-min))
    (replace-regexp "$" mjono)))

(defun puskuri-lisaa-mjono-rivien-alkuun (mjono)
  (interactive "smjono : ")
  (save-excursion
    (goto-char (point-min))
    (replace-regexp "^" mjono)))

(defun poista-puskurin-loppu ()
  (interactive)
  (kill-region (point) (point-max)))

(defun poista-puskurin-alku ()
  (interactive)
  (kill-region (point) (point-min)))

(defun poista-rivin-alku ()
  (interactive)
  (kill-region (line-beginning-position) (point)))

(defun puskuri-loppu-leikepoydalle ()
  (interactive)
  (leike-aseta-merkkijono 
   (buffer-substring (point) (point-max))))
;todo alku, rivin alku, rivin loppu

(defun puskuri-jarjesta ()
  (interactive)
  (sort-lines nil (point-min) (point-max)))

(defun puskuri-kopioi ()
  (interactive)
  (setq teksti (buffer-string))
  (other-window 1)
  (switch-to-buffer "check")
  (insert teksti))

(defun kirjoita-tehtavamerkki ()
  (interactive)
  (insert "[ ]"))

(defun puskuri-kaanna-hetut ()
  (interactive)
  (goto-char (point-min))
  (replace-regexp "^\\([0-9][0-9]\\)\\([0-9][0-9]\\)\\([0-9][0-9]\\)-" "\\3\\2\\1-"))
	    


(defun comment-line ()
  (interactive)
  (save-excursion
    (beginning-of-line)
    (if (string= (string (char-after (point))) "#")
	(delete-char 1)
      (insert "#"))))

(defun insert-variable ()
  (interactive)
  (insert "${}")
  (backward-char))


(defun own-replace-regexp ()
  (interactive)
  (goto-char 0)
  (end-of-line)
  (setq malli-mjono (substring (buffer-string) 0 (- (point) 1)))
  (setq malli-rivi (leikepoyta-merkkijonoksi))
  (if (and
       (> (length malli-rivi) (length malli-mjono))
       (> (length malli-mjono) 2) 
       (not (string= (buffer-name) "clipboard"))
       (string= (read-from-minibuffer "Replace from clipboard : ") "y")
)
      (progn
	(setq regex (replace-regexp-in-string  malli-mjono "\\\\1" malli-rivi))
	(goto-char 0)
	(replace-regexp "\\(.*\\)" regex))
    (progn
      (goto-char 0)
    (command-execute 'replace-regexp))))


(global-set-key (kbd "M-3") 'comment-line)
(global-set-key (kbd "M-4") 'insert-variable)



(global-unset-key (kbd "C-o"))
(global-unset-key (kbd "C-l"))
;(global-unset-key (kbd "M-c"))
;(global-unset-key (kbd "C-o e"))
;(global-set-key (kbd "<M-C-f9>") 'poista-rivi)		
(global-set-key (kbd "M-c M-c") 'rivi-leikepoydalle)
(global-set-key (kbd "M-c <right>") 'rivi-leikepoydalle)
(global-set-key (kbd "C-l C-r") 'korvaa-rivi-regexp)		

(global-set-key (kbd "<S-C-f2>") 'keep-words)		
(global-set-key (kbd "<M-f11>") 'tuplaa-rivi)		
;(global-set-key (kbd "M-l") 'tuplaa-rivi)		
(global-set-key (kbd "<S-C-down>") 'siirra-rivi-alas)		
;(global-set-key (kbd "<S-f11>") 'siirra-rivi-alas)		
;(global-set-key (kbd "<S-f9>") 'poimi-ja-poista-rivi)
;(global-set-key (kbd "<f11>") 'siirra-rivi-ylos)		
(global-set-key (kbd "<S-C-up>") 'siirra-rivi-ylos)		
;(global-set-key (kbd "<f9>") 'poimi-rivi)
(global-set-key (kbd "C-o + <left>") 'puskuri-lisaa-mjono-rivien-alkuun)
(global-set-key (kbd "C-o =") 'edit-el-avaa)
(global-set-key (kbd "C-o + <right>") 'puskuri-lisaa-mjono-rivien-loppuun)
(global-set-key (kbd "C-o - v") 'poista-vasemmalta-merkkiin)
(global-set-key (kbd "C-o - <down>") 'poista-puskurin-loppu)
(global-set-key (kbd "C-p C-d") 'poista-kaikki-puskurista)
(global-set-key (kbd "C-o - -") 'poista-kaikki-puskurista)
(global-set-key (kbd "C-o - <up>") 'poista-puskurin-alku)
(global-set-key (kbd "C-o - <left>") 'poista-rivin-alku)
(global-set-key (kbd "C-o - 1") 'poista-oikealta-1-merkki)
(global-set-key (kbd "C-o ; 1") 'kommentoi)
(global-set-key (kbd "C-o ; 2") 'kommentoi-kopioi)
(global-set-key (kbd "C-o b +") 'luo-temp-puskuri)
(global-set-key (kbd "C-o + b") 'luo-temp-puskuri)
(global-set-key (kbd "C-o b =") 'nimea-temp-puskuri)
(global-set-key (kbd "C-o b <SPC>") 'tyhjenna-puskuri)
(global-set-key (kbd "C-o b c") 'puskuri-kopioi)
(global-set-key (kbd "C-o b r") 'puskuri-kaanna)
;(global-set-key (kbd "C-p <up> <down>") 'puskuri-kaanna-rivit)
(global-set-key (kbd "C-p C-r") 'puskuri-kaanna-rivit)
(global-set-key (kbd "C-o b s") 'puskuri-jarjesta)
(global-set-key (kbd "C-p C-s") 'puskuri-jarjesta)
(global-set-key (kbd "C-o c l") 'tuplaa-rivit)
(global-set-key (kbd "C-o c <down>") 'puskuri-loppu-leikepoydalle)
(global-set-key (kbd "C-o e +") 'rivi-etumerkiksi)
(global-set-key (kbd "C-o e -") 'etumerkit-tyhjenna)
(global-set-key (kbd "C-o f") 'goto-fibo-iter)
(global-set-key (kbd "C-o h ;") 'korosta-puolipiste-otsikot)
(global-set-key (kbd "C-o l -") 'poista-rivi)		
(global-set-key (kbd "C-o l _") 'rivi-siisti-kunnolla)		
(global-set-key (kbd "C-o l 2") 'tuplaa-rivi)		
;(global-set-key (kbd "C-l") 'tuplaa-rivi)		
(global-set-key (kbd "C-o l d") 'siirra-rivi-alas)		
(global-set-key (kbd "C-o l k") 'korvaa-omat-rivilla)
(global-set-key (kbd "C-o l l") 'kirjoita-viiva)
(global-set-key (kbd "C-o l n") 'monista-rivi)		
(global-set-key (kbd "C-o l p") 'poimi-rivi)
(global-set-key (kbd "C-o l s") 'rivi-siisti)
(global-set-key (kbd "C-o l u") 'siirra-rivi-ylos)		
(global-set-key (kbd "C-o l '") 'rivi-leikepoydalle-hipsuissa)
(global-set-key (kbd "C-o p 2") 'tuplaa-kappale)
(global-set-key (kbd "C-o r 1") 'korvaa-rivi-regexp-leikepoydalla)
(global-set-key (kbd "C-o s s") 'putsaa-sql-tulos)
(global-set-key (kbd "C-o t -") 'toimeksianto-poisto-leikepoydalle)
(global-set-key (kbd "C-o t =") 'toimeksianto-aseta)
(global-set-key (kbd "C-o t c") 'toimeksianto-lisays-leikepoydalle)
(global-set-key (kbd "C-o t +") 'kirjoita-aikaleima)
(global-set-key (kbd "C-o t o") 'puskuri-tasaa-oikealta)
(global-set-key (kbd "C-o t r") 'puskuri-tasaa-rivit)
(global-set-key (kbd "C-p C-t") 'puskuri-tasaa-rivit)
(global-set-key (kbd "C-o v") 'korosta-rivi)
(global-set-key (kbd "C-o '") 'rivit-hipsuta)
(global-set-key (kbd "C-o C-v") 'korosta-rivi-pois)
(global-set-key (kbd "C-o <return>") 'toggle-truncate)
(global-set-key (kbd "C-o <return>") 'toggle-truncate-lines)


(global-set-key (kbd "C--") 'puskuri-siirra-toiseen-ikkunaan)

(global-set-key (kbd "M-,") 'kirjoita-aikaleima-pvm)
;(global-set-key (kbd "M-8") 'kirjoita-tehtavamerkki)
(global-set-key (kbd "RET") 'lisaa-rivi)
(global-set-key (kbd "<C-M-return>") 'lisaa-rivi-leikepoyta)
;(global-set-key (kbd "M-c") 'kopioi-rivi-toiseen-ikkunaan)
(global-set-key (kbd "<M-right>") 'kopioi-rivi-toiseen-ikkunaan-vakio-tagit-korvaten)
(global-set-key (kbd "M-v") 'kopioi-rivi-toisesta-ikkunasta)
(global-set-key (kbd "<M-left>") 'kopioi-rivi-toisesta-ikkunasta)
(global-set-key (kbd "<M-return>") 'lisaa-rivi-toiseen-ikkunaan)
(global-set-key (kbd "M-y") 'lisaa-leike-toiseen-ikkunaan)
(global-set-key (kbd "<M-down>") 'siirry-rivi-alas-toisessa-ikkunassa)
(global-set-key (kbd "<M-up>") 'siirry-rivi-ylos-toisessa-ikkunassa)
(global-set-key (kbd "M-.") 'kirjoita-ellipsis-toiseen-ikkunaan)

;(global-set-key (kbd "<S-up>") 'siirry-ylos-korostaen)
;(global-set-key (kbd "<S-down>") 'siirry-alas-korostaen)
;(global-set-key (kbd "<S-right>") 'korosta-rivi)
;(global-set-key (kbd "<S-left>") 'korosta-rivi-pois)

(global-set-key (kbd "<C-return>") 'lisaa-rivi-aikaleimalla-tunti)
(global-set-key (kbd "<S-return>") 'lisaa-rivi-aikaleimalla-paiva)
(global-set-key (kbd "<S-C-return>") 'lisaa-rivi-aikaleimalla)


(global-set-key (kbd "<f9>") 'avaa-temp)
(global-set-key (kbd "S-C-k") 'poista-loput-puskurista)
(global-set-key (kbd "C-;") 'kirjoita-vsvukkpp)



(defun puskuri-lue-relaatiosta ()
  (setq sisalto (buffer-string))
  (setq temp-puskuri (luo-temp-puskuri-taustalle))
  (insert sisalto)
  (goto-char (point-min))
  (replace-regexp "\\(.*;\\)" "<erotin>\\1")
  (goto-char (point-min))
  (replace-regexp "
" "<rivierotin>")
  (setq alkioparit (split-string (buffer-string) "<erotin>"))
  (kill-buffer temp-puskuri)
  (setq vasemmat (mapcar 'vasen-puoli alkioparit))
  (setq relaatio (mapcar 'alkiopari-listana alkioparit))
  (setq paluu (nth 1 (assoc (completing-read "Vasen : " vasemmat) relaatio)))
  (setq paluu (replace-regexp-in-string "^<rivierotin>" "" paluu))
  (setq paluu (replace-regexp-in-string "<rivierotin>$" "" paluu))
  (setq paluu (replace-regexp-in-string "<rivierotin>" "
" paluu))
  (kappale-tuo-ensimmainen paluu)
 )

(defun puskuri-koko ()
  (interactive)
  (leike-tiedosto-nimi)
  (message (concat 
	    (buffer-file-name)
	    ", merkkej‰ : "
	    (number-to-string (length (buffer-string)))
	    " sanoja : "
	    (number-to-string (length (split-string (buffer-string) "[ \t\n]+")))
	   "  rivej‰ : "
	    (number-to-string (length (split-string (buffer-string) "
"))))))


(defun nimen-juuri (nimi)
       (nth 0 (split-string nimi "_")))

(defun puskuri-iter-juuri ()
  (interactive)
  (setq nykyinen (nimen-juuri (buffer-name)))
  (next-buffer)
  (while (not (string= nykyinen (nimen-juuri (buffer-name))))
    (next-buffer)))

(setq python-exe "C:\\python26\\python.exe")
(setq python-polku "\"m:\\data\\python\\elisp\\")

(defun aja-python (ohjelma)
  (interactive)
  (shell-command (concat python-exe " " python-polku ohjelma ".py\""))
  (other-window 1)
  (switch-to-buffer "*Shell Command Output*"))

(defun puskuri-aja-python ()
  (interactive)
  (other-window 1)
  (setq data (buffer-string))
  (other-window -1)
  (setq merkit (buffer-string))
  (find-file "m:/data/python/elisp/ajettava.py")
  (kill-region (point-min) (point-max))
  (insert merkit)
  (save-buffer)
  (kill-buffer (current-buffer))
  (find-file "m:/data/python/elisp/data.input")
  (kill-region (point-min) (point-max))
  (insert data)
  (save-buffer)
  (kill-buffer (current-buffer))
  (aja-python "ajettava"))

(defun puskuri-rivita (rivi-pituus)
  (interactive "nRivin pituus:")
  (set-fill-column rivi-pituus)
  (fill-region (point-min) (point-max)))

(defun puskuri-etsi-otsikko ()
  (interactive)
  (search-forward-regexp ".*;"))

(defun puskuri-grep (regexp)
  (interactive "spuskuri grep : ")
  (setq sisalto (buffer-string))
  (switch-to-buffer (concat (buffer-name) "-" regexp))
  (insert sisalto)
  (goto-char (point-min))
  (keep-lines regexp))

(defun puskuri-grep-by-function (regexp)
  (interactive "spuskuri grep : ")
  (setq sisalto (buffer-string))
  (switch-to-buffer (concat (buffer-name) "-" regexp))
  (insert sisalto)
  (goto-char (point-min))
)
;  (setq morelines t)
;  (while morelines
;    (nth 0 (split-string (message (thing-at-point 'line t) "
;"))
;    (setq moreLines (= 0 (forward-line 1))))))



(defun puskuri-etsi-otsikko-kopioi ()
  (interactive)
  (puskuri-etsi-otsikko)
  (if (eq (point) (line-end-position))
      (forward-char))
  (rivi-loppu-leikepoydalle)
  (leikepoyta-korvaa-vakio-tagit))

(defun puskuri-etsi-otsikko-kopioi-korvaa ()
  (interactive)
  (puskuri-etsi-otsikko-kopioi)
  (leikepoyta-korvaa-vakio-tagit))

(defun puskuri-etsi-otsikko-kopioi-korvaa-palaa ()
  (interactive)
  (save-excursion 
     (puskuri-etsi-otsikko-kopioi)
     (leikepoyta-korvaa-vakio-tagit)))

(defun puskuri-etsi-otsikko-kopioi-ja-avaa ()
  (interactive)
  (puskuri-etsi-otsikko-kopioi)
  (avaa-tiedosto-leikepoydalla))

(defun kappale-tuo-ensimmainen (mjono)
	(nth 0 (split-string mjono "

")))

;(setq mjono "y")
;(kappale-tuo-ensimmainen "x")

(defun puskuri-lue-relaatiosta-leikepoydalle ()
  (interactive)
  (leike-aseta-merkkijono (puskuri-lue-relaatiosta))
  (leikepoyta-korvaa-vakio-tagit))

(defun puskuri-2-lue-relaatiosta-leikepoydalle ()
  (interactive)
  (other-window 1)
  (leike-aseta-merkkijono (puskuri-lue-relaatiosta))
  (leikepoyta-korvaa-vakio-tagit)
  (other-window -1))

(defun puskuri-el-avaa ()
  (interactive)
  (open-module "puskuri.el"))

(defun puskuri-nayta-edellinen-rivi (regexp)
  (interactive "sregexp : ")
  (save-excursion
    (if 
	(search-backward regexp nil t)
	(message (rivi-merkkijonona))
      (message "ei lˆydy"))))
    
(defun puskuri-korvaa-rivi-funktiolla (muunto-funktio)
  (interactive "akorvaa rivi funktiolla : ")
  (goto-char (point-min))
  (while (search-forward-regexp ".+" nil t)
    (setq rivi-osuma (match-string 0))
    (delete-region (match-beginning 0) (match-end 0))
    (insert (funcall muunto-funktio rivi-osuma))
    (forward-char)))

(defun puskuri-muunto-siisti-rivi (rivi)
  (replace-regexp-in-string "\\( \\)+" "\\1" rivi))

(defun puskuri-muunto-merkit (mista mihin)
  (goto-char (point-min))
  (replace-regexp mista mihin))

(defun puskuri-muunna-merkit (mista mihin)
  (interactive "sKorvaa merkkijono : \nsmerkkijonolla : ")
  (save-excursion
    (goto-char (point-min))
    (replace-string mista mihin)))



(setq puskuri-muunto-merkki-ret "
")
(setq puskuri-muunto-merkki-comma ", ")
(setq puskuri-muunto-merkki-tab "\t")
(setq puskuri-muunto-merkki-poi ".")
(setq puskuri-muunto-merkki-com ",")
(setq puskuri-muunto-merkki-spc " +")
(setq puskuri-muunto-merkki-pup ";")
(setq puskuri-muunto-merkki-backslash "\\\\")
(setq puskuri-muunto-merkki-slash "/")

(defun puskuri-muunto-ret-comma ()
  (interactive)
  (puskuri-muunto-merkit puskuri-muunto-merkki-ret puskuri-muunto-merkki-comma))
  
(defun puskuri-muunto-tab-ret ()
  (interactive)
  (puskuri-muunto-merkit puskuri-muunto-merkki-tab puskuri-muunto-merkki-ret))

(defun puskuri-muunto-ret-comma ()
  (interactive)
  (puskuri-muunto-merkit puskuri-muunto-merkki-ret puskuri-muunto-merkki-comma))
  
(defun puskuri-muunto-backslash-slash ()
  (interactive)
  (puskuri-muunto-merkit puskuri-muunto-merkki-backslash puskuri-muunto-merkki-slash))

(defun puskuri-muunto-poi-com ()
  (interactive)
  (puskuri-muunto-merkit puskuri-muunto-merkki-poi puskuri-muunto-merkki-com))

(defun puskuri-muunto-spc-pup ()
  (interactive)
  (puskuri-muunto-merkit puskuri-muunto-merkki-spc puskuri-muunto-merkki-pup))

  
;(defun puskuri-poista-tyhjat ()
;  (interactive)
;  (puskuri-muunto-merkit " " ""))
;(puskuri-muunto-siisti-rivi "a   b  d")


;(setq rivi " xx ")

(setq puskuri-muunto-if-sarake 0)
(defun puskuri-muunto-sisenna-if (rivi)
  (setq sisennys (make-string puskuri-muunto-if-sarake ? ))
  (if (string-match "^ *if" rivi)
      (progn
	(setq puskuri-muunto-if-sarake (+ puskuri-muunto-if-sarake 4))
	(setq sisennys (make-string puskuri-muunto-if-sarake ? ))))
  (if (string-match "^ *end.if" rivi)
      (progn
	(setq sisennys (make-string puskuri-muunto-if-sarake ? ))
	(setq puskuri-muunto-if-sarake (- puskuri-muunto-if-sarake 4))))
  (concat sisennys rivi))

;(puskuri-muunto-sisenna-if " if")
;(puskuri-muunto-sisenna-if " end if")

(setq puskuri-regexp-tyhja "[ \t]")
(defun puskuri-muunto-poista-takatyhjat (rivi)
  (replace-regexp-in-string (concat puskuri-regexp-tyhja "+$") "" rivi))

(defun puskuri-muunto-poista-tuplatyhjat (rivi)
  (replace-regexp-in-string (concat puskuri-regexp-tyhja "  +") " " rivi))

;(puskuri-muunto-poista-takatyhjat "aa   ")
;(puskuri-muunto-poista-tuplatyhjat "a   a bbb  vvv  ")

(defun puskuri-poista-takatyhjat ()
  (interactive)
  (puskuri-korvaa-rivi-funktiolla 'puskuri-muunto-poista-takatyhjat))

(defun puskuri-poista-tuplatyhjat ()
  (interactive)
  (puskuri-korvaa-rivi-funktiolla 'puskuri-muunto-poista-tuplatyhjat))

;seuraava ei toimi
(defun puskuri-muunto-m-levy (rivi)
  (replace-regexp-in-string "\\\\ws000095\\jokemjaa$\\" "m:\\" rivi))
; (puskuri-muunto-m-levy "\\ws000095\jokemjaa$\data\jakosaannot\TA_kustannusarvio_alustava.xlsm")

(defun puskuri-swap (x y)
  (interactive "sswap : \nsswap :")
  (goto-char (point-min))
  (replace-string x "<swap>")
  (goto-char (point-min))
  (replace-string y x)
  (goto-char (point-min))
  (replace-string "<swap>" y))

(defun puskuri-korvaa-mjono (mjono-1 mjono-2)
  (interactive "sKorvattava : \nsKoorvaava : ")
  (save-excursion
    (goto-char (point-min))
    (replace-string mjono-1 mjono-2)))

(defun puskuri-korvaa-regexp (regexp-1 regexp-2)
  (interactive "sKorvattava : \nsKoorvaava : ")
  (save-excursion
    (goto-char (point-min))
    (replace-regexp regexp-1 regexp-2)))

(defun puskuri-avaa-lista-puskureista ()
  (interactive)
  (other-window -1)
  (list-buffers)
  (other-window 1))

(defun vaihda-ikkuna-eteen ()
  (interactive)
  (other-window 1))

(defun vaihda-ikkuna-taakse ()
  (interactive)
  (other-window -1))

(defun puskuri-suuraakkoset ()
  (interactive)
  (upcase-region (point-min) (point-max)))

(defun puskuri-pienaakkoset ()
  (interactive)
  (downcase-region (point-min) (point-max)))

(defun puskuri-vaihda-ikkunat ()
  (interactive)
  (setq puskuri-1 (current-buffer))
  (other-window 1)
  (setq puskuri-2 (current-buffer))
  (switch-to-buffer puskuri-1)
  (other-window -1)
  (switch-to-buffer puskuri-2))

(defun puskuri-korvaa-tagit-kysyen-VANHA ()
  (interactive)
  (setq sisalto (merkkijono-korvaa-vakio-tagit (buffer-string)))
  (delete-region (point-min) (point-max))
  (insert sisalto)
  (goto-char (point-min))
  (while (search-forward-regexp "<.*?>" nil t)
    (setq osuma (match-string 0))
    (setq uusi (read-from-minibuffer (concat osuma " = ")))
    (delete-region (match-beginning 0) (match-end 0))
    (insert uusi)))

(defun puskuri-korvaa-tagit-kysyen ()
  (interactive)
  (setq sisalto (merkkijono-korvaa-vakio-tagit (buffer-string)))
  (switch-to-buffer "*tagit korvattu*")
  (delete-region (point-min) (point-max))
  (insert sisalto)
  (goto-char (point-min))
  (while (search-forward-regexp "<.+?>" nil t)
    (setq osuma (match-string 0))
    (setq uusi (read-from-minibuffer (concat osuma " = ")))
    (goto-char (point-min))
    (replace-string osuma uusi)
    (goto-char (point-min))))

(defun puskuri-luo-temp (&optional samaan-puskuriin)
  (interactive)
  (if (not samaan-puskuriin)
      (other-window 1))
  (find-file (format-time-string "C:/temp/temp/temp_%Y%m%d_%H%M%S.txt")))
;  (switch-to-buffer (get-buffer-create (format-time-string "temp-%T"))))

(defun puskuri-nimea-temp ()
  (interactive)
  (rename-buffer (format-time-string "temp-%T")))

(defun puskuri-lisaa-vasemmalle (merkkijono)
  (interactive "sLis‰‰ rivien alkuun merkkijono : ")
  (save-excursion
    (beginning-of-line)
    (replace-regexp "^" merkkijono)))

(defun puskuri-lisaa-vasemmalle-alusta (merkkijono)
  (interactive "sLis‰‰ puskurin alusta rivien alkuun merkkijono : ")
  (save-excursion
    (goto-char (point-min))
    (replace-regexp "^" merkkijono)))

(defun puskuri-lisaa-oikealle (merkkijono)
  (interactive "sLis‰‰ rivien loppuun merkkijono : ")
  (save-excursion 
    (replace-regexp "$" merkkijono)))


(defun puskuri-lisaa-oikealle-alusta (merkkijono)
  (interactive "sLis‰‰ puskurin alusta rivien loppuun merkkijono : ")
  (save-excursion
    (goto-char (point-min))
    (replace-regexp "$" merkkijono)))


(defun puskuri-poista-vasemmalta (regexp)
  (interactive "sPoista rivien alusta regexp : ")
  (goto-char (point-min))
  (replace-regexp (concat "^" regexp) ""))

(defun puskuri-varmista (kehote)
; (interactive)
 (string= (read-from-minibuffer kehote) ""))

(defun puskuri-avaa-excelissa ()
  (interactive)
  (if (puskuri-varmista "Varmista, avataan Exceliss‰ :")
      (progn
	(write-file 
	 (concat "C:/temp/temp_" (format-time-string "%Y%m%d_%H%M%S") ".csv"))
	(save-buffer)
	(setq polku (buffer-file-name))
	(kill-buffer (current-buffer))
	(browse-url polku))))

(defun puskuri-muotoile-sql ()
  (interactive)
  (goto-char (point-min))
  (dolist (sql-sana '("select" "from" "where" "group by") nil)
    (replace-regexp (concat "^[ \t]+" sql-sana "[ \t
]+") (concat sql-sana "
    "))))

(defun puskuri-informatica-erolista ()
  (interactive)
  (goto-char (point-min))  (replace-string "   " "<vali>")
  (goto-char (point-min))  (replace-string " " "")
  (goto-char (point-min))  (replace-string "<vali>" " ")
  (goto-char (point-min))  (replace-string "" ""))

(defun siirra-rivin-lopusta-seuraavan-alkuun (mjono)
  (replace-regexp (concat mjono "
") (concat "
" mjono)))

(defun siirra-omalle-riville (mjono)
  (replace-regexp (concat mjono " " )
(concat "
" mjono)))


(defun puskuri-muokkaa-sql ()
  (interactive)
 (goto-char 0) (replace-regexp "--.*" "")
 (goto-char 0) (replace-string "case " "\ncase\n")
 (goto-char 0) (replace-string "where" "\nwhere\n")
 (goto-char 0) (replace-string "join " "\njoin\n")
 (goto-char 0) (replace-string "from " "\nfrom\n")
 (goto-char 0) (replace-string "select " "\nselect\n")
 (goto-char 0) (replace-string "group by " "\ngroup by\n")
 (goto-char 0) (replace-string " from" "\nfrom")
 (goto-char 0) (replace-string " on " "\non\n")
 (goto-char 0) (replace-string "[" "")
 (goto-char 0) (replace-string "]" "")
 (goto-char 0) (replace-regexp "[  ]+$" "")
 (goto-char 0) (replace-regexp ",
" "
,")
 (goto-char 0) (siirra-rivin-lopusta-seuraavan-alkuun "and")
 (goto-char 0) (siirra-rivin-lopusta-seuraavan-alkuun ",")
 (goto-char 0) (siirra-rivin-lopusta-seuraavan-alkuun "or")
 (goto-char 0) (replace-regexp "[  ]+" " ")
 (goto-char 0) (replace-regexp "^[ 	]*" "    ")
 (goto-char 0) (replace-string "    with" "with")
 (goto-char 0) (replace-string "    union" "union")
 (goto-char 0) (replace-string "    where" "where")
 (goto-char 0) (replace-string "    select" "select")
 (goto-char 0) (replace-string "    from" "from")
 (goto-char 0) (replace-string "    join" "join")
 (goto-char 0) (replace-string "    on" "on")
 (goto-char 0) (replace-string "    and" "and")
 (goto-char 0) (replace-string "    or" " or")
 (goto-char 0) (replace-string "    group" " group")
 (goto-char 0) (replace-string "    ," "   ,")
 (goto-char 0) (replace-regexp "^FROM" "from")
 (goto-char 0) (replace-regexp "^AND
?" "and")
 (goto-char 0) (replace-regexp "^WHERE" "where")
 (goto-char 0) (replace-regexp "^SELECT" "select")
 (goto-char 0) (replace-regexp "^DISTINCT" "distinct")
 (goto-char 0) (keep-lines "\\w")
)


(defun puskuri-etsi-sanasta-rivin-loppuu (mjono)
  (interactive "sEtsit‰‰n sanan j‰lkeiset rivin loput. Anna sana : ")
  (goto-char (point-min))
  (replace-string mjono (concat "
" mjono))
  (goto-char (point-min))
  (keep-lines mjono)
  (goto-char (point-min))
  (replace-regexp (concat "^" mjono) ""))

(defun puskuri-poista-regexp (regexp)
  (interactive "sPoistettava regexp : ")
  (save-excursion
    (goto-char (point-min))
    (replace-regexp regexp "")))

(defun puskuri-poista-tyhjat ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (replace-regexp "[ 
\t]+" " ")))


(defun puskuri-hipsuta ()
  "Lis‰‰ hipsut ja pilkut luetteloon"
  (interactive)
  (goto-char (point-min))
  (keep-lines ".")
  (goto-char (point-min))
  (replace-regexp "\\(.*\\)" ",'\\1'")
  (goto-char (point-min))
  (delete-char 1) 
  (insert "(")
  (goto-char (point-max))
  (insert ")")
  (set-fill-column 60)
  (fill-region (point-min) (point-max)))

(defun puskuri-pilkuta ()
  "Lis‰‰ pilkut luetteloon"
  (interactive)
  (goto-char (point-min))
  (replace-regexp "^[ \t]+" "")
  (goto-char (point-min))
;  (replace-regexp "[ \t]+" " ")
  (goto-char (point-min))
  (keep-lines ".")
  (goto-char (point-min))
  (replace-regexp "\\([^ 
\t]*\\)" ",\\1")
  (goto-char (point-min))
  (replace-regexp " " " ")
  (goto-char (point-min))
  (delete-char 1) 
  (insert "(")
  (goto-char (point-max))
  (insert ")")
  (set-fill-column 999)
  (fill-region (point-min) (point-max)))


(defun puskuri-yank ()
  (interactive)
  (delete-region (point-min) (point-max))
  (yank))

(defun puskuri-aakkosta ()
  (interactive)
  (save-excursion
    (goto-char (point-min)) (replace-string "‰" "a")
    (goto-char (point-min)) (replace-string "ˆ" "o")
))

(defun puskuri-korvaa-mjono (m1 m2)
  (interactive) 
  (save-excursion 
    (goto-char (point-min))
    (replace-string m1 m2)))

(global-set-key (kbd "M-p SPC _") (lambda () (interactive) (puskuri-korvaa-mjono " " "_")))


(defun puskuri-rivit-taulukkona (&optional buffer)
  (if (not buffer) (setq buffer (current-buffer)))
  (split-string (buffer-string) "\n"))

(defun puskuri-kopioi ()
  (interactive)
  (setq str (buffer-string))
  (setq name (buffer-name))
  (other-window 1)
  (switch-to-buffer (concat name "-" (read-from-minibuffer "Kopioi puskuri, anna nimen loppu : ")))
  (insert str))
		    
(defun sql-gen-or ()
  (interactive)
  (goto-char (point-min))
  (replace-regexp "\\(.*\\)" " or isnull(a.\\1,0) <> isnull(b.\\1,0)"))

(defun jira-tag ()
  (with-temp-buffer
    (setq tag (completing-read "Jira tagi : " '("noformat" "color" "code:sql" )))
    (yank)
    (goto-char (point-min))
    (insert (concat "{" tag "}"))
    (goto-char (point-max))
    (insert (concat "{" (substring tag 0 (string-match ":" tag)) "}"))
     (buffer-string)))

(defun slack-code ()
  (interactive)
  (save-excursion
    (move-beginning-of-line 1)
    (insert "`")
    (move-end-of-line 1)
    (insert "`")))




(defun jira-tag-kopioi ()
  (interactive)
  (leikepoyta-merkkijonosta (jira-tag)))

(defun jira-tag-kirjoita ()
  (interactive)
  (insert (jira-tag)))

(defun puskuri-as ()
  (interactive)
  (goto-char (point-min))
  (replace-regexp "\\(.*\\),\\(.*\\)(\\([^.]*\\)\\([.]?\\)\\([^.]+\\))" "\\1,\\2(\\3\\4\\5) as \\2_\\3_\\5")
)

(defun avaa-tiedosto-toisessa-ikkunassa ()
 (interactive)
 (setq tiedosto-polku (rivi-merkkijonona))
 (other-window 1)
 (find-file (siisti-tiedosto-polku tiedosto-polku)))

(defun siisti-tiedosto-polku(tiedosto-polku)
  (replace-regexp-in-string "^[;# ]*" "" tiedosto-polku))

(defun puskuri-60-merkkiseksi ()
  (interactive)
  (set-fill-column 60)
  (fill-region (point-min) (point-max)))


(defun puskuri-keep-lines ()
  (interactive)
  (goto-char (point-min))
  (call-interactively 'keep-lines))

(defun puskuri-flush-lines ()
  (interactive)
  (goto-char (point-min))
  (call-interactively 'flush-lines))

(defun puskuri-pyorista ()
  (interactive)
  (goto-char (point-min))
  (replace-regexp "\\(,[0-9][0-9]\\)[0-9]+" "\\1"))

(defun puskuri-tab-pilkku ()
  (interactive)
  (goto-char (point-min))
  (replace-regexp "^" "   ,"))


(global-unset-key (kbd "C-f"))
(global-set-key (kbd "C-f C-f") 'avaa-tiedosto-toisessa-ikkunassa)
(global-set-key (kbd "C-f f") 'leike-tiedosto-nimi)


; c:/temp/loggedHours.csv

;(puskuri-rivit-taulukkona)


;nappainkomennot

;(global-unset-key (kbd "C-p <left>"))

(global-unset-key (kbd "C-p"))
(global-unset-key (kbd "C-j"))
(global-set-key (kbd "C-p TAB ;") (lambda () (interactive) (puskuri-korvaa-mjono "\t" ";")))
(global-set-key (kbd "C-p _") (lambda () (interactive) (puskuri-korvaa-regexp "[ ()./\]+" "_")))
;(global-set-key (kbd "M-y") 'puskuri-yank)
(global-set-key (kbd "C-p C-k") 'puskuri-keep-lines)
(global-set-key (kbd "C-p C-f") 'puskuri-flush-lines)
(global-set-key (kbd "C-p 6") 'puskuri-60-merkkiseksi)
(global-set-key (kbd "C-p C-<left>") 'puskuri-lisaa-vasemmalle-alusta)
(global-set-key (kbd "C-p <left>") 'puskuri-lisaa-vasemmalle)
(global-set-key (kbd "C-p <M-left>") 'puskuri-poista-vasemmalta)
(global-set-key (kbd "C-p C-<right>") 'puskuri-lisaa-oikealle-alusta)
(global-set-key (kbd "C-p <right>") 'puskuri-lisaa-oikealle)
(global-set-key (kbd "C-p f s") 'puskuri-muotoile-sql)
(global-set-key (kbd "C-p =") 'puskuri-el-avaa)
(global-set-key (kbd "C-p a s") 'puskuri-as)
(global-set-key (kbd "C-p C-j") 'jira-tag-kopioi)
(global-set-key (kbd "C-j +") 'jira-tag-kirjoita)
(global-set-key (kbd "C-p +") 'puskuri-luo-temp)
(global-set-key (kbd "C-+ p") 'puskuri-luo-temp)
(global-set-key (kbd "C-p a p") 'puskuri-aja-python)
(global-set-key (kbd "C-p f b") 'puskuri-nayta-edellinen-rivi)
(global-set-key (kbd "C-p Â") 'slack-code)
(global-set-key (kbd "C-p g") 'puskuri-grep)
(global-set-key (kbd "C-p o e") 'puskuri-avaa-excelissa)
(global-set-key (kbd "C-p m s") 'puskuri-muokkaa-sql)
(global-set-key (kbd "M-e") 'puskuri-avaa-excelissa)
(global-set-key (kbd "C-p r") 'puskuri-rivita)
(global-set-key (kbd "C-p c r") 'puskuri-lue-relaatiosta-leikepoydalle)
(global-set-key (kbd "C-p ?") 'puskuri-koko)
(global-set-key (kbd "<C-f7>") 'puskuri-lue-relaatiosta-leikepoydalle)
(global-set-key (kbd "<S-C-f7>") 'puskuri-2-lue-relaatiosta-leikepoydalle)
(global-set-key (kbd "M-c <down>") 'puskuri-etsi-otsikko-kopioi-korvaa)
(global-set-key (kbd "M-c M-<down>") 'puskuri-etsi-otsikko-kopioi-korvaa-palaa)
(global-set-key (kbd "C-p SPC -") 'puskuri-poista-takatyhjat)
(global-set-key (kbd "C-p SPC SPC") 'puskuri-poista-tuplatyhjat)
(global-set-key (kbd "C-p RET ,") 'puskuri-muunto-ret-comma)
(global-set-key (kbd "C-p - SPC") 'puskuri-poista-tyhjat)
(global-set-key (kbd "C-p . ,") 'puskuri-muunto-poi-com)
(global-set-key (kbd "C-p . ,") (lambda () (interactive) (puskuri-muunna-merkit "." ",")))
(global-set-key (kbd "C-p TAB RET") 'puskuri-muunto-tab-ret)
(global-set-key (kbd "C-p SPC ;") 'puskuri-muunto-spc-pup)
(global-set-key (kbd "C-p \\ /") 'puskuri-muunto-backslash-slash)
(global-set-key (kbd "C-p s w") 'puskuri-swap)
(global-set-key (kbd "C-p t ?") 'puskuri-korvaa-tagit-kysyen)
(global-set-key (kbd "C-<") 'puskuri-korvaa-tagit-kysyen)
(global-set-key (kbd "C-p <up>") 'puskuri-suuraakkoset)
(global-set-key (kbd "C-p <down>") 'puskuri-pienaakkoset)
(global-set-key (kbd "C-p C-c") 'compare-windows)
(global-set-key (kbd "C-p C-h") 'vaknot-hipsuta)
(global-set-key (kbd "C-p C--") 'puskuri-poista-regexp)
;(global-set-key (kbd "C-p - -") 'puskuri-poista-regexp)

(global-set-key (kbd "C-p f a") 'puskuri-aakkosta)

(global-set-key (kbd "C-p n") 'puskuri-nimea-temp)
(global-set-key (kbd "C-p C-n") 'rename-buffer)

(global-set-key (kbd "C-p '") 'puskuri-hipsuta)
(global-set-key (kbd "C-p ,") 'puskuri-pilkuta)
(global-set-key (kbd "C-p TAB ,") 'puskuri-tab-pilkku)
(global-set-key (kbd "C-<down>") 'puskuri-iter-juuri)

(global-set-key (kbd "<S-up>") 'previous-buffer)
(global-set-key (kbd "<S-down>") 'next-buffer)
(global-set-key (kbd "<S-right>") 'vaihda-ikkuna-eteen)
(global-set-key (kbd "<S-left>") 'puskuri-avaa-lista-puskureista)

(global-set-key (kbd "<M-SPC>") 'puskuri-vaihda-ikkunat)
(global-set-key (kbd "<M-f1>") 'puskuri-korvaa-regexp)


(defun bfr-kill (&optional buffer)
  (interactive)
  (setq bfr-vaihda nil)
  (if (not buffer) (progn 
		     (setq buffer (current-buffer))
		     (setq bfr-vaihda nil)))
  (if (and (buffer-modified-p buffer) (buffer-file-name buffer))
;      (if (string= ""(read-from-minibuffer "Save buffer \"\" = yes) : "))
      (if (bfr-kill-read-true)
	 (save-buffer buffer)
	(set-buffer-modified-p nil)))
  (kill-buffer buffer)
  (if bfr-vaihda (other-window 1)))

(defun bfr-kill-read-true ()
  (command-execute 'bfr-kill-read-char))

(defun bfr-kill-read-char (char)
  (interactive "cSave by Enter")
 (= char 13))

(defun clp-2-bfr (&optional buffer)
  (interactive)
  (if (not buffer) (setq buffer (current-buffer)))
  (set-buffer buffer)
  (delete-region (point-min) (point-max))
  (yank))

(global-unset-key (kbd "M-q"))
(global-set-key (kbd "M-q") 'bfr-kill)
(global-set-key (kbd "C-p <f5>") 'clp-2-bfr)

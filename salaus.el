
(defun merkki2hex (merkki) 
  (format "%X" (string-to-char merkki)))

(defun luku2hex (luku)
  (format "%X" luku))

(defun hex2merkki (heksa) 
  (char-to-string (string-to-number heksa 16)))

(defun mjono2hexjono (mjono)
 (mapconcat 
 'luku2hex mjono ""))

(defun hexjono2mjono (hexjono)
  (setq hexjono-list (split-string hexjono "" t))
  (setq paluu "")
  (while hexjono-list
    (setq hexmerkki (concat (pop hexjono-list) (pop hexjono-list)))
   (setq paluu (concat paluu (hex2merkki hexmerkki))))
  paluu)

(defun hex-xor (hex1 hex2) 
  (format "%X" (logxor 
		(string-to-number hex1 16) 
		(string-to-number hex2 16))))

(defun hexjono-xor (hexjono1 hexjono2)
  (setq hexlist1 (split-string hexjono1 "" t))
  (setq hexlist2 (split-string hexjono2 "" t))
  (setq paluu "") ; 
  (while (and hexlist1 hexlist2)
    (setq paluu (concat paluu 
			(hex-xor (pop hexlist1) (pop hexlist2)))))
  paluu)

(defun salaa (teksti avain)
  (hexjono-xor (mjono2hexjono teksti) avain))

(defun pura (hexteksti avain)
  (hexjono2mjono (hexjono-xor hexteksti avain)))

(setq crypt-file "c:/Users/rook/elisp/random_hex")
(setq len-crypt-file 100000)

(defun key2hexkey (key)
  (with-temp-buffer
    (insert-file-contents crypt-file nil key len-crypt-file)
    (goto-char (point-max))
    (insert-file-contents crypt-file nil 0 key)
    (buffer-string)))

(defun crypt (teksti avain)
  (hexjono-xor (mjono2hexjono teksti) (key2hexkey avain)))

(defun encrypt (hexteksti avain)
  (hexjono2mjono (hexjono-xor hexteksti (key2hexkey avain))))


;(key2hexkey 12)
;(merkki2hex "a")
;(luku2hex 97)
;(hex2merkki "62")
;(mjono2hexjono "teema")
;(hexjono2mjono "7465656D61")
;(hex-xor "7" "D")
;(hexjono-xor "74" "D2")
;(hexjono-xor "D2" "A6")
;(salaa "teema" "1234567890") ; 66513315F1
;(pura "66513315F1" "1234567890EEE") ; teema
;(crypt "teema" 123456) 
;(encrypt "175EBE9001" 123456)



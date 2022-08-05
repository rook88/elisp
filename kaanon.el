
(setq kaanon-taulukkona nil)
(setq sana-merkkijono-regexp "[a-zäö0-9-_]")
(setq sana-merkit "a-zäö0-9-_")
(setq sana-ei-merkki-regexp 
      (concat "[^" sana-merkit "]+"))

;(defvar kaanon-osumat (make-hash-table :test 'equal))
(setq kaanon-osumat-hash (make-hash-table :test 'equal))

(defun kaanon-osuma-lisaa (osuma)
  (if (gethash osuma kaanon-osumat-hash)
      (puthash osuma (+ 1 (gethash osuma kaanon-osumat-hash)) kaanon-osumat-hash)
      (puthash osuma 1 kaanon-osumat-hash)))

(defun kaanon-osumat-tuo ()
  (setq allkeys '())
  (maphash 'pullkeys kaanon-osumat-hash)
  allkeys)

(defun kaanon-osumat-temp-puskuriin ()
  (taulukko-temp-puskuriin (kaanon-osumat-tuo)))

;(kaanon-osumat-tuo)

(defun kaanon-taulukkona-init ()
  (find-file (concat elisp-polku "kaanon.txt"))
  (kaanon-aseta-puskurin-sanat)
  (kill-buffer (current-buffer)))

(defun onko-kaanonissa (mjono)
  (setq mjono-tark (replace-regexp-in-string "-" "_" mjono))
  (if kaanon-taulukkona
      (member mjono-tark kaanon-taulukkona)
    (member mjono-tark (kaanon-taulukkona-init))))

; (onko-kaanonissa "LLK-TATY")

(defun hae-sanat ()
  (interactive)
  (goto-char (point-min))
  (replace-regexp sana-ei-merkki-regexp "
"))

(defun etsi-seuraava-sana ()
  (if (search-forward-regexp 
   (concat sana-merkkijono-regexp "+") nil t)
      (match-string 0)))

;(etsi-seuraava-sana)

(defun etsi-seuraava-kaanon-sana ()
  (setq loytyi nil)
  (while (and (not loytyi) (etsi-seuraava-sana))
    (setq loytyi 
	  (onko-kaanonissa (match-string 0)))))

(defun etsi-seuraava-regexp-sana (regexp)
  (setq loytyi nil)
  (while (and (not loytyi) (setq osuma (etsi-seuraava-sana)))
    (setq loytyi (string-match regexp (match-string 0))))
  osuma)

;(etsi-seuraava-regexp-sana "a")

(setq kaanon-regexp nil)

(defun kaanon-regexp-init (&optional regexp)
  (if (not regexp)
      (setq kaanon-regexp (read-from-minibuffer "kaanon-regexp"))
    (setq kaanon-regexp regexp)))

(defun kaanon-regexp-iter ()
  (if kaanon-regexp
      kaanon-regexp
    (kaanon-regexp-init)))

(defun etsi-seuraava-regexp-ei-kaanon-sana (&optional regexp)
  (interactive)
  (if (not regexp)
    (setq regexp-iter (kaanon-regexp-iter))
    (setq regexp-iter regexp))
  (setq loytyi nil)
  (while (and (not loytyi) (setq kaanon-osuma (etsi-seuraava-regexp-sana regexp-iter)))
    (setq loytyi 
	  (and
	   (string-match regexp-iter kaanon-osuma)
	   (not (onko-kaanonissa kaanon-osuma)))))
  kaanon-osuma)

;(etsi-seuraava-regexp-ei-kaanon-sana "b")

(defun etsi-kaikki-regexp-ei-kaanon-sana ()
  (interactive)
  (goto-char (point-min))
  (save-excursion
    (while (etsi-seuraava-regexp-ei-kaanon-sana)
      (kaanon-osuma-lisaa kaanon-osuma)))
  (kaanon-osumat-temp-puskuriin))

(defun etsi-seuraava-regexp-ei-kaanon-sana-init (regexp)
  (interactive "skaanon-regexp : ")
  (kaanon-regexp-init regexp)
  (etsi-seuraava-regexp-ei-kaanon-sana))

(defun etsi-seuraava-ei-kaanon-sana ()
  (interactive)
  (etsi-seuraava-regexp-ei-kaanon-sana "."))

(defun kaanon-aseta-puskurin-sanat ()
  (interactive)
  (setq kaanon-taulukkona (split-string (buffer-string))))

(defun kaanon-el-avaa ()
  (interactive)
  (open-module "kaanon.el"))

(defun kaanon-osuma-leikepoydalle ()
  (interactive)
  (leike-aseta-merkkijono kaanon-osuma))


(global-set-key (kbd "<f4>") 'etsi-seuraava-ei-kaanon-sana)
(global-set-key (kbd "<S-f4>") 'etsi-seuraava-regexp-ei-kaanon-sana)
(global-set-key (kbd "<S-C-f4>") 'etsi-kaikki-regexp-ei-kaanon-sana)
(global-set-key (kbd "<M-f4>") 'etsi-seuraava-regexp-ei-kaanon-sana-init)
(global-set-key (kbd "<S-C-M-f4>") 'kaanon-el-avaa)

(global-set-key (kbd "C-c <f4>") 'kaanon-osuma-leikepoydalle)

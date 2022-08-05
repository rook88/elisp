
; str-mnemonic path voisi sisältää useamman polun
; str-mnemonic voisi ottaa välilyöntejä muistikkaan edessä ja lisätä saman verran 
;      välilyöntejä tekstin eteen

(defun str-el-avaa ()
  (interactive)
  (open-module "str.el"))

(defun str-help ()
  (interactive)
  (apropos-command "str-"))

(setq str-mnemonic-path "m:/data/mnemonics/")

;(setq mnemonic "testi")

(defun str-mnemonic (mnemonic) 
  (with-temp-buffer
    (condition-case nil
	(insert-file-contents (concat str-mnemonic-path mnemonic))
      (error nil))
    (if (string= (buffer-string) "")
     nil
     (buffer-string))))

(defun str-mnemonic-open () 
;  (interactive "sOpen mnemonic string : ")
  (interactive)
  (setq mnemonic (completing-read "Open mnemonic string : " (directory-files str-mnemonic-path)))
  (find-file (concat str-mnemonic-path mnemonic)))

;(str-mnemonic "sel")
;(str-mnemonic "testi")

;(setq malli "(No column name)	(No column name)	(No column name)	(No column name)	(No column name)	(No column name)	(No column name)	(No column name)	(No column name)	(No column name)	(No column name)	LATAUSPVM	(No column name)	(No column name)	(No column name)	(No column name)	(No column name)	VOIMAANTULON_REKISTEROINTI_PVM	(No column name)
;SE/EDUSTAJAMYYNTI	S66	612	TONI ARONEN	99615	0	0.00	0	0.00	1	0	2014-02-06 00:00:00.000	IF SE	EDUSTAJAMYYNTI	NULL	NULL	2014-01-02 00:00:00.000	2014-01-14 00:00:00.000	NULL

;")

(defun str-cte (malli)
  (with-temp-buffer
    (insert (nth 0 (split-string malli "\n")))
    (str-buffer-cte)))

(defun str-buffer-cte ()
 (interactive)
    (goto-char (point-min))
    (replace-regexp "(No column name)" (quote (replace-eval-replacement concat "foo_" (number-to-string replace-count))) nil (if (and transient-mark-mode mark-active) (region-beginning)) (if (and transient-mark-mode mark-active) (region-end)))
    (goto-char (point-min))
    (replace-regexp "\t" "
   ,")
    (goto-char (point-min))
    (insert "with cte (
    ")
    (goto-char (point-max))
    (insert "
) as (
) select * from cte ")
    (buffer-string))

(defun str-buffer-jira-table ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (replace-regexp "\\(^\\|\t\\|$\\)" "|")))

;(insert (format "%s" (nth 0 command-history)))
;(str-cte malli)

(defun str-poista-lainausmerkit (str)
  (interactive)
  (with-temp-buffer
    (insert str)
    (goto-char 0)
    (replace-regexp " *\"" "")
    (buffer-string)))

;(str-poista-lainausmerkit "abd\"efg   \"hjkk")

(defun str-kulma-2-haka (str)
  (interactive)
  (with-temp-buffer
    (insert str)
    (goto-char 0)
    (replace-string "<" "[")
    (goto-char 0)
    (replace-string ">" "]")
    (buffer-string)))

;(str-sum-eteen "=[Nllp Laskkok Eur]")
(defun str-sum-eteen (str)
  (interactive)
  (concat "=Sum(" str ")"))

;(str-trim "IF167-9  ")
;(str-trim "       IF167-9  ")
;(str-trim "       IF16    7-9  ")
(defun str-trim (str)
  (interactive)
  (replace-regexp-in-string (rx (or (: bos (* (any " \t\n")))
                                        (: (* (any " \t\n")) eos)))
                                ""
                                str))

(setq str-submatch "IF\\(.*\\)")
(setq str "IF123")

;(str-replace "IF167-9  ")
(defun str-replace (str)
  (string-match str-submatch str)
  (str-trim (match-string 1 str)))

;(str-kulma-2-haka "=Count(<Vakuutusnumero>)")

(global-unset-key (kbd "M-s"))
(global-set-key (kbd "M-s =") 'str-el-avaa)
(global-set-key (kbd "M-s ?") 'str-help)
(global-set-key (kbd "M-s m =") 'str-mnemonic-open)


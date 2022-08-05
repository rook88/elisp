(defun nayta-pituus ()
  (interactive)
  (message (number-to-string (- (point) (mark)))))

;Tämä ei toimi
;(global-set-key (kbd "<f11>") 'nayta-pituus)

(defun pilko-rivit (pituus)
  (interactive "nRivin pituus : ")
  (set-fill-column pituus)
  (fill-region (mark) (point)))

;(global-set-key (kbd "<S-f11>") 'pilko-rivit)
; 

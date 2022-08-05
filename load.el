
; todo
;

(setq omat-path (list 
		 (concat "c:/Users/" (user-login-name) "/Google Drive/jokemjaaPublic/elisp/")
		 (concat "c:/Users/" (user-login-name) "/Google Drive/elisp/")
		 "~/Google Drive/Oma Drive/elisp/" ))

;(setq omat-path '("c:/Users/rook/Google Drive/elisp/" "c:/Users/jokemjaa/Google Drive/elisp/" "m:/data/elisp/" "c:/Users/Jah/Google Drive/elisp/" "c:/Users/todddirm/Google Drive/elisp/"))

(setq omat-moduulit '("keys.el" "dynclip.el" "str.el" "alarm.el" "kaanon.el" "puskuri.el" "ftp.el" "clipboard.el" "vertailu.el" "haut.el" "lista.el" "relaatio.el" "pika-leike.el" "muotoilut.el" "edit.el" "oma.el" "tyot.el" "wiki.el" "sekalaiset.el" "nil_module.el"))

;(setq moduuli "x")
(dolist (moduuli omat-moduulit nil)
  (message (concat "Ladataan moduuli : " (setq ladattava-moduuli (locate-file moduuli omat-path))))
  (if ladattava-moduuli 
      (load-file ladattava-moduuli)
    (message "Moduulia ei ladattu")))

(defun open-module (module)
  (interactive "sAvaa moduuli : ")
  (find-file (locate-file module omat-path)))

;(open-module "keys.el")
;(open-module "dynclip.el")

(defun module-attributes (module)
  (let* ((tiedosto (locate-file module omat-path)))
	 (if tiedosto
	     (module-file-attributes tiedosto)
	   (concat "Not loaded : " module))))


(defun module-file-attributes (file)
  (let* ((attrs (file-attributes file))
	 (mtime (nth 5 attrs))
	 (mtime-txt (format-time-string " %Y-%m-%d %T" mtime)))
  (concat tiedosto mtime-txt)))

;(module-attributes "keys.el")
;(module-attributes "nil")

(defun all-module-attributes ()
  (setq paluu "")
  (dolist (moduuli omat-moduulit paluu)
    (setq paluu (concat paluu (module-attributes moduuli) "\n"))))

;(all-module-attributes)

(defun show-all-module-attributes ()
  (interactive)
  (switch-to-buffer "*Modules*")
  (insert (all-module-attributes)))

(global-set-key (kbd "H-o ?") 'show-all-module-attributes)

(defun open-all-modules()
  (interactive)
  (dolist (moduuli omat-moduulit nil)
    (open-module moduuli)))

(defun open-blog ()
  (interactive)
  (open-module "blog")
  (goto-char 0)
  (end-of-line)
  (search-forward-regexp "^201")
  (search-forward-regexp "^201")
  (search-forward-regexp "^201")
  (beginning-of-line)
  (narrow-to-region 1 (point))
  (goto-char 0))
 
(global-set-key (kbd "M-b") 'open-blog)

(open-blog)
(switch-to-buffer "blog")
(show-all-module-attributes)
(other-window 1)

; dynclip module

(global-unset-key (kbd "M-c"))
(global-set-key (kbd "M-c +")   'dynclip-iter-modify-start)
(global-set-key (kbd "M-c -")   'dynclip-iter-stop)
(global-set-key (kbd "M-c s")   'dynclip-sum-start)
(global-set-key (kbd "M-c a")   'dynclip-archive-start)
(global-set-key (kbd "M-c =")   'dynclip-module-open)
(global-set-key (kbd "M-c M-a") 'dynclip-archive-show)
(global-set-key (kbd "M-c M-s") 'dynclip-sum-show)
(global-set-key (kbd "M-c m")   'dynclip-iter-modify-start)
(global-set-key (kbd "M-c u")   'dynclip-iter-use-start)

(defun dynclip-selection-set (text)
  (if text 
      (w32-set-clipboard-data (setq dynclip-last-selected-text text))))

(setq dynclip-last-selected-text nil)
(defun dynclip-selection-get ()
 "Return the value of the current selection.
Consult the selection.  Treat empty strings as if they were unset."
     (let (text)
       ;; Don't die if x-get-selection signals an error.
       (condition-case c
           (setq text (w32-get-clipboard-data))
         (error (message "w32-get-clipboard-data:%s" c)))
       (if (string= text "") (setq text nil))
       (cond
        ((not text) nil)
        ((eq text dynclip-last-selected-text) nil)
        ((string= text dynclip-last-selected-text)
         ;; Record the newer string, so subsequent calls can use the 'eq' test.
         (setq dynclip-last-selected-text text)
         nil)
        (t
1         (setq dynclip-last-selected-text text)))))

;(defun dynclip-iter-call (function)
;  (interactive)
;  (if (equal nil (setq dynclip-clipboard (dynclip-selection-get)))
;      nil
;    (funcall function dynclip-clipboard)))

;(defun dynclip-iter-start (function)
;  (interactive "aStart Dynclip iterating with function : ")
;  (dynclip-iter-stop)
;  (run-at-time 1 1 'dynclip-iter-call function)
;  (message (concat "Function " (format "%s" function) " started")))
;(dynclip-selection-get)

(defun dynclip-iter-call (function set-clipboard)
  (interactive)
  (if (equal nil (setq dynclip-clipboard (dynclip-selection-get)))
      nil
    (if set-clipboard
	(dynclip-selection-set (funcall function dynclip-clipboard))
	(funcall function dynclip-clipboard))))

(defun dynclip-iter-modify-start (function)
  (interactive "aStart clipboard modifying with function : ")
  (dynclip-iter-stop)
  (run-at-time 1 1 'dynclip-iter-call function t)
  (message (concat "Function " (format "%s" function) " started")))

(defun dynclip-iter-use-start (function)
  (interactive "aStart using clipboard with function : ")
  (dynclip-iter-stop)
  (run-at-time 1 1 'dynclip-iter-call function nil)
  (message (concat "Function " (format "%s" function) " started")))

(defun dynclip-sum-start ()
  (interactive)
  (setq dynclip-sum nil)
  (dynclip-iter-modify-start 'dynclip-sum-append))

(defun dynclip-sum-append (dynclip-string)
  (if dynclip-sum
      (setq dynclip-sum (concat dynclip-sum "\n" dynclip-string))
    (setq dynclip-sum dynclip-string))
    dynclip-sum)

(defun dynclip-archive-start ()
  (interactive)
  (setq dynclip-archive-name (concat "archive" (format-time-string "_%Y%m%d_%H%M%S" (current-time))))
  (dynclip-iter-use-start 'dynclip-archive))

(setq dynclip-archive-name (concat "archive" (format-time-string "_%Y%m%d_%H%M%S" (current-time))))
(defun dynclip-archive (dynclip-string)
  (interactive)
  (set-buffer (get-buffer-create dynclip-archive-name))
  (goto-char (point-max)) 
  (insert (dynclip-archive-separator))
  (insert dynclip-string)
  dynclip-string)

(defun dynclip-iter-stop ()
  (interactive)
  (cancel-function-timers 'dynclip-iter-call)
  (message "Dynclip stopped"))

(defun dynclip-archive-separator ()
 (concat "\n" (format-time-string "*------   %Ana %c   ------*      " (current-time)) "\n"))

(defun dynclip-archive-show () 
  (interactive)
  (other-window 1)
  (switch-to-buffer dynclip-archive-name))
  (setq dynclip-archive-text (buffer-string))

(setq dynclip-sum nil)
(defun dynclip-sum-show ()
 (interactive)
 (other-window 1)
 (switch-to-buffer "*dynclip-sum*")
 (delete-region (point-min) (point-max))
 (if dynclip-sum
    (insert dynclip-sum)
    (insert "Nothing in Clipboard Sum"))
 (other-window -1)
)

(defun dynclip-module-open ()
  (interactive)
  (open-module "dynclip.el"))

(defun dynclip-reverse-string (dynclip-string)
   (interactive)
   (mapconcat 'identity (nreverse (split-string dynclip-string ""))""))

(defun dynclip-reverse-set-string (dynclip-string)
   (interactive)
   (dynclip-selection-set (dynclip-reverse-string dynclip-string)))

(defun dynclip-replace-space-with-line (dynclip-string)
  (setq dynclip-ret (replace-regexp-in-string " " "_" dynclip-string))
  (setq dynclip-ret (replace-regexp-in-string "ä" "a" dynclip-ret))
  (dynclip-selection-set dynclip-ret))

(defun evaluoi (dynclip-string)
  (with-temp-buffer
    (insert dynclip-string)
    (dynclip-selection-set (message (format "%s" (eval-last-sexp nil))))))

(defun wiki-content (wiki-page)
  (with-temp-buffer
    (insert-file-contents (concat wiki-sivu-polku wiki-page))
    (dynclip-selection-set (buffer-string))))

(setq dynclip-regexp-command nil)
(defun dynclip-regexp-command-set ()
  (with-temp-buffer
    (command-execute 'replace-regexp))
  (setq dynclip-regexp-command (nth 0 command-history)))

(defun dynclip-regexp-replace (string)
  (with-temp-buffer
    (insert string)
    (goto-char 0)
    (eval dynclip-regexp-command)
    (buffer-string)))

(defun dynclip-regexp-start ()
  (interactive)
  (dynclip-regexp-command-set)
  (dynclip-iter-modify-start 'dynclip-regexp-replace))

;(dynclip-regexp-start)  

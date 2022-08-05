;
; c:/emacs-22.3/lisp/alarm.el
;
; Created 13.07.2012 10:32:46
;
; Simple alarm functions 
;


(setq alarm-is-set nil)
(setq alarm-idle-is-set nil)

(defun alarm-el-avaa ()
  (interactive)
  (open-module "alarm.el"))

(defun alarm-ding ()
;  (play-sound-file "m:/data/temp/sound/ringin.wav"))
  (play-sound-file "c:/temp/ringin.wav"))
;  (play-sound-file "c:/temp/ringin.mp3"))
;(alarm-ding)

(defun alarm-start ()
  (interactive)
  (setq alarm-timer (run-at-time 0 2 'alarm-ding)))  

(setq last-string (buffer-string))
(defun alarm-start-if-idle ()
  (interactive)
  (message "checking idle status")
  (if (string= last-string (buffer-string))
       (alarm-ding))
  (setq last-string (buffer-string)))

;(alarm-start-if-idle)

(defun alarm-stop ()
 (interactive)
 (cancel-timer alarm-start-timer)
 (cancel-timer alarm-timer)
 (setq alarm-is-set nil)
 (message "Alarm stopped"))

(defun alarm-idle-stop ()
 (interactive)
 (cancel-timer alarm-start-timer)
 (setq alarm-idle-is-set nil)
 (message "Alarm idle stopped"))

(defun alarm-minutes (minutes)
  (interactive "nAlarm by * minutes : ")
  (message "Alarm set")
  (alarm-ding)
  (setq alarm-is-set (concat (number-to-string minutes) " minutes"))
  (setq alarm-start-timer (run-at-time (* 60 minutes) nil 'alarm-start)))

;(setq minutes 5)

(defun alarm-idle ()
  (interactive)
  (message "Alarm by idle set")
  (setq alarm-is-set "Alarm by idle")
  (setq alarm-start-timer (run-at-time 30 30 'alarm-start-if-idle)))

(defun alarm-at-time (time)
  (interactive "sAlarm at time : ")
  (message "Alarm set")
  (setq alarm-is-set time)
  (setq alarm-start-timer (run-at-time time nil 'alarm-start)))

(defun alarm-minutes-1 ()
  (interactive)
  (alarm-minutes 1))

(defun alarm-seconds-90 ()
  (interactive)
  (alarm-minutes 1.5))

(defun alarm-minutes-3 ()
  (interactive)
  (alarm-minutes 3))

(defun alarm-minutes-5 ()
  (interactive)
  (alarm-minutes 5))

(defun alarm-minutes-9 ()
  (interactive)
  (alarm-minutes 5))

(defun alarm-minutes-15 ()
  (interactive)
  (alarm-minutes 15))

(defun alarm-status ()
  (interactive)
  (alarm-ding)
  (if alarm-is-set
      (message (concat "Alarm set. " alarm-is-set))
    (message "Alarm is not set.")))

(global-unset-key (kbd "M-a"))
(global-set-key (kbd "M-a =") 'alarm-el-avaa)
(global-set-key (kbd "M-a M-a") 'alarm-stop)		
(global-set-key (kbd "M-a M-i") 'alarm-idle-stop)		
(global-set-key (kbd "M-a s") 'alarm-start)		
(global-set-key (kbd "M-a m") 'alarm-minutes)		
(global-set-key (kbd "M-a t") 'alarm-at-time)
(global-set-key (kbd "M-a i") 'alarm-idle)
(global-set-key (kbd "M-a 1") 'alarm-minutes-1)
(global-set-key (kbd "M-a 9") 'alarm-seconds-90)
(global-set-key (kbd "M-a 3") 'alarm-minutes-3)
(global-set-key (kbd "M-a 5") 'alarm-minutes-5)
(global-set-key (kbd "M-a 9") 'alarm-minutes-9)
(global-set-key (kbd "M-a v") 'alarm-minutes-15)
(global-set-key (kbd "M-a ?") 'alarm-status)

(defun alarm-elapsing-start (&optional alarm-message-not)
  (interactive)
  (setq alarm-elapsing-name "oletus")
  (setq alarm-elapsing-start-time (float-time))
  (if alarm-message-not
      nil
    (message "elapsing started")))

(defun alarm-elapsing-stop ()
  (interactive)
  (alarm-elapsing-show)
  (alarm-elapsing-start t))

(defun alarm-elapsing-show ()
  (interactive)
  (setq alarm-elapsed-delta (- (float-time) alarm-elapsing-start-time))
  (message (format "%8.2f" alarm-elapsed-delta)))

(global-unset-key (kbd "M-t"))
(global-set-key (kbd "M-t =") 'alarm-al-avaa)		
(global-set-key (kbd "M-t +") 'alarm-elapsing-start)
(global-set-key (kbd "M-t ?") 'alarm-elapsing-show)
(global-set-key (kbd "M-t M-t") 'alarm-elapsing-stop)


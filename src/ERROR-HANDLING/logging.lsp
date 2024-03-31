(vl-load-com)
(defun TODAY(fs / date)

  (setq d (rtos (getvar "CDATE") 2 6) ;rtos = Real (number) To String
          yr (substr d 3 2)
          mo (substr d 5 2)
         day (substr d 7 2))
  (if (= fs 1)
    (setq date (strcat day "_" mo "_" yr))
    (setq date (strcat day "/" mo "/" yr))
  )
  date
)

(defun TIME (fs / time)
 
  (setq d (rtos (getvar "CDATE") 2 6)
      hr (substr d 10 2)
      m (substr d 12 2)
      s (substr d 14 2))
  
  (if (< (strlen s) 2) 
    (setq s (strcat "0" s)))
  
  (if (= fs 1)
    (setq time (strcat hr "." m "." s))
    (setq time (strcat hr ":" m ":" s))
  )
   
  time 
)


(defun createLogFile (path /)
    (setq log_file (open (strcat path "log.txt") "w"))
    (close log_file)
)

(defun logDelimiter (path /)
  
    (setq log_file (open (strcat path "log.txt") "a"))
    (write-line "********************************************************************************" log_file)
    (close log_file)
)

(defun logEmptyLine (path /)
  
    (setq log_file (open (strcat path "log.txt") "a"))
    (write-line "" log_file)
    (close log_file)
)


(defun logNewChange (path dwg_name value /)
 
    (setq log_file (open (strcat path "log.txt") "a"))
    (write-line (strcat (TODAY 0) " " (TIME 0) " |> " dwg_name " " value) log_file)
    (close log_file)
)


(defun logOptions (path options_values /) ; optionsValues len 4

    (setq log_file (open (strcat path "log.txt") "a"))
    (write-line "----OPTIONS---------------------------------------------------------------------" log_file)
    (write-line (strcat  "Ignorer casse: "             (nth 0 options_values) "\t" "Remplacer texte entier: " (nth 1 options_values) "\n"
                         "Avec mise au point calque: " (nth 2 options_values) "\t" "Terme exact: "            (nth 3 options_values)) log_file)
    (write-line "--------------------------------------------------------------------------------" log_file)
    (close log_file)
)

(defun logUserValues (path old_value new_value)

    (setq log_file (open (strcat path "log.txt") "a"))
    (write-line "----VALEURS---------------------------------------------------------------------" log_file)
    (write-line (strcat "Valeur à remplacer : " "\"" old_value "\"" "\t" "Nouvelle valeur : " "\"" new_value "\"") log_file)
    (write-line "--------------------------------------------------------------------------------" log_file)
    (close log_file)  
)

(defun logRename (path /)

  (vl-file-rename (strcat path "log.txt")
                  (strcat path "Edition-TEXTE-log-" (TODAY 1) "-" (TIME 1) ".txt"))
)
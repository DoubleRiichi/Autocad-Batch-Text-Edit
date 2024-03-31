;; Gère les cas où l'utilisateur indique d'ignorer la casse, vu que la nouvelle valeur ne correspondra pas forcément à l'ancienne
;; on fait croire au worker.lsp qu'elles correspondent quand même, les valeurs ont déjà été comparé en minuscule donc on sait qu'elles correspondent
;; au moment où cette fonction est invoquée

(defun matchCase (str1 str2 / new_str)

  (setq str1L (vl-string->list str1))
  (setq str2L (vl-string->list str2))
  (setq counter 0)
  (setq new_str "")
  
  (while (< counter (length str2L))
    
    (setq char2 (chr (nth counter str2L)))

    (if (< counter (length str1L))
      (progn 
        (setq char1 (chr (nth counter str1L)))
        (if (and 
              (not (eq char1 char2))
              (eq  (strcase char1 T) (strcase char2 T)))
            (setq new_str (strcat new_str char1))
            (setq new_str (strcat new_str char2)))
      )
      
      (setq new_str (strcat new_str char2))
    )
    
    (setq counter (1+ counter))x²
  )
  
  new_str
)


(defun splitLine (str / new)
  (setq endcar (vl-string-search "$=$" str))
  (setq firstval (substr str 1 endcar))
  (setq lastval  (substr str (+ endcar 4)))
  (setq new (list firstval lastval))
  
  new
)

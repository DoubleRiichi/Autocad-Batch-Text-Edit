; TODO: WORKING-DIR est un peu inutile, (getvar "DWGPREFIX") accompli la même chose.
(setq APP-PATH          "")
(load (strcat APP-PATH  "/src/ERROR-HANDLING/logging.lsp"))
(load (strcat APP-PATH  "/src/ERROR-HANDLING/termination.lsp"))
(load (strcat APP-PATH  "/src/TEXT/textUtils.lsp"))
(load (strcat APP-PATH  "/src/BLOCK/blockUtils.lsp"))


(setq   DOCUMENTS-DIR    (vl-string-translate "\\" "/" (strcat (getenv "UserProfile") "/Documents/"))
        DWG-DIR          (vl-string-translate "\\" "/" (getvar "DWGPREFIX"))
        DWG-NAME         (getvar "DWGNAME")
        DATA-FILE-PATH   (strcat DOCUMENTS-DIR "edition-texte-groupeeDATA.txt")
        LAST-FILE-PATH   (strcat DOCUMENTS-DIR "last_file.txt")
        VALUES-FILE-PATH (strcat DOCUMENTS-DIR  "edition-texte-groupeeVAL.txt")
        UTILS-FILE-LIST  (list DATA-FILE-PATH LAST-FILE-PATH))


;on ouvre le fichier txt préalablement crée pour en récupérer :
(setq data_file    (open DATA-FILE-PATH "r"))
(setq WORKING-DIR  (read-line data_file)  ; 1. Chemin des résultats
      CASE         (read-line data_file)  ; 4. Option casse
      WHOLE        (read-line data_file)  ; 5. Remplace texte entier si match
      LAYER        (read-line data_file)  ; 6. Option layer
      match        (read-line data_file)) ; 7. Option terme exact
(close data_file)
(setq OUTPUT-DIR (strcat WORKING-DIR "RESULTAT/"))

(setq values (list ))
(setq values_file (open VALUES-FILE-PATH "r"))

(while (setq line (read-line values_file))
  (setq values (append values (list line))))

(close values_file)
;[/INIT]

; récupère tous les textes du dessin actif et modifie les champs contenant la valeur à changer avec la nouvelle
; Array_TEXT est une liste associative ordonnée par paires de type (CHIFFRE . VALEUR)
; (cdr (assoc CHIFFRE)) permet de récupérer la valeur associé au chiffre donné
(defun replaceValue (/ success)
    (setq array_TEXT (ssget "_X" '((0 . "*TEXT")))) 
    (setq counter 0)

  
    (if array_TEXT
        (progn 
            (repeat (sslength array_TEXT)       
              (setq entity (entget (ssname array_TEXT counter)) ) 
              (setq entity_value (cdr (assoc 1 entity))) 

              (foreach line values
                
                (setq split_line (splitLine line)) ;défini dans inputtest.lsp
                (setq OLD-VALUE  (car split_line))
                (setq NEW-VALUE  (car (cdr split_line)))
                
                (cond (= CASE "1"
                        (setq old_value_case (strcase OLD-VALUE T))
                        (setq new_entity_case (strcase entity_value T)))
                      (t (setq old_value_case OLD-VALUE)
                          (setq new_entity_case entity_value)))
              
                (if (= match "0")
                    (progn
                        (setq found_pos (vl-string-search old_value_case new_entity_case))
                        (setq found (not (not found_pos)))); vl-string-search retourne la position ou nil, (>= pos 0) ne peut pas être utilisé
                    (setq found (eq old_value_case new_entity_case)))

                
                (if (eq found T) 
                    (progn
                      (logEmptyLine OUTPUT-DIR)
                      (logNewChange OUTPUT-DIR DWG-NAME (strcat "Valeur : " OLD-VALUE " trouvée."))
                                          
                      (if (= CASE "0") 
                          (setq modified_value (vl-string-subst NEW-VALUE OLD-VALUE entity_value)) 
                          (setq modified_value (vl-string-subst NEW-VALUE (substr entity_value (1+ found_pos) (strlen OLD-VALUE)) entity_value))) ; cf: ./src/TEXT/TextUtils.lsp
                      
                      (if (= WHOLE "1")
                          (setq modified_value NEW-VALUE))
                      
                      ; à factoriser en cond
                      (setq entity (subst (cons 1 modified_value) (assoc 1 entity) entity))
                      
                      (entmod entity)
                      
                      (logNewChange OUTPUT-DIR DWG-NAME (strcat "Valeur : " entity_value " modifiée en : " modified_value "."))
                      (logEmptyLine OUTPUT-DIR)
                  
                      (setq found_once T))
                ))
              
                (setq counter (1+ counter))))
    )

    (setq blocks (ssget "_X" '((0 . "INSERT"))))
    (setq found_blk2 nil)

    (if blocks
      (foreach line values
        
        (setq split_line (splitLine line)) ;défini dans inputtest.lsp
        (setq OLD-VALUE  (car split_line))
        (setq NEW-VALUE  (car (cdr split_line)))
        
        (setq found_blk (editBlocks blocks OLD-VALUE NEW-VALUE CASE match WHOLE))
        (if found_blk
          (setq found_blk2 T))
      )
    )
  
    (if (and (not found_once) (not found_blk2))
      (logNewChange OUTPUT-DIR "/!\\" (strcat "Valeur introuvable, dessin inchangé"))) 
  
    (if (or found_once found_blk2)
      (setq success t)
      (setq success nil))
)


(defun saveDWG (/ success)
  
    (setq thisdrawing (vla-get-activedocument (vlax-get-acad-object)))
  
    (setq drawing_path (strcat OUTPUT-DIR (vl-string-subst "" WORKING-DIR DWG-DIR) DWG-NAME)) ; à factoriser, probablement redondant
    (print drawing_path)
    (vla-SaveAs thisdrawing drawing_path)
    (logNewChange OUTPUT-DIR DWG-NAME (strcat "Sauvegarde à l'emplacement : " drawing_path))
)


(defun WORKER ()
  
    (print DWG-DIR)
  
    (logDelimiter OUTPUT-DIR)
    (logNewChange OUTPUT-DIR "" (strcat "Début travail sur " DWG-DIR DWG-NAME))
  
    (if (vl-string-search WORKING-DIR DWG-DIR)
        (progn
          (setq replacedp (replaceValue))
          
          (if replacedp
            (saveDWG))

          ; Le fichier ouvert dans last_file ne contient qu'une seule ligne indiquant la valeur au dernier index
          ; de la liste de fichiers .DWG à éditer construite dans main.lsp, on détermine si le dessin actuel est le dernier
          ; et on se prépare à terminer les programme en nettoyant les fichiers temporaires.
          ; (setq WORKER NIL) permet de s'assurer que worker.lsp ne s'execute pas automatiquement lorsqu'on ouvre de nouveau dessins dans la même session.
          ; cf-> (vla-load-all "worker.lsp") 
          (if (setq last_file (open LAST-FILE-PATH "r"))
              (progn
                (setq last_file_value (read-line last_file))
                
                (if (= last_file_value (strcat DWG-DIR DWG-NAME))
                  (progn
                    (close last_file)
                    (terminate)
                    (setq WORKER nil)))
            
                (close last_file)))
          
          (logNewChange OUTPUT-DIR DWG-NAME (strcat "Fermeture de " DWG-DIR DWG-NAME))
          (command "FERMER" "n")
          (princ)))
)

(WORKER)
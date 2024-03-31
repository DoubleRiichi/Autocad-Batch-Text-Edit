;; TODO: Ajouter un bool en tant que valeur retournée pour gérer les erreurs
(vl-load-com)
(setq APP-PATH          "")
(load (strcat APP-PATH  "/src/GUI/display-help.lsp")) 
(load (strcat APP-PATH  "/src/ERROR-HANDLING/logging.lsp"))
(load (strcat APP-PATH  "/src/ERROR-HANDLING/errors.lsp"))
(load (strcat APP-PATH  "/src/FILE/fileUtils.lsp"))
(load (strcat APP-PATH  "/src/FILE/BrowseForFolderV1-3.lsp"))


(setq DOCUMENTS-DIR     (vl-string-translate "\\" "/" (strcat (getenv "UserProfile") "/Documents/")))
(setq DATA-FILE-PATH    (strcat DOCUMENTS-DIR "edition-texte-groupeeDATA.txt")
      VALUES-FILE-PATH  (strcat DOCUMENTS-DIR "edition-texte-groupeeVAL.txt")
      LAST-FILE-PATH    (strcat DOCUMENTS-DIR  "last_file.txt"))

;(aide) ;; Affiche les instructions d'utilisations après chargement


(defun createDataFile (working_dir output_dir /)

    (setq data_file (open DATA-FILE-PATH "w"))
    (write-line working_dir data_file)
    ;; OPTIONS
    (write-line case data_file)      ;; 
    (write-line whole data_file)     ;;
    (write-line layerEdit data_file) ;;
    (write-line match data_file)     ;;
    (close data_file)
)


(defun createValueFile (values_list  /)
    
    (setq values_file (open VALUES-FILE-PATH "w"))
  
    (foreach elem values_list
      (write-line (strcat (car elem) "$=$" (car (cdr elem))) values_file))
  
    (close values_file)
)


(defun createLastFile (filename /)
  
    (setq last_file (open LAST-FILE-PATH "w"))
    (write-line filename last_file)
    (close last_file)
)


(defun setupTask ( / file_list)

    (setq working_dir (getPath 
                        (browseforfolder "Selectionnez le dossier contenant les grilles a corriger." ; fileUtils.lsp
                          (vl-string-translate "\\" "/" (getenv "UserProfile")) 0)) 
          file_list   (getFilesInPath working_dir "RESULTAT")
          output_dir  (strcat working_dir "RESULTAT/"))

    (setq values (layerEdit))
    (print values)
    (createValueFile values)
  
    (if (null (vl-file-directory-p output_dir))
      (vl-mkdir output_dir))

    (makeResultFolderStruct (getFoldersInPath working_dir "RESULTAT" "RESULTAT/"))
    ; création d'un fichier temporaire permettant à worker.lsp de savoir quoi faire
    (createLogFile  output_dir)
    (createDataFile working_dir output_dir)
    (logOptions     output_dir (list case whole layerEdit match))

    file_list
) 

(defun c:EditionTexteGroupee ()
  
    (if (setq file_list (setupTask)) ;TRY
      (progn
        (createLastFile (nth (1- (length file_list)) file_list))
        
        (vl-load-all (strcat APP-PATH "/src/worker.lsp")) 
        ; à partir de maintenant, worker.lsp sera chargé dans CHAQUE dessin actif ou ouvert pendant la session
        ; cependant mettre le gros de worker.lsp dans une fonction WORKER et évaluer (setq WORKER NIL) à la fin du programme termine ce comportement
        
        (foreach filename file_list
            (print filename)
            (logNewChange output_dir "" (strcat "Overture de " filename))
            (openDWG filename))
        
        (logDelimiter output_dir)
      )
      
      (error (strcat output_dir "log.txt") "/!\\" (strcat "ERREUR: Pas de fichier DWG trouvé dans " working_dir ".") (list LAST-FILE-PATH DATA-FILE-PATH) ) ;CATCH
  )
)


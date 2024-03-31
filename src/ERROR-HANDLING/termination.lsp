(setq APP-PATH         "")
(load (strcat APP-PATH "/src/ERROR-HANDLING/cleanup.lsp"))
(load (strcat APP-PATH "/src/ERROR-HANDLING/logging.lsp"))

(defun terminate ()

    (logNewChange OUTPUT-DIR DWG-NAME (strcat "Fermeture de " DWG-DIR DWG-NAME))
    (logDelimiter OUTPUT-DIR)
  
    (logNewChange OUTPUT-DIR "" (strcat "Dernier DWG traité, supression des fichiers temporaires " DATA-FILE-PATH " et " LAST-FILE-PATH))
  
    (cleanUp (list DATA-FILE-PATH LAST-FILE-PATH))
  
    (logRename OUTPUT-DIR)
    (alert "Execution du programme terminee.")
    (command "FERMER" "n")
    
    (exit)
)
(setq APP-PATH "")

(load (strcat APP-PATH "/src/GUI/messagebox.lsp"))

(defun aide ()

  (messagebox  "La commande  CHAINE_REMPLACEMENT_DWG  permet de modifier des champs de texte dans des fichiers .DWG automatiquement et a la chaine: n
          1. Placez dans un dossier de votre choix les .DWG a modifier.
          2. Lancez la commande et parcourez jusqu'au dossier.
          3. Specifiez la valeur du texte devant etre change puis celle qui doit la remplacer.
          \nDes copies de chaque fichier modifies pourront etre trouves dans un sous-dossier nomme \"RESULTAT\". \nElles seront accompagnees d'un fichier .txt tenant compte de toutes les modifications effectuees." "\nSi aucune modification n'est faite sur les dessin, assurez-vous que la valeur entree est exacte." "Instructions")

  
)

 
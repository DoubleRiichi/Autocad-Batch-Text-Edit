(vl-load-com)
(setq APP-PATH         "")
(load (strcat APP-PATH "/src/GUI/inputtest.lsp"))

; vérifie si le chemin passé en argument se termine par un / ou nom
(defun slashp (path / bool)

  (setq path_list (vl-string->list path))
  (setq lastIndex (- (length path_list) 1))

  (if (equal (chr (nth lastIndex path_list)) "/")
      (setq bool T)
      (setq bool nil)
  )
  
  bool
)


(defun getPath (path / formated_path)

  (setq formated_path (vl-string-translate "\\" "/" path))
  (if (not (slashp path))
    (setq formated_path (strcat formated_path "/"))
  )
  
  formated_path
)


(defun getFoldersInPath (path except insert / r_folder_list)
  (setq folder_list (vl-directory-files path nil -1))
  (setq r_folder_list ())
  
  (foreach folder folder_list

    (if (and (not (= folder ".")) (not (= folder "..")) (not (= folder except))) 
      (progn
        (setq r_folder_list (append r_folder_list (list (strcat path insert folder "/"))))
    
        (if (setq next_folder_list (vl-directory-files (strcat path folder "/") nil -1))
          (setq r_folder_list (append r_folder_list (getFoldersInPath (strcat path folder "/") except insert))))))
  )
  
  r_folder_list
)


(defun makeResultFolderStruct (folder_list /) 
  (foreach folder folder_list
    (if (null (vl-file-directory-p folder))
      (vl-mkdir folder))
  )
)


(defun getFilesInPath (path except / formated_file_list)
  (setq file_list (vl-directory-files path nil 0)) 
  (setq formated_file_list ())

  (foreach file file_list
    (if (vl-string-search ".dwg" file) 
      (setq formated_file_list (append formated_file_list (list (strcat path file)))))
  
    (if (vl-file-directory-p (strcat path file)) 
      (if (and (not (= file ".")) (not (= file "..")) (not (= file except))) 
        (progn
        (setq formated_file_list (append formated_file_list (getFilesInPath (strcat path file "/") expect))))))
    )
 
  formated_file_list)




(defun openDWG ( target / rtn shl )
    (if (and (or (= 'int (type target)) (setq target (findfile target)))
             (setq shl (vla-getinterfaceobject (vlax-get-acad-object) "shell.application"))
        )
        (progn
            (setq rtn (vl-catch-all-apply 'vlax-invoke (list shl 'open target)))
            (vlax-release-object shl)
            (if (vl-catch-all-error-p rtn)
                (prompt (vl-catch-all-error-message rtn))
                t
            )
        )
    )
)
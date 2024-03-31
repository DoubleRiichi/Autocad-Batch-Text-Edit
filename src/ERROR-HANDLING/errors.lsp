(setq APP-PATH         "")
(load (strcat APP-PATH "/src/ERROR-HANDLING/logging.lsp"))
(load (strcat APP-PATH "/src/ERROR-HANDLING/cleanup.lsp"))

(defun error (log_dir_path dwg_name value files_to_delete/)
  (alert value)
  (logNewChange log_dir_path dwg_name value)
  
  (if files_to_delete
    (cleanup files_to_delete))
  
  (exit)
)


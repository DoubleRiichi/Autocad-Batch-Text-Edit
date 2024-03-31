(vl-load-com)
(defun cleanUp ( files_to_delete /)

  (setq counter 0)
  (repeat (length files_to_delete)
    
    (vl-file-delete (nth counter files_to_delete))
    (setq counter (1+ counter))
  )
)



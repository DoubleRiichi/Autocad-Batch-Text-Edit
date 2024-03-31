(setq APP-PATH "")

(defun messagebox (message1 message2 main) ;message2 message3 
 
  (setq dcl_id (load_dialog (strcat APP-PATH "/src/GUI/messagebox.dcl")))
  (if (not (new_dialog "messagebox" dcl_id))
    (exit)
  ) 
 
  (set_tile "message1" message1)
  (set_tile "message2" message2)
  ;(set_tile "message3" message3)
  (set_tile "main" main)
 

  (action_tile
    "accept"
    "(done_dialog)
     (setq result T)"
  )
  
  (start_dialog)
  (unload_dialog dcl_id)
  (princ)
)
 

  ;height    = 480
  ;width     = 720
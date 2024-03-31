  (setq APP-PATH "")

  (defun print-list (lst)
    (setq count 0)
    (repeat (length lst)
      (write-line (nth count lst))
      (setq count (1+ count))))


  (defun splitLineAZ (str / new)
    (setq endcar (vl-string-search "\t" str))
    (write-line str)
    (setq firstval (substr str 0 endcar))
    (setq lastval  (substr str (+ endcar 3)))
    
    (setq new (list firstval lastval))
    
    new
  )

  (defun clearListBox (key)
    (start_list key)
    (add_list "")
    (end_list)
  )

  (defun updateListBox (key lst)
    (setq count 0)
    (start_list key)
    (while (< count (length lst))
      (add_list (strcat (car (nth count lst)) "\t\t"  (car (cdr (nth count lst)))))
      (setq count (1+ count))
    )
    (end_list))


  (defun layerEdit (/ input_values)
    (setq input_values (list ))
    (setq dcl_id (load_dialog (strcat APP-PATH "/src/GUI/test.dcl")))
    ;(new_dialog "edit" dcl_id)
    ;(new_dialog "select" dcl_id)
    (if (not (new_dialog "layerEdit" dcl_id))
      (exit)
    )
    
    
    
    (action_tile "additem" 
                "(setq old-value (get_tile \"old-name\"))
                  (setq new-value (get_tile \"new-name\"))
                  
                  (setq input_values (append input_values (list (list old-value new-value))))
                  (updateListBox \"list\"  input_values)")
      

    (action_tile "list"
                "(setq current_sel (atoi $value))")

      
    (action_tile "delitem"
                "(setq value_to_remove (nth current_sel input_values))
                  (setq input_values (vl-remove value_to_remove input_values))
                  (updateListBox \"list\" input_values)")
    
      
    (action_tile "clear"
                "(setq input_values '())
                  (clearListBox \"list\")")
      
    (action_tile
      "cancel"
      "(done_dialog)
      (setq result nil)
      (write-line \"Commande annulée\")
      (exit)")

    (action_tile
      "accept"
      "(setq old_value (get_tile \"eb1\"))
      (setq new_value (get_tile \"eb2\"))
      (setq case (get_tile \"box_case\"))
      (setq whole (get_tile \"box_whole\"))
      (setq layerEdit (get_tile \"box_layerEdit\"))
      (setq match (get_tile \"box_match\"))
      (done_dialog)
      input_values"
    )
    
    
  (action_tile "box_case" "(setq case $value)")
  (action_tile "box_whole" "(setq whole $value)")
  (action_tile "box_layerEdit" "(setq layerEdit $value)")
  (action_tile "box_match" "(setq match $value)")
  (action_tile "box_case" "(mode_tile \"box_match\" (atoi $value))")
  (action_tile "box_match" "(mode_tile \"box_case\" (atoi $value))")

    (start_dialog)
    (unload_dialog dcl_id)
    input_values
  )
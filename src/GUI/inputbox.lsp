(setq APP-PATH "N:/IG33/AGENTS/Jimmy/edition-texte-multiple-valeurs")

(defun inputbox (title default / inputvalue)

  (setq dcl_id (load_dialog (strcat APP-PATH "/src/GUI/inputbox.dcl")))
  (if (not (new_dialog "inputbox" dcl_id))
    (exit)
  )
  
  ;(set_tile "prompt" aprompt)
  (set_tile "title" title)
  (set_tile "eb1" default)
  (mode_tile "eb1" 2)
  (set_tile "eb2" default)
  (mode_tile "eb2" 2)
  
  (action_tile "box_case" "(setq case $value)")
  (action_tile "box_whole" "(setq whole $value)")
  (action_tile "box_layerEdit" "(setq layerEdit $value)")
  (action_tile "box_match" "(setq match $value)")
  (action_tile "box_case" "(mode_tile \"box_match\" (atoi $value))")
  (action_tile "box_match" "(mode_tile \"box_case\" (atoi $value))")
  
  (action_tile
    "cancel"
    "(done_dialog)
     (setq result nil)
     (write-line \"Commande annulée\")
     (exit)"
  )

  (action_tile
    "accept"
    "(setq old_value (get_tile \"eb1\"))
     (setq new_value (get_tile \"eb2\"))
     (setq case (get_tile \"box_case\"))
     (setq whole (get_tile \"box_whole\"))
     (setq layerEdit (get_tile \"box_layerEdit\"))
     (setq match (get_tile \"box_match\"))
    (done_dialog)
    (setq result T)"
  )

  (start_dialog)
  (unload_dialog dcl_id)
  inputvalue
)
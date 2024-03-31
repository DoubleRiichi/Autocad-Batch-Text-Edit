(setq  APP-PATH          "")
(load  (strcat APP-PATH  "/src/ERROR-HANDLING/logging.lsp"))
(setq  DOCUMENTS-DIR   (vl-string-translate "\\" "/" (strcat (getenv "UserProfile") "/Documents/"))
       DWG-DIR         (vl-string-translate "\\" "/" (getvar "DWGPREFIX"))
       DWG-NAME        (getvar "DWGNAME"))



(defun searchAtt (att_value old_value new_value CASE MATCH / found) 
    (cond (= CASE "1"
            (setq old_value_case (strcase old_value T))
            (setq att_value_case (strcase att_value T)))
          (= CASE "0"
            (setq old_value_case old_value)
            (setq att_value_case att_value)))
          
    (cond (= MATCH "0" 
            (setq found_pos (vl-string-search old_value_case att_value_case))
            (setq found (not (not found_pos))))
          (= MATCH "1"
            (setq found (equal att_value_case old_value_case))))
  
    found)


(defun formatAttValue (att_value old_value new_value CASE WHOLE / modified_value)
    (if (= CASE "0")
        (setq modified_value (vl-string-subst new_value old_value att_value))
        (setq modified_value (vl-string-subst new_value (substr att_value (1+ found_pos) (strlen old_value)) att_value)))
    
    (if (= WHOLE "1")
        (setq modified_value new_value))
    
    modified_value)


(defun setBlockAttribute (blk old_value new_value CASE MATCH WHOLE / found_blk)
    ;(print "setblockatt")
    (foreach att (vlax-invoke blk 'getattributes)
        (setq att_value (vla-get-textstring att))
        (if (searchAtt att_value old_value new_value CASE MATCH)
            (progn  
              (setq blk_name (vla-get-effectivename blk))
              (logEmptyLine OUTPUT-DIR)
              (logNewChange OUTPUT-DIR DWG-NAME (strcat "Block " blk_name " -> Valeur : " old_value " trouvée."))
              
              (setq modified_value (formatAttValue att_value old_value new_value CASE WHOLE))
              (vla-put-textstring att modified_value)
              
              (logNewChange OUTPUT-DIR DWG-NAME (strcat "Block " blk_name " -> Valeur : " att_value " modifiée en : " modified_value "."))
              (logEmptyLine OUTPUT-DIR)
              (setq found_blk T))))
      (if found_blk
          found_blk
          nil))


(defun getAttributeValues (blk)
    (mapcar 
      '(lambda (att) 
         (cons (vla-get-tagstring att) (vla-get-textstring att))) 
      (vlax-invoke blk 'getattributes)))


(defun editBlocks (ss1 old_value new_value CASE MATCH WHOLE / found_blk)
  (setq block_list ())
  (setq counter 0)
  (repeat (sslength ss1)
    (setq name (ssname ss1 counter))
    (setq item (vlax-ename->vla-object name))
    (if (setBlockAttribute item old_value new_value CASE MATCH WHOLE)
      (setq found_blk T))
    ;(setq block_list (append block_list (getAttributeValues item)))
    (setq counter (1+ counter)))
  
  (if (not found_blk)
      nil
      found_blk))



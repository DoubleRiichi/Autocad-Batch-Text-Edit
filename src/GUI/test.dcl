 //---------------=={ Batch Attribute Editor }==---------------// 
                     //                                                            // 
                     //  batte.dcl dialog definition file to be used in            // 
                     //  conjunction with batte.lsp                                // 
                     //------------------------------------------------------------// 
                     //  Author: Lee Mac, Copyright © 2012 - www.lee-mac.com       // 
                     //------------------------------------------------------------// 
                      
                     //------------------------------------------------------------// 
                     //                  Sub-Assembly Definitions                  // 
                     //------------------------------------------------------------// 

                     head : list_box 
                     { 
                         is_enabled = false; 
                        // fixed_height = true; 
                         //fixed_width = true; 
                         height = 2; 
                         vertical_margin = none; 
                         horizontal_margin = none; 
                     } 
                      
                     txt : text     { vertical_margin = none; } 
                     edt : edit_box { vertical_margin = 0.1; edit_limit = 1024; } 
                      
                     but1 : button 
                     { 
                         fixed_width = true; 
                         fixed_height = true; 
                         width = 20; 
                         height = 1.8; 
                         alignment = centered; 
                     } 
                      
                     but2 : button 
                     { 
                         fixed_width = true; 
                         fixed_height = true; 
                         width = 15; 
                         height = 1.8; 
                     } 
                      
                     but3 : button 
                     { 
                         fixed_width = true; 
                         fixed_height = true; 
                         width = 18; 
                         height = 2.2; 
                     } 
                      
                     but4 : button 
                     { 
                         fixed_width = true; 
                         fixed_height = true; 
                         width = 10; 
                         height = 1.0; 
                     } 
                      
                     dwgbox : list_box 
                     { 
                         width = 40; 
                         height = 24; 
                         fixed_width = true; 
                         fixed_height = true; 
                         alignment = centered; 
                         multiple_select = true; 
                         vertical_margin = none; 
                         tab_truncate = true; 
                     } 
                      
                     tagbox : list_box 
                     { 
                         width = 80; 
                         height = 19; 
                         fixed_height = true; 
                         fixed_width = true; 
                         tabs = "22 44"; 
                         vertical_margin = none; 
                         horizontal_margin = none; 
                         multiple_select = true; 
                         tab_truncate = true; 
                     } 
                      
                     editbox : edit_box 
                     { 
                         width = 65; 
                         fixed_width = true; 
                         edit_limit = 1024; 
                     } 
                      
                     edittxt : text 
                     { 
                         alignment = right; 
                     } 
                      
                     spacer0 : spacer 
                     { 
                         width = 0.1; 
                         height = 0.1; 
                         fixed_width = true; 
                         fixed_height = true; 
                     } 
                      
                     //------------------------------------------------------------// 
                     //                    Edit Dialog Definition                  // 
                     //------------------------------------------------------------// 
                      
                     edit : dialog 
                     { 
                         initial_focus = "block"; 
                         label = "Edit Item" ; 
                         spacer; 
                         : row 
                         { 
                             : column 
                             { 
                                 spacer0; 
                                 : edittxt { label = "Block:"; } 
                                 spacer0; 
                             } 
                             : editbox { key = "block"; } 
                         } 
                         : row 
                         { 
                             : column 
                             { 
                                 spacer0; 
                                 : edittxt { label = "Tag:"; } 
                                 spacer0; 
                             } 
                             : editbox { key = "tag" ; } 
                         } 
                         : row 
                         { 
                             : column 
                             { 
                                 spacer0; 
                                 : edittxt { label = "Value:"; } 
                                 spacer0; 
                             } 
                             : editbox { key = "value"; } 
                         } 
                         spacer_1; 
                         ok_cancel; 
                     } 
                      
                     //------------------------------------------------------------// 
                     //                Block Selection Dialog Definition           // 
                     //------------------------------------------------------------// 
                      
                     select : dialog 
                     { 
                         label = "Select Items to Add"; 
                         spacer_1; 
                         : row 
                         { 
                             fixed_width = true; 
                             alignment = left; 
                             spacer; 
                             : text { label = "Select items to add to the attribute data list:"; } 
                         } 
                         spacer; 
                         : row 
                         { 
                             spacer; 
                             : head { key = "h1"; width = 22; tabs = "8"; } 
                             : head { key = "h2"; width = 22; tabs = "8"; } 
                             : head { key = "h3"; width = 36; tabs = "15";} 
                             spacer; 
                         } 
                         : row 
                         { 
                             spacer; 
                             : tagbox { key = "list"; } 
                             spacer; 
                         } 
                         : row 
                         { 
                             fixed_width = true; 
                             alignment = left; 
                             spacer; 
                             : toggle { label = "Select All"; key = "all"; } 
                         } 
                         ok_cancel; 
                     } 
                      
                     //------------------------------------------------------------// 
                     //                    Main Dialog Definition                  // 
                     //------------------------------------------------------------// 
                      
                     //------------------------------------------------------------// 
                     //                          Screen 1                          // 
                     //------------------------------------------------------------// 
                      
                     layerEdit : dialog 
                     { 
                         initial_focus = "block"; 
                         key = "dcltitle"; 
                         spacer; 
                         : text { alignment = right; label = ""; } 
                         : boxed_column 
                         { 
                             label = "Donnees textes"; 
                             : column 
                             { 
                                 : row 
                                 { 
                                     : column 
                                     { 
                                         : txt { label = "Terme A Remplacer"; } 
                                         : edt { key = "old-name"; } 
                                     } 
                                     : column 
                                     { 
                                         : txt { label = "Nouveau Terme"; } 
                                         : edt { key = "new-name"; } 
                                     } 

                                     : column {
                                      
                                      spacer;
                                        : toggle { 
                                            key = "box_match";
                                            label = "terme exact";
                                        }
                                     }
                                 } 
                                 spacer; 
                             } 
                             spacer; 
                             : row 
                             { 
                                 fixed_width = true; 
                                 alignment = centered; 
                                 : but1 { key = "additem"; label = "&Ajouter..."; mnemonic = "A"; } 
                                 //spacer; 
                                 //: but2 { key = "select";  label = "Select &Blocks..."; mnemonic = "B"; } 
                                 spacer; 
                                 : but1 { key = "delitem"; label = "&Enlever..."; mnemonic = "R"; } 
                             } 
                             spacer; 
         
                             : row 
                             { 
                                 spacer; 
                                 : head { key = "h1"; width = 40; tabs = "8"; } 
                                 : head { key = "h2"; width = 40; tabs = "8"; } 
                                 //: head { key = "h3"; width = 36; tabs = "15";} 
                                 spacer; 
                             } 
                             : row 
                             { 
                                 spacer; 
                                 : tagbox { key = "list"; } 
                                 spacer; 
                             } 
                             : row 
                             { 
                                 fixed_width = true; 
                                 alignment = centered; 
                                 //: but1 { key = "load"; label = "&Load from File"; mnemonic = "L"; } 
                                 //spacer; 
                                 : but2 { key = "clear"; label = "&Vider"; mnemonic = "C"; } 
                                 spacer; 
                                 : but1 { key = "save"; label = "&Sauvegarder donnees entrees"; mnemonic = "S"; } 
                             } 
                             spacer; 
                         } 
                         spacer; 
                        : boxed_row {
                          label = "Options";

                          : toggle { 
                            key   = "box_case";
                            label = "ignorer la casse";

                          }

                          : toggle {
                            key = "box_whole";
                            label = "remplacer texte entier";
                          }

                          : toggle { 
                            key   = "box_layerEdit";
                            label = "avec mise au point calque";

                          }

                        }

                        ok_cancel;
                     } 
  
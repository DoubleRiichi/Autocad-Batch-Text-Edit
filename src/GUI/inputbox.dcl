inputbox : dialog {
 
	key = "title";

    : row {
      : text {
        value = "Entrez le terme a remplacer :";
      }


    }

    : row {

      : edit_box {
        key = "eb1";
        allow_accept = true;
      }

      
      : toggle { 
          key = "box_match";
          label = "terme exact";
      }
      
    }

    : row {
      : text {
        value = "Entrez le nouveau terme :";
      }
    }

    : row {
      
      : edit_box {
        key = "eb2";
        allow_accept = true;
      }
    }


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
messagebox : dialog {
 
	key = "main";
  
	: column {

    : row {
        : text {
              height = 20;
              width  = 80;
            key       = "message1";
            alignment = left;
        }
         : text {
            key       = "message2";
            alignment = left;
            is_bold = true;
        }
  
	  }
   	: row {
 
 
	: button {
	label = "OK";
	key = "accept";
	width = 12;
	fixed_width = true;
  alignment = centered;
	mnemonic = "O";
	is_default = true;
	}

 
	}
 
}
  		 }
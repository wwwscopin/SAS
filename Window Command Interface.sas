%window welcome color=white
           #5 @28 'Welcome to SAS.' attr=highlight
              color=blue
           #7 @15
              "You are executing Release &sysver on &sysday, &sysdate.."
           #12 @29 'Press ENTER to continue.';
%display welcome;   


%window info         
  #5 @5 'Please enter userid:'       
  #5 @26 id 8 attr=underline                
  #7 @5 'Please enter password:'            
  #7 @28 pass 8 attr=underline display=no;           
       
%display info;          
           
%put userid entered was &id;          
%put password entered was &pass; 

quit;

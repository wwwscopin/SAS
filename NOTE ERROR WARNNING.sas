data _null_;
put "WARNING: This is a test!";
put "This is a test for note!";
run;

/*
Did you know that if you use NOTE:, WARNING: or ERROR: (all CAPS) at the beginning of messages that your programs write to the SAS Log with PUT, PUTLOG, or %PUT statements that SAS will treat those messages like its own messages?
 They will be highlighted in color (by default, blue for NOTE:, green for WARNING:, and red for ERROR:).
 Messages that begin with NOTE: can be controlled with OPTIONS NOTES/NONOTES. 
Messages that begin with ERROR: will be summarized at the end of the SAS Log. 
Messages that begin with WARNING: are typically informational, but more important than NOTE: (and, as such, should not be turned off).
 
If you use NOTE-, WARNING- or ERROR-, the result will be the same, except that key words NOTE:, WARNING: and ERROR: won't be printed. 
*/

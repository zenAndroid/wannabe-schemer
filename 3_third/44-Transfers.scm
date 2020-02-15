; I am not certain of this, but I think it is because the transfer procedure has
; no intermediary state calculation the same way the exhange procedure had one
; for calculating the difference.
; 
; More explicitly, the transfer procedure *directly* uses the from-account's
; serialized withdraw procedure and then the to account's  deposit procedure, ...
; 
; ANY CHANGE MADE TO THE ACCOUNT IS IMMEDIATELY VISIBLE TO ALL OTHER PROCESSES,
; SO SAY A MULTITUDE OF PROCESSES TRY TO DO THIS, THE BALANCE WILL GO FROM AMOUNT
; X -> (WITHDRAW X) -> NOW THE BALANCE IS EQUAL TO 0, AND ANOTHER PROCESS CAN NOW
; EXECUTE THE WITHDRAW PROCEDURE WITH SOME OTHER VALUE Y BUT LO AND BEHOLD IT
; CAN'T BECAUSE THE BALANCE IS NOW LITERALLY ZERO.
; 
; ---------------------------------------------------------------------------
; 
; Just read the solutions, I think I was correct, good, makes me feel good
; about myself tbqhwy.
; 
; Though I think the responses in sicp solutions phrased it better, the accounts
; are coupled together in the exchqnge procedure, whereas they are not in the
; transfer procedure.

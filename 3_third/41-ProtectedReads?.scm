; From my (admiteddly often wrong) understanding of this concurency business,
; concurent access to a procedure that only reads data and does not change the
; state of anything is kind of wasted resources ?
; It might even be a bad idea, since it can make other users who are
; asking for the other two procedure (withdraw or deposit) to busy wait for no
; real reson ?  In all cases withdraw/deposit acess the balance variable
; directly, but that;s not a problem since they are guaranteed not to interfere
; with each other.
; 
; Cant wait to read the solution and be  proven wrong yet again ... 
; 
; 
; 
; I ACTUALLY APPEAR NOT TO BE THAT BRAIN DEAD !!!
; 
; YAY

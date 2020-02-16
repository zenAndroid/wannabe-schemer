; 2020-02-16 11:40 :: zenAndroid ::  This might take a while.

; Exercise 3.48: Explain in detail why the deadlock-avoidance method
; described above, (i.e., the accounts are numbered, and each process
; attempts to acquire the smaller-numbered account first) avoids deadlock
; in the exchange problem. Rewrite serialized-exchange to incorporate this
; idea. (You will also need to modify make-account so that each account is
; created with a number, which can be accessed by sending an appropriate
; message.)

; Let a1 and a1 be the na;es of two bank accounts.
; Also let Peter and Paul exchange both of thm at the same time
; 
; Peter's POV :                        Paul's POV
; 
; serialized-exchange a1 a2            serialized-exchange a2 a1
; s1 <- a1's serializer                s1 <- a2's serializer
; s2 <- a2's serializer                s2 <- a1's serializer
; ((s1 (s2 exchange)) a1 a2)           ((s1 (s2 exchange)) a1 a2)
;   ^   ^                                ^   ^
;   |   |                                |   |
;   |   |                                |   |
;    \   \______________________________/    |
;     \_____________________________________/
; 
; PS: What is linked by the same arrow essentialy belongs to the same object.
; 
; 
; What the procedure is                 What the procedure is
; thinking after the first              thinking after the first
; serialization:                        serialization:
; 
; "OKAY, I have the (s2 exchange)       "OKAY, I have the (s1 exchange)
; part down, now I need to apply        part down, now I need to apply
; s1 to that, so let's do it,           s1 to that, so let's DO IT,
; but wait s1 is busy, so I'll          but wait s2 is busy, so I'll
; wait for it to finish first :)"       wait for it to finish first :)"
; 
;             ^                                       ^
;             |                                       |
; This procedure has a2's serializer     This procedure has a1's serializer
; and its waiting for a1's serializer,   and its waiting for a2's serializer,
; except it cant get it because it's     except it cant get it because it's
; being held by the other procedure      being held by the other procedure
; that is itslef waiting for this        that is itslef waiting for this
; serialzer.                             serialzer.
; 
; 
; WE ... HAVE ... A ... D E A D L O C K !!!


That was me explaining to myself why there was deadlock :)

(define (serialized-exchange acc1 acc2)
  (let ((acc1-id (acc1 'id))
        (acc2-id (acc2 'id))
        (s1 (acc1 'serializer))
        (s2 (acc2 'serializer)))
    (if (< acc1-id acc2-id)
      ((s2 (s1 exchange)) acc1 acc2)
      ((s1 (s2 exchange)) acc1 acc2))))


Let A1 be the account with ID 7 (for example)
Let A2 be the account with ID 14 (for example)

; Peter's POV :                        Paul's POV
; 
; serialized-exchange a1 a2            serialized-exchange a2 a1

; acc1-id <- a1's ID <- 7              acc1-id <- a2's ID <- 14
; acc2-id <- a2's ID <- 14             acc2-is <- a1's ID <- 7
; (< 7 14) ==> true ==>                (< 14 7) ==> false ==>
; s1 <- a1's serializer                s1 <- a2's serializer
; s2 <- a2's serializer                s2 <- a1's serializer
; ((s2 (s1 exchange)) a1 a2)           ((s1 (s2 exchange)) a1 a2)
; ...

; This solves the deadlock ...

; Because although syntactically different, both procedure need to serialize the
; raw exchange procedure using A1's serializer first. so there will be no
; deadlock, because
; 
; Whoever goes first, will also be able to get the second serializer, apply the
; serialized-exchange procedure safely, then exit out and leave the other
; concurrent access safely and do its budiness.

; Thus, no deadlock.


; Did not also include the code for the modifications necessary for
; make-account and serialzer because they are trivial,
; you just add another "switch" statement checking for the 'id symbol and
; return the ID if that.
; Though I think it would be wisee to have the make-account procedure hold the
; state of the IDs, amd not decalre the procedure in such a way as to make the
; account ID a parameter of the aprocedure because then the abstraction
; barriers would leak, a user shouldnt care about ids and stuff like that, some
; maybe make the procedure have an internal state variable holding an integer
; and every time a user creates an account you give them that variable as an ID
; and then internally increment the variable, thereby guaranteeing the fact
; that there willl be no repetition and also this way adds decent abstraction.

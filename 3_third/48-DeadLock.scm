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

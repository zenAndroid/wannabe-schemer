;; 
;; Exercise 3.32: The procedures to be run during each time segment of the agenda
;; are kept in a queue. Thus, the procedures for each segment are called in the
;; order in which they were added to the agenda (first in, first out). Explain why
;; this order must be used. In particular, trace the behavior of an and-gate whose
;; inputs change from 0, 1 to 1, 0 in the same segment and say how the behavior
;; would differ if we stored a segment’s procedures in an ordinary list, adding
;; and removing procedures only at the front (last in, first out).


;; After you follow the execution carefully, you find that
;; You have the and gate
;; A is O, and b is 1
;; 
;; A turns to 1.
;; THEN.
;; Its and-action-procedure (that will set the gate's output to ONE) is added to
;; the QUEUE.
;; THEN.
;; B turns to 0.
;; Its and-action-procedure (that will set the gate's output to ZERO) is added to
;; the QUEUE.
;; 
;; When the time come since WE ARE REPRESENTING ACTION PROCEDURES ON A QUEUE, WHEN
;; THEY WILL BE EXECUTED, THEY WILL NATRURALLY BE REMOVED FROM THE HEAD OF THE
;; QUEUE, MEANING A'S ACTION HAPPENS, *THEN* B'S ACTION HAPPENS.
;; 
;; WHICH BASICALLY MEANS THAT THE FINAL RESULT OF THE GATE'S OUTPUT WILL BE ZERO,
;; WHICH IS THE C O R R E C T RESULT.
;; 
;; MEANWHILE, IF WE REPRESENT THEM AS LISTS, THEN THE ACTION PROCEDURES EXECUTION
;; WILL BE SUCH THAT B'S ACTION (THE LAST ACTION TO BE ADDED) WILL BE EXCUTED
;; FIRST, *THEN* A'S ACTION WILL HAPPEN, LEAVING THE RESULT I N C O R R E C T.
;; 

;; ; BEFORE SEEING THE SOLUTION ONLINE ...
;; 
;; Well let's think about this.
;; (parallel-execute (lambda () (set! x ((s (lambda() (* x x))))))
;;                   (s (lambda() (set! x (+ x 1)))))
;; 
;; So two processes will launch
;; The first one is this procedure:
;; 
;; (lambda () (set! x ((s (lambda() (* x x))))))
;; 
;; The second one is this :
;; 
;; (s (lambda() (set! x (+ x 1)))))
;; 
;; 
;; I think the first one will eventually have to execute the left handside of the
;; set! procedure, iE the application of the protected PROCEDURE that squares x.
;; 
;; And the second one is PROCEDURE itself so the end result i think is not going
;; to change much ...
;; 
;; Yeah i think given that the ACCESS TO THE shared state seems to be protected in
;; both cases, i think the result is going to be the same.
;; 
;; ; AFTER SEEING THE SOLUTION ONLINE
;; 
;; 
;; I continue to be disappointed in myself ...
;; 
;; But i recognize tte mistake in my ways, 
;;   121 - P2 then P1
;;   101 - P1 then P2
;;   100 - P1 gets x^2 to be 100.  Then P2 sets x after which P1 sets x to be 100.
;; 
;; Fom sicp-solutions
;; 
;; None of the above is correct!! Actually the right solution is 121, 100, 101 AND
;; 11. adams has the right reasons for the first three. However you can also get
;; 11: Lets label the 3 processes involved: S1: calculation of x^2, S2: setting x
;; to calculated value of x^2; R1: acquisition of value of x and setting it to
;; x+1. Now here is what can happen: S1: acquires the mutex and calculates the
;; value of x^2 i.e. 100, now it releases the mutex. At this point R1 acquires the
;; mutex and calculates a value of 11 BUT before it can set the value to 11, S2
;; occurs (nothing barring it from occuring concurrently with R1) and therefore R1
;; gets to set the final value of x, i.e. 11.

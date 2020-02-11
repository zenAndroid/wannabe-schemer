#|
Did not come up eith a solution for this myself.
I wanted to, but accidentally read it, and didn't care much to struggle for it and reach pretty much the same solution.

I do however think that i will wat some [point attempt to rewrite ina way where the call for full-adder comes before ripple-carry-adder
|#
(define (ripple-carry-adder As Bs Ss C)
  (let ((carry (make-wire)))
    (if (null? As)
		(set-signal! C 0)
	    (begin
		 (ripple-carry-adder (cdr As) (cdr Bs) (cdr Ss) carry)
		 (full-adder (car As) (car Bs) carry (car Ss) C)))))



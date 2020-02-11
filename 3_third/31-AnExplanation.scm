; Exercise 3.31: The internal procedure accept-action-procedure! defined in
; make-wire specifies that when a new action procedure is added to a wire, the
; procedure is immediately run. Explain why this initialization is necessary. In
; particular, trace through the half-adder example in the paragraphs above and
; say how the system’s response would differ if we had defined
; accept-action-procedure! as
; 
; (define (accept-action-procedure! proc) 
;   (set! action-procedures 
;     (cons proc action-procedures)))
; 
; I procrastinated on this exercise a lot, ...
; 
; Because when i saw that the ecercise asked for tracing the half-adder procedure
; i was *very* discouraged from doing it as i thought it would be too long for
; the effort but then i said to myself that this kind of reasoning is quickly
; going to lead me to skip most of the exercices ... So i did it, and it turns
; out it's reletively quick and painless to understand why immediately executing
; the procedure is a good idea ...
; 
; I will attempt to explain it ...
; 
; So say you have a, b, and c as wires, ie:
; 
; (define a (make-wire))
; (define b (make-wire))
; (define c (make-wire))
; 
; and you put the wires in an and gate, ie:
; 
; (and-gate a b c) ; note that c is the output wire
; 
; tracing the ececution of and-gate leads to this
; 
; -> (add-action! a (... basically the logical and operation after the delay ...))
; -> (add-action! b (... basically the logical and operation after the delay ...))
; 
; which expands to
; -> ((a 'add-action!) (... basically the logical and operation after the delay ...)) 
; ... thereby feeding that second (argumant) procedure to a's
; accept-action-procedure! which finally results in changing a's collection of
; action procedures by adding this argumant procedure ...
; 
; that's it
; 
; same thing happens on b's side
; 
; The ("logical-and" after a delay) gets added to its list of action procedures ...
; 
; NOT AT ANY POINT DOES IN THIS EXECUTION HAVE WE ACTUALLY SET C'S SIGNAL TO
; THE LOGICAL VALUE OF A && B !
; 
; However, if we executed the function right after adding it, it solves the
; problem, and it sets the output's value after the delay.
;
; In conclusion, the initial value of a gate do not propagate if not for
; executing a procedure right after adding it
; Which means that the system stays static, nothing happens
; No signal propagates, and so the compomnents of the system do nothing.


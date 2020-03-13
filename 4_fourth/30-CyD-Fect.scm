; 2020-03-08 20:27 :: zenAndroid ::  I'll just come out right and say it, this
; portion of the text is not easily understandable to me and I don't know why,
; very confusing to me.


; I did not solve this exercise, I have seen Eli's explanation on his website,
; I have understoof it, but this area remains a bit dodgy in my mind.

; a. eval. is called on each expression of the sequence. Since for-each uses
; begin which is evaluated as a sequence, each iteration of the for-each is
; evaluated with eval. – and since display is a primitive procedure, the actual
; value of its argument is eventually computed.

; b. With the original eval-sequence:
; 
; (p1 1)
; => (1 2)
; (p2 1)
; => 1

; Let’s see what happens in p2. The crucial point here is the call to the
; internal function p. When the call is executed, as with any application of a
; compound procedure, the body of p is evaluated with the environment extended
; with its arguments tied to their delayed values. The body of p is evaluated
; in sequence. When e is evaluated, the assignment thunk is substituted instead
; of it, but since its value isn’t passed to any primitive procedure, it is not
; forced and the assignment doesn’t really happen. So later, when x is
; evaluated and returned, it has its old value. To understand it better, we’ll
; rewrite p2 as follows2:

; (define (p2 x)
;   (define (p e)
;     e
;     (print e)
;     x)
;   (p (set! x (cons x '(2)))))
; 
; Now:
; 
; (p2 1)
; => OK (1 2)

; What has happened here ? The call (print e) passes e to a primitive
; procedure, and that forces it. While it’s being forced, it assigns a new
; value to x.

; Using Cy’s proposed eval-sequence:
; 
; (p1 1)
; => (1 2)
; (p2 1)
; => (1 2)

; Because e is forced in the sequence even without being passed to a primitive
; procedure.

; c. As I explained in the answer to a., the calls to display force the
; arguments anyway because display is a primitive procedure. So calling
; actual-value on them can’t hurt.

; d. I like Cy’s approach because it behaves better when there are statements
; with side effects.



; Explanation from https://eli.thegreenplace.net/2007/12/25/sicp-section-422


; Not really proud oof myself for not figuring it out myself, but it happens
; ¯\_(ツ)_/¯.

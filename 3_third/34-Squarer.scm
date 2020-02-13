(load "33-Averager.scm")

(define (squarer a b)
  (multiplier a a b)
  'ok)

(define a (make-connector))
(define b (make-connector))
(squarer a b)
(probe "A" a)
(probe "B" b)

(set-value! a 7 'z)

; .. took me a while to understand why there was a flaw in this
; a bit ashamed, but oh well
; The squarer procedure (or box if you will) presents two argumants, so it
; leads you to think that setting one argument would easily mean you can get
; the value of the other one, meaning that when setting the value of b (the
; output of squred) you expect a to take the value of the square root of
; that,... 
; except that is not what happens , because under the hood the squarer procedure
; uses the multiplier procedure that only functions properly when it has the
; value of BOTH of its inputs, and that is not so when you set the value of b,
; because then both of the input of multiplier are unknown to it.

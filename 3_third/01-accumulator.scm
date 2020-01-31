; 2020-01-25 22:37 :: zenAndroid Here we go, advancing in our journey ...
; An accumulator ... gets one arguments that is the initial value
; then ? provides a lambda ? or dispatch like the bank example ?
; I think that by looking at zhat the execution sample looks like
; I'm guessing there is no message passing.

; I'll try and see 


(define (make-accumulator value)
  (lambda(x)
    (begin (set! value (+ value x))
           value)))


(define A (make-accumulator 0))

(define B (make-accumulator 0))

; Welcome to Racket v7.5.
; > (define (make-accumulator value)
;     (lambda(x)
;       (begin (set! value (+ value x))
;              value)))
; > (define A (make-accumulator 0))
; > (define B (make-accumulator 0))
; > (A 15)
; 15
; > (A 15)
; 30
; > (A 15)
; 45
; > (A 15)
; 60
; > (A 15)
; 75
; > (A 15)
; 90
; > (A 15)
; 105
; > (A 15)
; 120
; > (B 23)
; 23
; > (B 23)
; 46
; > (B 23)
; 69
; > (B 23)
; 92
; > (B 23)
; 115
; > (B 23)
; 138
; 

; Looks good to me !

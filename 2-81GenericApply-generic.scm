(require racket/include)

(include "2-80-synthesis.scm")

; Just to recap and understand what that line just did.

; It defined the MAIN-TABLE, for one
; It also installed several packages, 
; - scheme number
; - rational
; - rectangular
; - polar
; - complex
; 
; and the generic add, sub, mul, div, equ?, and =zero?


; Going to have to do the same thing for the coercion table that i did for the op-type table.

; Nope, never mind, I dont even need it as the put-coercion function in the text 
; also requires three arguments and since i can just use another name for the coersion table, i don not need to worry.

; Function to turn a scheme number into a rational number

(define (scheme-number->rat n) (make-rat n 1))

; Function to turn a scheme number to a complex

(define (scheme-number->complex) (make-complex-from-real-imag

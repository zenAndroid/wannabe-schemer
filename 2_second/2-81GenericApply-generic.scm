(require racket/trace)
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

(define (scheme-number->rat n) (make-rat (contents n) 1))

; Function to turn a scheme number to a complex

(define (scheme-number->complex n) (make-complex-from-real-imag (contents n) 0))

; Function to turn a rational into a complex

(define (rat->complex rat) 
  (make-complex-from-real-imag
    (let ((numer (get MAIN-TABLE 'numer 'rational))
          (denom (get MAIN-TABLE 'denom 'rational)))
      (/ (numer rat)
         (denom rat)))
    0))

; int -> rat -> complex


(define COERCION (put '() 'scheme-number 'rational scheme-number->rat))
(define COERCION (put COERCION 'scheme-number 'complex scheme-number->complex))
(define COERCION (put COERCION 'rational 'complex rat->complex))
(define testRat (make-rat 3 7))
(displayln testRat)
(displayln (rat->complex testRat))

(displayln "add sub mul div test rat and 1+5i")
(displayln (add testRat (make-complex-from-real-imag 1 5)))
(displayln (sub testRat (make-complex-from-real-imag 1 5)))
(displayln (mul testRat (make-complex-from-real-imag 1 5)))
(displayln (div testRat (make-complex-from-real-imag 1 5)))

(displayln "add sub mul div 5  and 2/5")
(displayln (add (make-scheme-number 5) (make-rat 2 5)))
(displayln (sub (make-scheme-number 5) (make-rat 2 5)))
(displayln (mul (make-scheme-number 5) (make-rat 2 5)))
(displayln (div (make-scheme-number 5) (make-rat 2 5)))

(displayln "add sub mul div 5 and 1+5i")
(displayln (add (make-scheme-number 5) (make-complex-from-real-imag 1 5)))
(displayln (sub (make-scheme-number 5) (make-complex-from-real-imag 1 5)))
(displayln (mul (make-scheme-number 5) (make-complex-from-real-imag 1 5)))
(displayln (div (make-scheme-number 5) (make-complex-from-real-imag 1 5)))

(load "56-RHamming-Challenge.scm")


(define (expand num denom radix)
  (stream-cons (quotient (* num radix) denom)
               (expand (remainder (* num radix) denom) denom radix)))

(sample (expand 1 7 10))

; > (load "56-RHamming-Challenge.scm")
; > (define (expand num denom radix)
;     (stream-cons (quotient (* num radix) denom)
;                  (expand (remainder (* num radix) denom) denom radix)))
; > (define (expand num denom radix)
;     (stream-cons (quotient (* num radix) denom)
;                  (expand (remainder (* num radix) denom) denom radix)))
; > (sample (expand 1 7 10))
; '(1 4 2 8 5 7 1 4 2 8)
; > ^D


; Welcome to Racket v7.5.
; > (load "56-RHamming-Challenge.scm")
; > (define (expand num denom radix)
;     (stream-cons (quotient (* num radix) denom)
;                  (expand (remainder (* num radix) denom) denom radix)))
; > (sample (expand 1 7 10))
; ; expand: arity mismatch;
; ;  the expected number of arguments does not match the given number
; ;   expected: 1
; ;   given: 3
; ; [,bt for context]
; > (sample (expand 1 7 10))
; ; expand: arity mismatch;
; ;  the expected number of arguments does not match the given number
; ;   expected: 1
; ;   given: 3
; ; [,bt for context]
; > (define (expand num denom radix)
;     (stream-cons (quotient (* num radix) denom)
;                  (expand (remainder (* num radix) denom) denom radix)))
; > (sample (expand 1 7 10))
; '(1 4 2 8 5 7 1 4 2 8)
; > ^D


; I have to define the expand procedure twice .... weird

#lang scheme

; First, we'll just write good ol exponentiation
; b^n = b*b^n-1
; b^0 = 1
(define (expt a b)
  (cond ((= b 0) 1)
        (else (* a (expt a (- b 1))))))

; Then, we write the fast exponentiation
; b^n = (b^(n/2))^2 if n is even
; b^n = b^(n-1)     if n is odd

(define (fast-expt a b)
  (cond ((= b 0) 1)
        ((even? b) (square (fast-expt a (/ b 2))))
        (else (* a (fast-expt a (- b 1))))))

(define (square x) (* x x))

(define (expt-lin base exponent)
  (expt-lin-h base exponent 1))

(define (expt-lin-h base exponent state)
  (cond ((= exponent 0) state)
        ((odd? exponent) (expt-lin-h base (- exponent 1) (* state base)))
        ((even? exponent) (expt-lin-h (square base) (/ exponent 2) state))))

(displayln (expt-lin 17 17))

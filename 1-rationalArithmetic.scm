#lang scheme
(define (numer x) (car x))
(define (denom x) (cdr x))
; (define (make-rat n d) (cons n d)) , this implementation lacks the reduction of the terms to their
;                                      lowest common denominator
 (define (make-rat n d) ; Didnt come up with this unfortunately :(
   (let ((g ((if (< d 0) - +) (gcd n d)))) 
     (cons (/ n g) (/ d g)))) 
(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))
(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))
(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))))
(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))))
(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))


(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))

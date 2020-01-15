#lang scheme
(define (prime n)
  (= (smolestdiv n) n))
(define (smolestdiv n)
  (findiv n 2))
(define (findiv n div)
  (cond ((> (* div div) n) n)
        ((divides? div n) div)
        (else (findiv n (+ div 1)))))
(define (divides? a b)
  (= (remainder b a) 0))

(display (prime 157))
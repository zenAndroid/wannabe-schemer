#lang scheme

(define (gcd a b)
  (if (= b 0)
    a
    (gcd b (remainder a b))))


(displayln (gcd 15 52))
(displayln (gcd 16 28))

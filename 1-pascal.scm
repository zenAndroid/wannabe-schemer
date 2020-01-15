#lang scheme
(define (pascal i j)
  (cond ((> i j) 0)
        ((or (= i 1) (= i j)) 1)
        (else (+
               (pascal i (- j 1))
               (pascal (- i 1) (- j 1))))))
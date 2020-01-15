#lang scheme
(define (fib n)
        (fib-i 1 0 n))

(define (fib-i none nzero count)
        (if (> count 0)
            (fib-i (+ none nzero) none (- count 1))
            nzero))

(displayln (fib 50))

#lang scheme
(define (square x) (* x x))
(define (exp b e)
  (cond ((= e 0) 1)
        ((even? e) (exp (square b) (/ e 2)))
        (else (* b (exp b (- e 1))))))

(define (fermat-exp x y) (remainder (exp x y) y))

(define (attempt a n)
  (= a (fermat-exp a n)))

(define (fermat-test n times)
  (define (fermat-test-iter n i)
    (cond ((= i 0) #t)
          ((attempt (+ 1 (random (- n 1))) n)
           (fermat-test-iter n (- i 1)))
          (else #f)))
  (fermat-test-iter n times))
#lang scheme

(define (square x) (* x x))

(define (expo b e)
  (cond ((= e 0) 1)
        ((even? e) (square (expo b (/ e 2))))
        ((odd? e) (* b (expo b (- e 1))))))

(define (make-pair a b)
  (* (expo 2 a) (expo 3 b)))

(define (head pair)
  (define (cont-div pair)
    (if (= 0 (remainder pair 3))
        (cont-div (/ pair 3))
        pair))
  (log (cont-div pair) 2))

(define (tail pair)
  (define (cont-div pair)
    (cond ((= (remainder pair 2) 0) (cont-div (/ pair 2)))
          (else pair)))
  (log (cont-div pair) 3))

(define foo (make-pair 3 4))

(head foo)
(tail foo)

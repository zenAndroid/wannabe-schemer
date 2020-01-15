#lang scheme
(define (square n) (* n n))
(define (product f a next b)
  (if (> a b)
      1
      (* (f a) (product f (next a) next b))))

(define (factorial n)
  (define (id n) n)
  (define (inc n) (+ 1 n))
  (product id 1 inc n))

(define (pi-over-four n)
  (define (tempFoo n)
    (/ (* 4 n (+ 1 n)) (square (+ 1 (* 2 n)))))
  (define (inc x) (+ 1 x))
  (product tempFoo 1.0 inc n))

(displayln (* 4 (pi-over-four 10000)))
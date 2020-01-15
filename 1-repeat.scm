#lang scheme
(define (compose f g) (lambda(x) (f (g x))))
(define (repeat f n)
  (if (= n 0)
      (lambda(i)i)
      (compose f (repeat f (- n 1)))))

(define (smooth f)
  (define dx 0.0001)
  (define (average x y z) (/ (+ x y z) 3))
  (lambda(x)
    (average
     (f (- x dx))
     (f x)
     (f (+ x dx)))))

(define (n-smooth f n)
  ((repeat smooth n) f))
  

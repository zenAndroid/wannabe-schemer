#lang scheme
(define (f n)
  (if (< n 3)
      n
      (+
       (f (- n 1))
       (* 2 (f (- n 2)))
       (* 3 (f (- n 3))))))

(define (g n)
  (define (help a b c i)
    (if (= i 0)
        a
        (help b c (+ c (* 2 b) (* 3 a)) (- i 1))))
  (help 0 1 2 n))
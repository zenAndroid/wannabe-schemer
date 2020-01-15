#lang scheme
(define (count-frac n d k)
  (define (iter count)
    (if (= count k)
        (/ (n k) (d k))
        (/ (n count) (+ (d count) (iter (+ count 1))))))
    (iter 1))

(count-frac
 (lambda (i) 1.0)
 (lambda (i) 1.0)
 38) ; A Pretty accurate approximation of 1/phi. (to 16 decimal places)

(define e (+ 2
             (count-frac
              (lambda (i) 1.0)
              (lambda (i)
                (if (not (= (remainder i 3) 2))
                    1
                    (+ 2 (* 2 (quotient i 3)))))
              20)))

(define (tan-cf x k)
  (define (n k) (if (= k 1) x (-(* x x))))
  (define (d k) (- (* 2 k) 1))
  (count-frac n d k))
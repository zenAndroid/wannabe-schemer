(include "94-GCD-Terms.scm")


(define first-poly
  (make-poly
    'x
    '((2 1) (1 -2) (0 1))))

(define second-poly
  (make-poly
    'x
    '((2 11) (0 7))))

(define third-poly
  (make-poly
    'x
    '((1 13) (0 5))))

(define Q1 (mul first-poly second-poly))

(define Q2 (mul first-poly third-poly))

; (custom-gcd Q1 Q2)

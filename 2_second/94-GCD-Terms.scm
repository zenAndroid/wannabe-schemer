(include "93-RatFraction.scm")

; 2020-01-22 14:52 :: zenAndroid

(define p1
  (make-poly
   'x '((4 1) (3 -1) (2 -2) (1 2))))

(define p2
  (make-poly
   'x '((3 1) (1 -1))))

(display (custom-gcd p1 p2))

(newline)



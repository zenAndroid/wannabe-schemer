#lang scheme
(define (square x) (* x x))
(define (cube x) (* x x x))
(define (average3 x y z) (/ (+ x y z) 3))
(define (cubRot-it guess x)
  (if (goodNuf? guess x)
      guess
      (cubRot-it (improve guess x) x)))

(define (improve guess x)
  (average3 (/ x (square guess)) guess guess))

(define (goodNuf? guess x)
  (<
   (abs (- (cube guess) x))
   0.0000001))

(define (cuberoot  x)
  (cubRot-it 1.0 x))
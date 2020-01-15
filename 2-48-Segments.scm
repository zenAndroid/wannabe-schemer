#lang scheme

(define (make-vect x-coor y-coor)
  (cons x-coor y-coor))

(define (xcor-vect vect)
  (car vect))

(define (ycor-vect vect)
  (cdr vect))

(define (add-vect v1 v2)
  (make-vect
    (+ (xcor-vect v1) (xcor-vect v2))
    (+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2)
  (make-vect
    (- (xcor-vect v1) (xcor-vect v2))
    (- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect s v)
  (make-vect (* s (xcor-vect v)) (* s (ycor-vect v))))


(define make-segment cons)
(define start-segment car)
(define end-segment cdr)

; I honestly did not think it would be this easy, but when i looked it up on the internet
; there it was, *shrugs* cant believe this smh

; I still don't think i understand the question correctly

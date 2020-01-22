#lang scheme

(define (accumulate op init seq)
  (if (null? seq)
      init
      (op (car seq) (accumulate op init (cdr seq)))))

(define (horner x coef-seq)
  (accumulate
    (lambda (this-coeff higher-terms) (+ (* x this-coeff) higher-terms))
    0
    coef-seq))

; All right ok i think i am starrting to understand accumulate
; ============================================================
; Oh fuck it all i'm confused as all fuck now, can't even write a function that flattens a tree ...

(define (flatten tree)
  (cond ((null? tree) '())
        ((not (pair? tree)) tree)
        ((pair? tree) (append (flatten (car tree)) (flatten (cdr tree))))))

;It works ? 

(map (lambda(x) 1) (flatten (list maList 114 15 16 17 18 19 20)))

(define (count-leaves tree)
  (accumulate + 0 (map (lambda(x) 1) (flatten tree))))

; (count-leaves maList) ==> 13
; yeet

; ============================================================
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      '()
      (cons
        (accumulate op init (map car seqs))
        (accumulate-n op init (map cdr seqs)))))

(define foo (list 1 2 3 4))
,tr accumulate-n
(accumulate-n + 0 (list foo foo foo))

; That was easy ...
; ============================================================

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (mat-*-vect m v)
  (map (lambda(x) (dot-product x v)) m))

(define (transpose m)
  (accumulate-n cons '() m))

(define (mat-*-mat m n)
  (let ((cols (transpose n)))
    (map (lambda (row) (mat-*-vect cols row)) m)))

(accumulate / 2 (list 1 2 3))

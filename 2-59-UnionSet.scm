#lang scheme
; Sets as unordered lists



(define (element-of-set? x set)
  (cond ((null? set) #f)
        ((equal? x (car set)) #t)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (if (element-of-set? x set)
      set
      (cons x set)))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2) (cons (car set1) (intersection-set (cdr set1) set2)))
        (else (intersection-set (cdr set1) set2))))

; I suppose this is going to be the naive implementation of sets, i also predict that oredered sets
; will be more efficient as they'll provide a way to know when to stop and stuff? idk

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        (else (union-set (adjoin-set (car set2) set1) (cdr set2)))))

(define yeet (list 1 2 3 6 9 8 7 4 5))
(define yoet (list 11 6 55 9 888 7 56 32))
yeet
yoet
(intersection-set yeet yoet) ; ==> (6 9 7)
(union-set yeet yoet)        ; ==> (32 56 888 55 11 1 2 3 6 9 8 7 4 5)
#lang scheme
(require racket/trace)
; Ordered sets

(define (element-of-set? x set)
  (cond
    ((null? set) #f)
    ((= x (car set)) #t)
    ((< x (car set)) #f)
    (else (element-of-set? x (cdr set)))))



; (1 2 5 9 17 58 95 99)
; (1 9 18 57 99)

(define (intersection-set set1 set2)
  (cond
    ((or (null? set1) (null? set2)) '())
    ((> (car set1) (car set2)) (intersection-set set1 (cdr set2)))
    ((< (car set1) (car set2)) (intersection-set (cdr set1) set2))
    ((= (car set1) (car set2)) (cons
                                (car set1)
                                (intersection-set (cdr set1) (cdr set2))))))

(define (adjoin-set x set)
  (define (adjoin-set-helper x consumed-set intermediate-set)
    (cond
      ((null? consumed-set) (append intermediate-set (list x)))
      ((> x (car consumed-set)) (adjoin-set-helper
                                 x
                                 (cdr consumed-set)
                                 (append intermediate-set (list (car consumed-set)))))
      ((= x (car consumed-set)) (adjoin-set-helper x (cdr consumed-set) intermediate-set))
      (else (append intermediate-set (list x) consumed-set))))
  (adjoin-set-helper x set '()))

(define list1 '(2 4 8 16 32 64 128 256))
(define list2 '(1 3 11 37 65 130 257))
(define (test n) (adjoin-set n list1))


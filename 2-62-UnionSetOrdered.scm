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
    ((or(null? set1) (null? set2)) '())
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

(trace-define (union-set set1 set2)
              (cond ((null? set1) set2)
                    ((null? set2) set1)
                    (else (union-set (adjoin-set (car set2) set1) (cdr set2)))))

(define yeet '(1 5 9 77))
(define yote '(2 5 7 8 9))

(union-set yeet yote)


#lang scheme
; First implementation 
(define (square-tree tree)
  (cond ((null? tree) '())
        ((not (pair? tree)) (* tree tree))
        (else (cons (square-tree (car tree))
                    (square-tree (cdr tree))))))


(define foo (list 2 (list 4 5 (list 3 4 5 6) 9 8) 3))

(square-tree foo)

(square-tree '(1 '(34 5) 2))


; Second implementation, didnt understand it completely at first, lists keep tripping me up
; List are always a pair, remember it.
; (pair? (list 4)) ; ==>  #t
(define (sqr-tree-map tree)
  (map (lambda(sub-tree)
         (if (pair? sub-tree)
             (sqr-tree-map sub-tree)
             (* sub-tree sub-tree)))
       tree))
         

(sqr-tree-map foo)


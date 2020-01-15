(define (square-list items)
  (if (null? items)
      (list)
      (cons (* (car items) (car items)) (square-list (cdr items)))))

(square-list (list 1 2 3 4 5 9))

(define (square-list-map items)
  (map (lambda(i) (* i i)) items))

(square-list-map (list 1 2 3 4 5 9))


; Pretty straight-forward

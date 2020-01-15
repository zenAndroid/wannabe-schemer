(define (tree-map function tree)
  (map (lambda (subTree)
         (if (pair? subTree)
           (tree-map function subTree)
           (function subTree)))
       tree))


; (define (tree-map function tree)
  ; (map (lambda (subTree)
         ; (if (pair? subTree)
           ; (cons (tree-map function (car subTree)) (tree-map function (cdr subTree)))
           ; (function subTree)))
       ; tree))

; At first, that was my first implementation, i think map implicitly returns '() on an empty list as an input so 
; i think you don't need to check for that.
; That took an unexpected amount of time.

(define example (list (list 1 2) (list 4 (list 98 33))))

(define (square-tree tree) (tree-map sqr tree))

(square-tree example)

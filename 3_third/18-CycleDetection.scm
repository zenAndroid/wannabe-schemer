(define the-list (list 1 2 3))

(set-cdr! (cddr the-list) the-list)

(define (has-cycles? arg-list)
  (define encountered '())
  (define (traverse list-item)
    (if (or (not (pair? list-item)) (null? list-item))
      #f
      (let ((element-encountered?
              (memq list-item encountered)))
        (cond ((not element-encountered?)
               (begin (set! encountered (cons list-item encountered))
                      (traverse (cdr list-item))))
              (element-encountered? #t)))))
  (traverse arg-list))

(define (cycle-haver arg-list)
  (display "The list ")
  (display arg-list)
  (if (has-cycles? arg-list)
    (display " DOES have a cycle\n")
    (display " DOES NOT have a cycle\n")))

(define t1 (list 'a 'b))
(define t2 (list t1 t1))
(define he-list (list 1 2 3))
(set-car! (cddr he-list) (cdr he-list))

(cycle-haver t2)
(cycle-haver the-list)
(cycle-haver he-list)

;Seems to work ...

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

(newline)

(define t1 (list 'a 'b))
(define t2 (list t1 t1))

(display (has-cycles? t2))
(newline)
(display (has-cycles? the-list))

;Seems to work ...

(define the-list (list 1 2 3))

(display the-list)
(newline)

(set-cdr! (cddr the-list)
          (cdr the-list))

(display the-list)
(newline)

(define (has-cycles arg-list)
  (let ((encountered '()))
    (define (traverse list-item)
      (if (null? list-item)
        #f
        (let ((element-encountered?
                (memq list-item encountered)))
          (cond ((not element-encountered?)
                 (begin (set! encountered (cons list-item encountered))
                        (display encountered)
                        (newline)
                        (traverse (cdr list-item))))
                ((element-encountered?) #t)))))
    (traverse arg-list)))

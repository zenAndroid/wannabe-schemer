(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1)))


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
                (memq (car list-item) encountered)))
          (cond ((not element-encountered?)
                 (begin (cons (car list-item) encountered)
                        (traverse (cdr list-item))))
                ((element-encountered?) #t)))))))

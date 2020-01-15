(define (deepReverse aList)
    (define (deepReverseHelper destination arrival)
        (cond ((null? destination) arrival)
              ((not (pair? (car destination))) (deepReverseHelper (cdr destination) (cons (car destination) arrival)))
              (else (deepReverseHelper (cdr destination) (cons (deepReverse (car destination)) arrival)))))
    (deepReverseHelper aList '()))


(define x (list (list 1 (list 34 55 67)) (list 3 4)))

x

(deepReverse x)
(deepReverse '(1 2))

(load "27-HeckingSideEffects.scm")


(zeval '(define (cons x y) (lambda(m) (m x y))) the-global-environment)
(zeval '(define (car z) (z (lambda(p q) p))) the-global-environment)
(zeval '(define (cdr z) (z (lambda(p q) q))) the-global-environment)

(zeval '(define (list-ref items n) 
          (if (= n 0)
            (car items)
            (list-ref (cdr items) (- n 1)))) the-global-environment)

(zeval '(define (map proc items)
          (if (null? items)
            '()
            (cons (proc (car items))
                  (map proc (cdr items))))) the-global-environment)

(zeval '(define (scale-list items factor)
          (map (lambda (x) (* x factor))
               items)) the-global-environment)

(zeval '(define (add-lists list1 list2)
          (cond ((null? list1) list2)
                ((null? list2) list1)
                (else (cons (+ (car list1)
                               (car list2))
                            (add-lists
                              (cdr list1)
                              (cdr list2)))))) the-global-environment)

(zeval '(define ones (cons 1 ones)) the-global-environment)

(zeval '(define (integral integrand initial-value dt)
          (define int
            (cons initial-value
                  (add-lists (scale-list integrand dt)
                             int)))
          int) the-global-environment)

(zeval '(define (solve f y0 dt)
          (define y (integral dy y0 dt))
          (define dy (map f y))
          y) the-global-environment)


; The answer to the actual question is kind of given by the textbook itself.
; The difference is that even the first element of a pair is delayes, which
; allows for creation of infinte datastructure like infinitely deep trees.

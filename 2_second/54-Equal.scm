#lang scheme

(define (equal? first second)
  (define (atom? x)
                (not (pair? x)))
  (define (both-atoms? x y)
    (and (atom? x) (atom? y)))
  (define (both-list? x y)
    (and (list? x) (list? y)))
  
  (cond ((both-atoms? first second) (eq? first second)) ; Are the two objects both atoms ?, in that
                                                        ; case return whether they're equal or not.
        ((both-list? first second) (and ; Are the two objects both lists?, if so then return whether
                                        ; the first item in both of those lists are equal, then see
                                        ; whether the rest of the lists is equal.
                                    (eq? (car first) (car second))
                                    (equal? (cdr first) (cdr second))))
        (else #f))) ; ELSE (meaning the two items are mismatched), then return false, as they are
                    ; both obviously not equal

(equal? 'a 'a) ; ==> #t

(equal? '() '()) ; ==> #t

(equal? '(1 2 3 1) '(1 2 3 1)) ; ==> #t

(equal? '(this is a list) '(this is a list)) ; ==> #t

(equal? '(this is a list) '(this (is a) list)) ; ==> #f

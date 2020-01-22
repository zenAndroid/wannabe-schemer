#!/usr/bin/racket -f
(require racket/include)
(require racket/trace)



(include "2-88-NegateYerTerms.scm")

(define dividend-terms-list (list
                             (list 5 1)
                             (list 0 -1)))

(define divisor-terms-list (list
                             (list 2 1)
                             (list 0 -1)))

(define dividend (make-poly 'x dividend-terms-list))
(define divisor (make-poly 'x divisor-terms-list))

(display dividend)
(newline)
(display divisor)
(newline)

(trace sub)
(display (div dividend divisor))

(use-modules (srfi srfi-1))
(use-modules (srfi srfi-9))
(use-modules (ice-9 pretty-print))
(define inst1 '(assign f (reg a)))
(define inst2 '(assign f (op +) (cst 3) (reg a)))
(define inst3 '(assign f (op -) (cst 3) (reg e)))

(define inst4 '(assign t (reg g)))
(define inst5 '(assign t (op +) (cst 4) (reg y)))
(define inst6 '(assign t (op -) (cst 2) (reg h)))

(define foo (make-hash-table))

(hashq-set! foo (cadr inst1) (list (cddr inst1)))

(hashq-set! foo 'f (cons (cddr inst2) (hashq-ref foo 'f)))

(hashq-set! foo 'f (cons (cddr inst3) (hashq-ref foo 'f)))

(hashq-set! foo (cadr inst4) (list (cddr inst4)))

(hashq-set! foo 't (cons (cddr inst5) (hashq-ref foo 't)))

(hashq-set! foo 't (cons (cddr inst6) (hashq-ref foo 't)))

foo

(hash-for-each (lambda(k v) (pretty-print (list k v)) (newline)) foo)

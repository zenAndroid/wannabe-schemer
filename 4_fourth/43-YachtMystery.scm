; 2020-03-23 16:09 :: zenAndroid

(load "00-AmbEval.scm") 

(driver-loop)

(define (require p)
  (if (not p)
    (amb)))
(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))



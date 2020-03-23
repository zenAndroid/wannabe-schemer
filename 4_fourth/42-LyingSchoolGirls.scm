; 2020-03-23 14:04 :: zenAndroid :: Here we go ...

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

(define (lying-schoolgirls)
  (let ((betty (amb 1 2 3 4 5))
        (ethel (amb 1 2 3 4 5))
        (joan (amb 1 2 3 4 5))
        (kitty (amb 1 2 3 4 5))
        (mary (amb 1 2 3 4 5)))
    (amb (require (= betty 3)) (require (= kitty 2)))
    (amb (require (= ethel 1)) (require (= joan 2)))
    (amb (require (= joan 3)) (require (= ethel 5)))
    (amb (require (= kitty 2)) (require (= mary 4)))
    (amb (require (= mary 4)) (require (= betty 1)))
    (list (list 'betty betty)
          (list 'ethel ethel)
          (list 'joan joan)
          (list 'kitty kitty)
          (list 'mary mary))))

(lying-schoolgirls)

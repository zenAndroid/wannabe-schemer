(define (make-mobile left right)
    (list left right))

(define (make-branch lengtH structur)
    (list lengtH structur))

(define (left-branch mobile)
    (car mobile))

(define (right-branch mobile)
    (car (cdr mobile)))

(define foo (make-mobile "left" "right"))
(left-branch foo)
(right-branch foo)

(define br (make-branch 3 foo))


(define (branch-length branch)
    (car branch))

(define (branch-structure branch)
  (car (cdr branch)))

(define (total-weight mobile)
  (+
    (weight (left-branch mobile))
    (weight (right-branch mobile))))

(define (weight structure)
  (if (pair? (branch-structure structure))
      (total-weight (branch-structure structure))
      (branch-structure structure)))

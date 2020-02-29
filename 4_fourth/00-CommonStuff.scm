; # 2020-02-29 13:42 :: zenAndroid :: This will include the common functions
; used by the files, did not want to load the books's code directly as that has
; the effect of pretty much skipping all of this stuff and implementing
; eval/apply, and I want to GRASP the magic, not just use it.

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))
(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))
(define (make-lambda parameters body)
  (list 'lambda parameters body))
(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (make-one-armed-if predicate consequent)
  (list 'if predicate consequent))

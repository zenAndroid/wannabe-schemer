; 2020-02-29 11:33 :: zenAndroid ::  Other solutions only implemented a subset, I will therefore probably implement while and until
; Also, I saw Eli's solution and didn't like that it leaked the definition of the while-iter procedure to the outer namespace.


; For reference:
; (until <condition> <body>)

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (until? exp) (tagged-list? exp 'until))

(define (until-condition exp) (cadr exp))

(define (until-body exp) (cddr exp))

(define (make-lambda parameters body)
  (list 'lambda parameters body))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (make-one-armed-if predicate consequent)
  (list 'if predicate consequent))

(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))

(define (until-exp-handler exp)
  (let ((condition (until-condition exp))
        (body (until-body exp)))
    (let ((loop-definition (list 'define (list 'loop)
                                 (make-one-armed-if condition
                                                    (sequence->exp (list (sequence->exp body) (list 'loop)))))))
    (list
      (make-lambda '()
                   (sequence->exp (list loop-definition (list 'loop))))))))

(define test-code
  '(until
     (< ii 5)
     (display ii)
     (set! ii (+ ii 1))))

(define ii 0)

((lambda ()
   (begin
     (define (loop)
       (if (< ii 5)
         (begin
           (begin (display ii) (newline) (set! ii (+ ii 1)))
           (loop))))
     (loop))))

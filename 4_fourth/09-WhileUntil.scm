; 2020-02-29 11:33 :: zenAndroid ::  Other solutions only implemented a subset, I will therefore probably implement while and until
; Also, I saw Eli's solution and didn't like that it leaked the definition of the while-iter procedure to the outer namespace.


; For reference:
; (while <condition> <body>)

(load "08-NamedLet.scm")

; While handler {{{1 ;

(define (while? exp) (tagged-list? exp 'while))

(define (while-condition exp) (cadr exp))

(define (while-body exp) (cddr exp))

(define (while-exp-handler exp)
  (let ((condition (while-condition exp))
        (body (while-body exp)))
    (let ((loop-definition (list 'define (list 'loop)
                                 (make-one-armed-if condition
                                                    (sequence->exp (list (sequence->exp body) (list 'loop)))))))
    (list
      (make-lambda '()
                   (list loop-definition (list 'loop)))))))

; 1}}} ;

(define test-code
  '(while
     (< ii 5)
     (display ii)
     (set! ii (+ ii 1))))

(define ii 0)

; ((lambda ()
;    (begin
;      (define (loop)
;        (if (< ii 5)
;          (begin
;            (begin (display ii) (newline) (set! ii (+ ii 1)))
;            (loop))))
;      (loop))))

; (display (while-exp-handler test-code))

; works , so ¯\_(ツ)_/¯

(define (zeval exp env);{{{
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((named-let? exp) (zeval (named-let-handler exp) env))
        ((let? exp) (zeval (let->combination exp) env))
        ((letStar? exp) (zeval (let*->nested-lets exp) env))
        ((while? exp) (zeval (while-exp-handler exp) env))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp) 
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (zeval (cond->if exp) env))
        ((application? exp)
         (apply (zeval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))));}}}

; (driver-loop)

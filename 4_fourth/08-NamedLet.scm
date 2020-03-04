; 2020-02-28 18:49 :: zenAndroid :: Making DG look like a neurotypical with
; this density of mine, but eh, no use sweating over it too much

(use-modules (ice-9 pretty-print)) 
; Just so you know, zen, this is for pretty printing the 'code' (the data (((At this point what's the difference? yEEeeEEEt

(load "07-LetStar.scm")

(define test-code
  '(let fib-iter ((a 1) (b 0) (count n))
     (if (= count 0)
       b
       (fib-iter (+ a b)
                 a
                 (- count 1)))))

; Just for reference: (let <var> <bindings> <body>)

;;;;;   (define (named-let-var exp) (cadr exp))
;;;;;   
;;;;;   (define (named-let-var-exps exp) (caddr exp))
;;;;;   
;;;;;   (define (named-let-vars exp) (map car (named-let-var-exps exp))) 
;;;;;   
;;;;;   (define (named-let-exps exp) (map cadr (named-let-var-exps exp)))
;;;;;   
;;;;;   (define (named-let-body exp) (cdddr exp)) 
;;;;;   ; cadddr or cdddr ? I wonder, no actually I think I rather use cdddr since
;;;;;   ; technically there could be a series of expressions with a regular let body,
;;;;;   ; so I figure functionaliy is transferred over to this more specialized
;;;;;   ; version.
;;;;;   
;;;;;   
;;;;;   (define (named-let? exp)
;;;;;     (and (tagged-list 'let)
;;;;;          (symbol? (cadr exp))))
;;;;;   
;;;;;   (define (named-let-temp-handler exp)
;;;;;     (let ((proc (list 'define (cons (named-let-var exp)
;;;;;                                     (named-let-vars exp))
;;;;;                       (sequence->exp (named-let-body exp)))))
;;;;;       (list (make-lambda '() (sequence->exp 
;;;;;                                (list proc 
;;;;;                                      (cons 
;;;;;                                        (named-let-var exp) 
;;;;;                                        (named-let-exps exp))))))))
;;;;;   


; scheme@(guile-user)> (pretty-print (named-let-temp-handler test-code))
; ((lambda ()
;    (define (fib-iter a b count)
;      (if (= count 0)
;        b
;        (fib-iter (+ a b) a (- count 1)))))
;  (fib-iter 1 0 n))

;;;  (define (fib n)
;;;    ((lambda ()
;;;       (define (fib-iter a b count)
;;;         (if (= count 0)
;;;           b
;;;           (fib-iter (+ a b) a (- count 1)))))
;;;     (fib-iter 1 0 n)))

; Yep, good thing I tested this, there is a bug ...

; (define (fib n)
;   ((lambda ()
;      (begin
;        (define (fib-iter a b count)
;          (if (= count 0)
;            b
;            (fib-iter (+ a b) a (- count 1))))
;        (fib-iter 1 0 n)))))
; 
; Seems correct
; .. I hope I did not miss something obious, though I don't think so.

(define I-wonder
  '(let foo ((a 5)
             (b 30))
     (display (foo a b))))

; Yep, it seems to work, took me a while but I got it.

;;;SECTION 4.1.1

(define (zeval exp env);{{{
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((named-let? exp) (zeval (named-let-handler exp) env))
        ((let? exp) (zeval (let->combination exp) env))
        ((letStar? exp) (zeval (let*->nested-lets exp) env))
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

; Named let handler {{{1 ;

; Just for reference: 
; (let <var>   <-----<bindings>----->  <-------------------<body>----------------------->)
; 
(define foo '(let fibIter ((a 1) (b 0) (count n)) (if (= count 0) b (fibIter (+ a b) a (- count 1)))))

(define (named-let-var exp) (cadr exp))

(define (named-let-var-exps exp) (caddr exp))

(define (named-let-vars exp) (map car (named-let-var-exps exp))) 

(define (named-let-exps exp) (map cadr (named-let-var-exps exp)))

(define (named-let-body exp) (cdddr exp)) 
; cadddr or cdddr ? I wonder, no actually I think I rather use cdddr since
; technically there could be a series of expressions with a regular let body,
; so I figure functionaliy is transferred over to this more specialized
; version.


(define (named-let? exp)
  (and (tagged-list? exp 'let)
       (symbol? (cadr exp))))

(define (named-let-handler exp)
  (let ((proc (list 'define (cons (named-let-var exp)
                                  (named-let-vars exp))
                    (sequence->exp (named-let-body exp)))))
    (list (make-lambda '() (list proc 
                                   (cons 
                                     (named-let-var exp) 
                                     (named-let-exps exp)))))))

; 1}}} ;

; (driver-loop)

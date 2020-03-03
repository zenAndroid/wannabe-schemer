; 2020-02-27 17:53 :: zenAndroid :: This should be relatively simple ...
; 2020-03-02 18:40 :: zenAndroid :: Time for the T E S T

;;; (define (let? exp) (tagged-list? exp 'let))
;;; 
;;; (define (let-var-exps exp) (cadr exp))
;;; 
;;; (define (let-body exp) (cddr exp))
;;; 
;;; (define (let-vars exp) (map car (let-var-exps exp)))
;;; 
;;; (define (let-exps exp) (map cadr (let-var-exps exp)))
;;; 
;;; (define (let->combination exp)
;;;   (cons (make-lambda (let-vars exp) (seq->expr (let-body exp)))
;;;         ; Used to use list, but changed to cons, because list creates a new list when cons just extends the old one
;;;         (let-exps exp)))

(load "05-Alt-cond.scm") 
; 2020-03-03 18:02 :: zenAndroid :: Hey, I'm here to remove redundancy.
; Modified evaluator that can handle alternative forms of cond clause,
; LOADED

; Solutions are making me fucking angry.

; everywhere I go I find that the body is defined as cddr and not caddr, and I don't understand why
; I will attempt to test this ...

(define foo
  '(let
     ((foo boo)
      (faa baa)
      (poo loo))
     BODY))

; scheme@(guile-user)> (let->combination foo)
; $2 = ((lambda (foo faa poo) BODY) (boo baa loo))
; Seems OK, now let's add more subexpressions and see what happens.

; scheme@(guile-user)> (define foo
;   '(let
;      ((foo boo)
;       (faa baa)
;       (poo loo))
;      (foo)
; ... (poo)))
; scheme@(guile-user)> foo
; $2 = (let ((foo boo) (faa baa) (poo loo)) (foo) (poo))
; scheme@(guile-user)> (let->combination foo)
; $3 = ((lambda (foo faa poo) (foo)) (boo baa loo))
; scheme@(guile-user)> 


; Yeah okay sure, but let forms arent even supposed to have multiple
; subexpressions in them, so until I need to change that I'll go with my
; version

;;;;;;;;;;;;;;;;;
;  I was WRONG  ;
;;;;;;;;;;;;;;;;;

; Im changing the caddr to cddr
; But I'm still pissed they did not explain it

; ps just to explain this to the future form of me or someome else: its because
; the <body> can be a bunch of statements, so if you choose caddr you might
; just get one such statement, but if you do cddr, youll get em all, so you can
; just transfrom them into one statements by stuffing all of them into a begin
; form ;)               - Brought to you by the 'this seems obvious to me now
; but I know it wont be later on so here we are' gang

;;;SECTION 4.1.1

(define (zeval exp env);{{{
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((let? exp) (zeval (let->combination exp) env))
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

; Let Form handler {{{1 ;

(define (let? exp) (tagged-list? exp 'let))

(define (let-var-exps exp) (cadr exp))

(define (let-body exp) (cddr exp))

(define (let-vars exp) (map car (let-var-exps exp)))

(define (let-exps exp) (map cadr (let-var-exps exp)))

(define (let->combination exp)
  (cons (make-lambda (let-vars exp) (let-body exp))
        ; Used to use list, but changed to cons, because list creates a new list when cons just extends the old one
        (let-exps exp)))

; 1}}} ;

(driver-loop)

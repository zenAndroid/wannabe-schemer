; 2020-02-27 21:03 :: zenAndroid :: ... I am ... yikes at this point I am
; officially even worse than Dragon God ...

; (let* <bindings> <body>)

(load "06-EvalLet.scm")

(define foo
  `(let*
     ((a 5)
      (b a)
      (c b))
     (foo) (bar) (baz)))

; scheme@(guile-user)> (define foo
; ...   `(let*
; ...      ((a 5)
; ...       (b a)
; ...       (c b))
; ...      (foo) (bar) (baz)))
; scheme@(guile-user)> (let*->nested-lets foo)
; $1 = (let ((a 5)) (let ((b a)) (let ((c b)) (begin (foo) (bar) (baz)))))
; scheme@(guile-user)> (use-modules (ice-9 pretty-print))
; scheme@(guile-user)> (pretty-print(let*->nested-lets foo))
; (let ((a 5))
;   (let ((b a))
;     (let ((c b)) (begin (foo) (bar) (baz)))))

; Seems to be working correctly, yey

;;;SECTION 4.1.1

(define (zeval exp env);{{{
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
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

; Nested-let handler {{{1 ;

(define (letStar? exp) (tagged-list? exp 'let*))

(define (bindings exp) (cadr exp))

(define (let*-body exp) (cddr exp)) ; 2020-03-02 21:40 :: zenAndroid ::Fucking caddr or cddr man I don't knkow this shit is confucing me man

(define (first-binding bindings) (car bindings))

(define (rest-bindings bindings) (cdr bindings))

(define (make-let bindings body) (list 'let bindings body))

(define (let*->nested-lets exp)
  ; 2020-02-28 18:50 :: zenAndroid ::I don't even remember clearly my thought
  ; process at the time, hopefully my notes are clear enough :sweat:
  (define (iter bindings)
    (if (null? bindings)
      (sequence->exp (let*-body exp))
      (make-let (list (first-binding bindings))
                (iter (rest-bindings bindings)))))
  (iter (bindings exp)))

; 1}}} ;

;;;Following are commented out so as not to be evaluated when
;;; the file is loaded.
(display (let*->nested-lets foo))


(driver-loop)

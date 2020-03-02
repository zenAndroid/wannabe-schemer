; 2020-02-27 14:35 :: zenAndroid ::  I am realizing that I am going slowly through this, wonder if what I am doing is optimal or not ...

; The alternate form of the cond clause is the following
; 
; (<test> => <recipient>)
; 
; I'm an idiot sometimes.
; 
; Anyways, so at first I kept forgetting that I'm *programmaticaly writing code* and so I was trying to produce evals and applys withing the code but that wasn't it.
; 
; Anyways.
; 
; So, Zen, next time, reason like this:
; 
; The code (<test> => <recipient>) produces this (if test (recipient test)), so
; 
; in the cond->if this needs a couple of things:
; 
; 1. a way to detect this form.
; 2. a way to extract the components.
; 3. a way to generate the necessary code.
; 
; point 1:

;;;;;;      (define (alt-cond-clause? clause)
;;;;;;        (and (list? clause)
;;;;;;             (eq? (length clause) 3)
;;;;;;             (eq? (cadr clause '=>))))
;;;;;;      
;;;;;;      ; point 2.
;;;;;;      
;;;;;;      (define (alt-cond-clause-test clause)
;;;;;;        (car clause))
;;;;;;      
;;;;;;      (define (alt-cond-clause-recipient clause)
;;;;;;        (caddr clause))
;;;;;;      
;;;;;;      ; point 3.
;;;;;;      
;;;;;;      (define (cond->if exp)
;;;;;;        (expand-clauses (cond-clauses exp)))
;;;;;;      
;;;;;;      ; (define (expand-clauses clauses)
;;;;;;      ;   (if (null? clauses)
;;;;;;      ;     'false     ; no else clause
;;;;;;      ;     (let ((first (car clauses))
;;;;;;      ;           (rest (cdr clauses)))
;;;;;;      ;       (if (cond-else-clause? first)
;;;;;;      ;         (if (null? rest)
;;;;;;      ;           (sequence->exp (cond-actions first))
;;;;;;      ;           (error "ELSE clause isn't last: COND->IF" clauses))
;;;;;;      ;       (make-if (cond-predicate first)
;;;;;;      ;                (sequence->exp (cond-actions first))
;;;;;;      ;                (expand-clauses rest))))))
;;;;;;      
;;;;;;      (define (expand-clauses clauses)
;;;;;;        (if (null? clauses)
;;;;;;          'false     ; no else clause
;;;;;;          (let ((first (car clauses))
;;;;;;                (rest (cdr clauses)))
;;;;;;            (if (cond-else-clause? first)
;;;;;;              (if (null? rest)
;;;;;;                (sequence->exp (cond-actions first))
;;;;;;                (error "ELSE clause isn't last: COND->IF" clauses))
;;;;;;              (if (alt-cond-clause? first)
;;;;;;                (make-if (alt-cond-clause-test first)
;;;;;;                         (list
;;;;;;                           (alt-cond-clause-recipient first)
;;;;;;                           (alt-cond-clause-test first))
;;;;;;                         (expand-clauses rest)))
;;;;;;            (make-if (cond-predicate first)
;;;;;;                     (sequence->exp (cond-actions first))
;;;;;;                     (expand-clauses rest))))))
;;;;;;      
;;;;;;      ; That should be it, ... Eli used cond to avoid those ugly nested ifs, but I
;;;;;;      ; didn't do it because using cond while evaluating cond doesnt let me know what's
;;;;;;      ; going on under the hood.
;;;;;;      ; Also, looking at Common Lisp code, that stuff looks ugly as heck man ... holy
;;;;;;      ; hell


; 2020-03-02 17:49 :: zenAndroid :: Now that I implemented the MetaCircular
; Evaluator, I plan on actually testing this to check that it works.

; Let me just review the code I added to see the thing I need to replace


(define apply-in-underlying-scheme apply)

;;;SECTION 4.1.1

(define (eval exp env);{{{
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp) 
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))));}}}


(define (self-evaluating? exp)
  (cond ((number? exp) #t)
        ((string? exp) #t)
        (else #f)))

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      #f))

(define (variable? exp) (symbol? exp))

(define (assignment? exp)
  (tagged-list? exp 'set!))

(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))

(define (definition? exp)
  (tagged-list? exp 'define))

(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)
                   (cddr exp))))

(define (lambda? exp) (tagged-list? exp 'lambda))

(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (if? exp) (tagged-list? exp 'if))

(define (if-predicate exp) (cadr exp))

(define (if-consequent exp) (caddr exp))

(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (make-one-armed-if predicate consequent)
  (list 'if predicate consequent))

(define (begin? exp) (tagged-list? exp 'begin))

(define (begin-actions exp) (cdr exp))

(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))


(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))


(define (cond? exp) (tagged-list? exp 'cond))

(define (cond-clauses exp) (cdr exp))

(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))

(define (cond-predicate clause) (car clause))

(define (cond-actions clause) (cdr clause))

(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

(define (alt-cond-clause? clause)
  (and (list? clause)
       (eq? (length clause) 3)
       (eq? (cadr clause) '=>)))


(define (alt-cond-clause-test clause)
  (car clause))

(define (alt-cond-clause-recipient clause)
  (caddr clause))

(define (expand-clauses clauses)
  (if (null? clauses)
    'false     ; no else clause
    (let ((first (car clauses))
          (rest (cdr clauses)))
      (if (cond-else-clause? first)
        (if (null? rest)
          (sequence->exp (cond-actions first))
          (error "ELSE clause isn't last: COND->IF" clauses))
        (if (alt-cond-clause? first)
          (make-if (alt-cond-clause-test first)
                   (list
                     (alt-cond-clause-recipient first)
                     (alt-cond-clause-test first))
                   (expand-clauses rest))
          (make-if (cond-predicate first)
                   (sequence->exp (cond-actions first))
                   (expand-clauses rest)))))))

(define (apply procedure arguments);{{{
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence
           (procedure-body procedure)
           (extend-environment
             (procedure-parameters procedure)
             arguments
             (procedure-environment procedure))))
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))));}}}

(define (list-of-values exps env);{{{
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))));}}}

(define (eval-if exp env);{{{
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)));}}}

(define (eval-sequence exps env);{{{
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))));}}}

(define (eval-assignment exp env);{{{
  (set-variable-value! (assignment-variable exp)
                       (eval (assignment-value exp) env)
                       env)
  'ok);}}}

(define (eval-definition exp env);{{{
  (define-variable! (definition-variable exp)
                    (eval (definition-value exp) env)
                    env)
  'ok);}}}



;;; Evaluator data structures

(define (true? x)
  (not (eq? x #f)))

(define (false? x)
  (eq? x #f))

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

(define (compound-procedure? p)
  (tagged-list? p 'procedure))


(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))


(define (enclosing-environment env) (cdr env))

(define (first-frame env) (car env))

(define the-empty-environment '())

(define (make-frame variables values)
  (cons variables values))

(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))

(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (car vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! var val frame))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))

;;;SECTION 4.1.4

(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true #t initial-env)
    (define-variable! 'false #f initial-env)
    initial-env))

;[do later] (define the-global-environment (setup-environment))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list '> >)
        (list '< <)
        (list '= =)
;;      more primitives
        ))

(define (primitive-procedure-names)
  (map car primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

;[moved to start of file] (define apply-in-underlying-scheme apply)

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))

(define input-prompt ";;; M-Eval input:")
(define output-prompt ";;; M-Eval value:")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (eval input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))

(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))

;;;Following are commented out so as not to be evaluated when
;;; the file is loaded.
(define the-global-environment (setup-environment))
(driver-loop)

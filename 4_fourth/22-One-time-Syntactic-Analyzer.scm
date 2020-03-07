; 2020-03-06 22:20 :: zenAndroid :: Uuuhh, gotta be honest here i'm not 100%
; sure I understand how the analyzer works, I mean, does it really pass on each
; S-expression once ? and if so how does it do that with no state, or maybe
; those lets that come before the lambda *are* implicit state ? idk, I'm led to
; believe so ... will think about it ...

; 2020-03-06 22:51 :: zenAndroid :: OH SHIT NOW I GET IT, fuck DMN THATS COOL
; 2020-03-06 22:51 :: zenAndroid ::  Wait no I don't ...
; 2020-03-06 22:51 :: zenAndroid ::  Now, hold on, I thnk if I make my thoughts
; explicit on this i'd understand better, or explain this , yep I think I got
; it, zen, think of it in terms of the environment diagrams and stuff like
; that, following is an attempt at explaining it that should make it clearer.


; I will just copy the explanation from somewhere else, I think it is close
; enough to the understanding that it shouldnt matter much ...

; To understand what the analyzer does, have another look at analyze-if:
; 
; ; ; ; ; ; (define (analyze-if exp)
; ; ; ; ; ;   (let ((pproc (analyze (if-predicate exp)))
; ; ; ; ; ;         (cproc (analyze (if-consequent exp)))
; ; ; ; ; ;         (aproc (analyze (if-alternative exp))))
; ; ; ; ; ;     (lambda (env)
; ; ; ; ; ;       (if (true? (pprocenv))
; ; ; ; ; ;         (cprocenv)
; ; ; ; ; ;         (aprocenv)))))
; 
; The returned value is a procedure derived from evaluating
; 
; (lambda (env)
;   (if (true? (pprocenv))
;     (cprocenv)
;     (aprocenv)))))
; 
; in an environment where pproc, cproc and aproc are defined.










; I hope that helped, and if there is still some confusion, think of it in
; terms of the box diagrams of environment, evaluating (analyze-if) leaves you
; with an environment (box) where pproc, cproc and aproc are defined already.


; I have to say tho, when (analyze-if '(if (foo) (bar) (baz))) gets called,
; and the thingy with the environment thing happens,

; ... *how does the next call to (analyze-if '(if (foo) (bar) (baz))) "know" to
; get the value from the environment created previously and not run the
; analyzer on the components of the if exxpression again ?







; Well, I don't really want to confuse myself here, so instead of trying to be
; "efficient" or "elegant", i'll just copy all the code from the base
; meta-circular evaluator ...


(define apply-in-underlying-scheme apply)

(define (zeval exp env)
  ((analyze exp) env))

(define (analyze exp)
  (cond ((self-evaluating? exp) 
         (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((assignment? exp) (analyze-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
        ((lambda? exp) (analyze-lambda exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
        ((application? exp) (analyze-application exp))
        (else
         (error "Unknown expression type -- ANALYZE" exp))))

(define (analyze-self-evaluating exp)
  (lambda (env) exp))

(define (analyze-quoted exp)
  (let ((qval (text-of-quotation exp)))
    (lambda (env) qval)))

(define (analyze-variable exp)
  (lambda (env) (lookup-variable-value exp env)))

(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp))))
    (lambda (env)
      (set-variable-value! var (vproc env) env)
      'ok)))

(define (analyze-definition exp)
  (let ((var (definition-variable exp))
        (vproc (analyze (definition-value exp))))
    (lambda (env)
      (define-variable! var (vproc env) env)
      'ok)))

(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
        (cproc (analyze (if-consequent exp)))
        (aproc (analyze (if-alternative exp))))
    (lambda (env)
      (if (true? (pproc env))
          (cproc env)
          (aproc env)))))

(define (analyze-lambda exp)
  (let ((vars (lambda-parameters exp))
        (bproc (analyze-sequence (lambda-body exp))))
    (lambda (env) (make-procedure vars bproc env))))

(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env) (proc1 env) (proc2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
        first-proc
        (loop (sequentially first-proc (car rest-procs))
              (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence -- ANALYZE"))
    (loop (car procs) (cdr procs))))

(define (analyze-application exp)
  (let ((fproc (analyze (operator exp)))
        (aprocs (map analyze (operands exp))))
    (lambda (env)
      (execute-application (fproc env)
                           (map (lambda (aproc) (aproc env))
                                aprocs)))))

(define (execute-application proc args)
  (cond ((primitive-procedure? proc)
         (apply-primitive-procedure proc args))
        ((compound-procedure? proc)
         ((procedure-body proc)
          (extend-environment (procedure-parameters proc)
                              args
                              (procedure-environment proc))))
        (else
         (error
          "Unknown procedure type -- EXECUTE-APPLICATION"
          proc))))


; Self-evaluating, variables, and tagged list predicate {{{1 ;

(define (self-evaluating? exp)
  (cond ((number? exp) #t)
        ((string? exp) #t)
        (else #f)))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      #f))

(define (variable? exp) (symbol? exp))

; 1}}} ;
; Quoted expression handler {{{1 ;

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

; 1}}} ;
; Assignement handler {{{1 ;

(define (assignment? exp)
  (tagged-list? exp 'set!))

(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))
; 1}}} ;
; Definition handler {{{1 ;

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
; 1}}} ;
; Lambda handler {{{1 ;

(define (lambda? exp) (tagged-list? exp 'lambda))

(define (lambda-parameters exp) (cadr exp))

(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

; 1}}} ;
; If-expression handler {{{1 ;

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

; 1}}} ;
; Compound sequences of expressions handler {{{1 ;

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

; 1}}} ;
; Procedure application handler {{{1 ;

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

; 1}}} ;
; Cond expression handler {{{1 ;

(define (cond? exp) (tagged-list? exp 'cond))

(define (cond-clauses exp) (cdr exp))

(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))

(define (cond-predicate clause) (car clause))

(define (cond-actions clause) (cdr clause))

(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false                          ; no else clause
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (if (cond-else-clause? first)
            (if (null? rest)
                (sequence->exp (cond-actions first))
                (error "ELSE clause isn't last -- COND->IF"
                       clauses))
            (make-if (cond-predicate first)
                     (sequence->exp (cond-actions first))
                     (expand-clauses rest))))))

; 1}}} ;
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
      (cons (zeval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))));}}}
(define (eval-if exp env);{{{
  (if (true? (zeval (if-predicate exp) env))
      (zeval (if-consequent exp) env)
      (zeval (if-alternative exp) env)));}}}
(define (eval-sequence exps env);{{{
  (cond ((last-exp? exps) (zeval (first-exp exps) env))
        (else (zeval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))));}}}
(define (eval-assignment exp env);{{{
  (set-variable-value! (assignment-variable exp)
                       (zeval (assignment-value exp) env)
                       env)
  'ok);}}}
(define (eval-definition exp env);{{{
  (define-variable! (definition-variable exp)
                    (zeval (definition-value exp) env)
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
        (list '< <)
        (list '> >)
        (list '= =)
        (list '+ +)
        (list '- -)
        (list '* *)
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
    (let ((output (zeval input the-global-environment)))
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
; (driver-loop)
(zeval '(define (f n)
          (if (= n 0)
            1
            (* n (f (- n 1))))) the-global-environment)
(define time (current-time))
(zeval '(f 500000) the-global-environment)
(set! time (- (current-time) time))
(newline)
(display "The time it took for calculating the factorial of (whatever you put in the code) is: ")
(display time)
(newline)
; Here's hoping for less than 11 mins .. hopefully significantly so ..
; ; ; ; ; ; guile -l 22-One-time-Syntactic-Analyzer.scm
; ; ; ; ; ; 
; ; ; ; ; ; The time it took for calculating the factorial of (whatever you put in the code) is: 683
; ; ; ; ; ; GNU Guile 2.2.6
; ; ; ; ; ; Copyright (C) 1995-2019 Free Software Foundation, Inc.
; ; ; ; ; ; 
; ; ; ; ; ; Guile comes with ABSOLUTELY NO WARRANTY; for details type `,show w'.
; ; ; ; ; ; This program is free software, and you are welcome to redistribute it
; ; ; ; ; ; under certain conditions; type `,show c' for details.
; ; ; ; ; ; 
; ; ; ; ; ; Enter `,help' for help.
; ; ; ; ; ; scheme@(guile-user)>
; ; ; ; ; ; 

; This is weird, its almost the same as the normal version, (684 seconds),
; kinda creepy and probably indicative of something deeper going on ... 

; 2020-03-08 14:36 :: zenAndroid ::  Confusing indeed :thinking:


(load "00-The-Actual-Meta-Eval.scm")

(define (zeval exp env)
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
        ((cond? exp) (zeval (cond->if exp) env))
        ((application? exp)             ; clause from book
         (apply (actual-value (operator exp) env)
                (operands exp)
                env))
        (else
         (error "Unknown expression type -- EVAL" exp))))

(define (actual-value exp env)
  (force-it (zeval exp env)))

(define (apply procedure arguments env)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
          procedure
          (list-of-arg-values arguments env))) ; changed
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           (procedure-parameters procedure)
           (list-of-delayed-args arguments env) ; changed
           (procedure-environment procedure))))
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))

(define (list-of-arg-values exps env)
  (if (no-operands? exps)
      '()
      (cons (actual-value (first-operand exps) env)
            (list-of-arg-values (rest-operands exps)
                                env))))

(define (list-of-delayed-args exps env)
  (if (no-operands? exps)
      '()
      (cons (delay-it (first-operand exps) env)
            (list-of-delayed-args (rest-operands exps)
                                  env))))

(define (eval-if exp env)
  (if (true? (actual-value (if-predicate exp) env))
      (zeval (if-consequent exp) env)
      (zeval (if-alternative exp) env)))

(define input-prompt ";;; L-Eval input:")
(define output-prompt ";;; L-Eval value:")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output
           (actual-value input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(define (delay-it exp env)
  (list 'thunk exp env))

(define (thunk? obj)
  (tagged-list? obj 'thunk))

(define (thunk-exp thunk) (cadr thunk))
(define (thunk-env thunk) (caddr thunk))

;; "thunk" that has been forced and is storing its (memoized) value
(define (evaluated-thunk? obj)
  (tagged-list? obj 'evaluated-thunk))

(define (thunk-value evaluated-thunk) (cadr evaluated-thunk))


;; memoizing version of force-it

(define (force-it obj)
  (cond ((thunk? obj)
         (let ((result (actual-value
                        (thunk-exp obj)
                        (thunk-env obj))))
           (set-car! obj 'evaluated-thunk)
           (set-car! (cdr obj) result)  ; replace exp with its value
           (set-cdr! (cdr obj) '())     ; forget unneeded env
           result))
        ((evaluated-thunk? obj)
         (thunk-value obj))
        (else obj)))


;; A longer list of primitives -- suitable for running everything in 4.2
;; Overrides the list in ch4-mceval.scm

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list 'list list)
        (list '+ +)
        (list '- -)
        (list '* *)
        (list '/ /)
        (list '= =)
        (list 'newline newline)
        (list 'display display)
;;      more primitives
        ))

'LAZY-EVALUATOR-LOADED



;;; ;;; ;;; [zenandroid ~/gitRepos/scheming/4_fourth]$ guile -l 27-HeckingSideEffects.scm
;;; ;;; ;;; GNU Guile 2.2.6
;;; ;;; ;;; Copyright (C) 1995-2019 Free Software Foundation, Inc.
;;; ;;; ;;; 
;;; ;;; ;;; Guile comes with ABSOLUTELY NO WARRANTY; for details type `,show w'.
;;; ;;; ;;; This program is free software, and you are welcome to redistribute it
;;; ;;; ;;; under certain conditions; type `,show c' for details.
;;; ;;; ;;; 
;;; ;;; ;;; Enter `,help' for help.
;;; ;;; ;;; scheme@(guile-user)> (driver-loop)
;;; ;;; ;;; 
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval input:
;;; ;;; ;;; (define cnt 0)
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval value:
;;; ;;; ;;; ok
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval input:
;;; ;;; ;;; (define (id x) (set! cnt (+ cnt 1)) x)
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval value:
;;; ;;; ;;; ok
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval input:
;;; ;;; ;;; (define w (id (id 10)))
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval value:
;;; ;;; ;;; ok
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval input:
;;; ;;; ;;; cnt
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval value:
;;; ;;; ;;; 1
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval input:
;;; ;;; ;;; w
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval value:
;;; ;;; ;;; 10
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval input:
;;; ;;; ;;; cnt
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval value:
;;; ;;; ;;; 2
;;; ;;; ;;; 
;;; ;;; ;;; ;;; L-Eval input:
;;; ;;; ;;; 





; ANd I just wanted to confirm something really quick so I tried this :

;; ;; ;;; L-Eval input:
;; ;; (define w (id 10))
;; ;; 
;; ;; ;;; L-Eval value:
;; ;; ok
;; ;; 
;; ;; ;;; L-Eval input:
;; ;; f
;; ;; 
;; ;; ;;; L-Eval value:
;; ;; 1
;; ;; 
;; ;; ;;; L-Eval input:
;; ;; w
;; ;; 
;; ;; ;;; L-Eval value:
;; ;; 10
;; ;; 
;; ;; ;;; L-Eval input:
;; ;; f
;; ;; 
;; ;; ;;; L-Eval value:
;; ;; 1
;; ;; 
;; ;; ;;; L-Eval input:
;; ;; 

; So, yes, an application in a definition always executes immediately, i'd have
; thought not ...

; Which makes the exercise understandable ...
; The second value of f stays one since w (before being printed) is still a
; thunk , then it gets forced, but you don't go through I'd again so no
; incrementation happening.



; 2020-03-12 20:10 :: zenAndroid ::  All of this makes sense you sleep deprived
; idiot, it all makes perfect sense, you were just too dense.

; The reason why the (id (id 10) executed the body once was that because IT WAS
; A DEFINITION VALUE SO IT GOT PASSED TO THE DEFINITION PROCEDURE, WHICH
; DIRECTLY EVALUATED THE EXPRESSION IT GETS.

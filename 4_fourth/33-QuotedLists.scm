; 2020-03-16 17:48 :: zenAndroid :: Huh, ... should be rather easy no ?

(load "32-LazyLists.scm")

; Exercise 4.33: Ben Bitdiddle tests the lazy list implementation given above
; by evaluating the expression

; (car '(a b c))

; To his surprise, this produces an error. After some thought, he realizes that
; the “lists” obtained by reading in quoted expressions are different from the
; lists manipulated by the new definitions of cons, car, and cdr. Modify the
; evaluator’s treatment of quoted expressions so that quoted lists typed at the
; driver loop will produce true lazy lists. 


; 2020-03-16 18:01 :: zenAndroid :: I think I an beginning to understand whta is going on.
; The evaluation of (quote (1 2 3)) yields (1 2 3) which is a list.

; A list that is conforming to the underlying Lisp's specification of list, IE
; list constructed by the cons that is not the one WE care about.

; At least, I think so ?

; Dunno, will investigate further.

; I'm gonna try redefining the list primitive... so that it uses the procedural
; definitoin of cons, however, the quesition remains ... does this metacircular
; evaluator really *USE* list to build lists or not; well one way to findout I
; suppose


(zeval '(define (list . z)
          (cons (car z) (list (cdr z)))) the-global-environment)

; Oh god I hope it works ...
; Didnt want to complicate my life further by using folds or something
; Also does not help that I do not have fold implemented in the first place

(define (quotation-handler quotation-text)
  (if (pair? quotation-text)
    (cons-construcotr quotation-text)
    quotation-text))

(define (zeval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (quotation-handler exp))
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


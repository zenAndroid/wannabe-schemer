; 2020-03-13 20:09 :: zenAndroid :: Let's go


(load "27-HeckingSideEffects.scm")

; (define (f a (b lazy) c (d lazy-memo))
;   ())

; I think this would entail a change in apply ... my first idea was that i'll
; use something akin to lazy-of-delayed-args or liat-of args or such, so some
; function that'll delay or force the arguments at runtime depending on if the
; argument hhas the lazy tag or not, ... but then I realized that wouldn't work
; cuz at runtime when you get the actual parameters its not like they are
; decorated with the lazy tag or anything so basically, I need some way of
; storing this information elsewhere, and then to be able to retrieve it
; when the function is being applied.


; In other words, when the function is defined, I need some data structure
; that'll hold this information for me so I can know what and when to delay/
; force.

; Just as a real-ise case, we'll get an s-expression of this sort: 
; (f arg1 arg2 arg3 arg4)
; , and when evaluating it we want to apply f to the list of the
; modified eventual arguments 
; '((zeval arg1) (delay-it arg2) (zeval arg3) ; (delay-it arg4)) ...
; (For the first iteration I wont think about the memoization ascpect)


; Let me thonk ...

; This might require me to change how a definition s-expression is handled on
; the evaluator level as well :thonking:

(define f (
(definiton?) 

; 2020-03-13 21:21 :: zenAndroid :: Actually hmm maybe I don't have to touch
; the evaluation step at all ... :thinking:

; Now that I think about it ...
; list of parameters is going to hold the information of whether an argument
; ought to be delayed or not, so I can exploit this and I think the trick will
; take place when I will need to extend the environment ...

; Wait shit no I am confusion I'll think about this tomorrow now I shall read Worm

; 2020-03-13 22:49 :: zenAndroid ::  I lied, I think I figured it out :D ..

; It probably is just modifying the list-of-values


; 2020-03-13 22:52 :: zenAndroid :: Wait hold up waaaaait a minute
; .. Nevermind I'm retarded I keep falling for the same fucking faulty
; assumption I keep reminding myself not to fall for


; 2020-03-13 23:04 :: zenAndroid :: I think I got it now, for realz this time
; thoug ... zenBoi, just rember that when you zeval the operator you get the
; procedure "object" and you can refer to its formal parenaters which will lead
; the way ... hopefully


; 2020-03-14 14:43 :: zenAndroid :: Yo wassup I'm listening to 28 days later
; theme we finna die yEEEeeeEEeEt .. I'm scared help.

; So, lets see what we have here, what I plan to do (and it seems pretty
; reasonable to  me), is: 

; 1. Changing the evaluation clause for application such that list-of-values
;    recieves also the structure of the formal parameters so that it knows
;    which arg to evaluate and which to delay.

; 2. Changing the definition of list-of-values so that it accounts for the
;    change above.

; 3. Making a slight modification to apply in the compound procedure clause,
;    because right now when environment extension takes place we bind the
;    parameters to their values, now that the representation of the args has
;    changed (they now have the 'lazy' or 'lazy-memo' decorator) I will have to
;    change the body of the environment extension thingy, it wont be complicated,
;    only mapping through the formal parameters' old representation and picking
;    out the actual variable names.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  First: application clause editing in zeval implementation  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
        ((application? exp)
         (apply (zeval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))

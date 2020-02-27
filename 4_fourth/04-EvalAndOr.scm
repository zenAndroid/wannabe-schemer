; 2020-02-26 20:29 :: zenAndroid :: Just saw Gerald's lecture (the first half of the lesture), lovely guy. DO YOU HAVE ANY QUESTIONS?

; Exercise 4.4.  Recall the definitions of the special forms and and or from
; chapter 1:
; 
;     and: The expressions are evaluated from left to right. If any expression
;     evaluates to false, false is returned; any remaining expressions are not
;     evaluated. If all the expressions evaluate to true values, the value of
;     the last expression is returned. If there are no expressions then true is
;     returned.
; 
;     or: The expressions are evaluated from left to right. If any expression
;     evaluates to a true value, that value is returned; any remaining
;     expressions are not evaluated. If all expressions evaluate to false, or
;     if there are no expressions, then false is returned. 
; 
; Install and and or as new special forms for the evaluator by defining
; appropriate syntax procedures and evaluation procedures eval-and and eval-or.
; Alternatively, show how to implement and and or as derived expressions.


Alright then, although I wont be able to test the code, I should still be able to make a decent enough approximation of what I should end up with:

So, an and form will be something like this: (and predicate1 predicate2 predicate3 predicate4 predicate5 ... predicaten)
obviously the and? predicate will be

(define (and? exp) (tagged-list? exp 'and))

and by the way I'll shorten the explanation by including the or implementation as well, so ...

(define (or? exp) (tagged-list? exp 'or))


We'll of course have an eval-and/eval-or form. So ...
Note: The first implementation I will do is going to be scheme specific with the ugly cars and cdrs, afterwards i'll G E N E R A L I Z E it.

(define (eval-and exp env)
  (let ((predicates (cdr exp)))                       ; Bind predicates with the rest of the expression [(cdr '(and foo bar)) ==> '(foo bar)]
    (if (null? predicates)                            ; If there are no predicates ...
      #t                                              ; then return true
                                                      ; IF THERE *ARE* PREDICATES ...
      (if (eval (car predicates)) env)                ; then check if the first predicate is true, if that *IS* the case, ... then ...
        (eval-and (cons 'and (cdr predicates)) env)   ; Evaluate the rest of the (and-ed) expression.
        #f))))                                        ; If the first available predicate is NOT true, return false and stop executing.


(define (eval-or exp env)
  (let ((predicates (cdr exp)))                       ; Bind predicates with the rest of the expression [(cdr '(or foo bar)) ==> '(foo bar)]
    (if (null? predicates)                            ; If there are no predicates ...
      #f                                              ; then return false
                                                      ; IF THERE *ARE* PREDICATES ...
      (if (eval (car predicates)) env)                ; then check if the first predicate is true, if that *IS* the case, ... then ...
        #t                                            ; simply return true, there is no need for further processing
        (eval-or (cons 'or (cdr predicates) env)))))) ; Evaluate the rest of the (or-ed) expression.


; Looks like it should be ecorrect to me...
; Now onto implementing abstract selectors

(define (and-predicates exp) (cdr exp))

(define (or-predicates exp) (cdr exp))

(define (first-predicate predicates) (car predicates))

(define (rest-of-predicates predicates) (cdr predicates))

(define (no-predicates? predicates) (null? predicates))

(define (make-and predicates) (list 'and predicates))

(define (make-or predicates) (list 'or predicates))


; Thus, the version of eval-and/eval-or becomes the more verbose but more
; extensible (and also, dare I say, the more readable and self-documenting) (no
; comments this time, and theyre not really needed)

(define (eval-and exp env)
  (let ((predicates (and-predicates exp)))                       
    (if (no-predicates? predicates)                            
      #t                                              
                                                      
      (if (true? (eval (first-predicate predicates) env)))
        (eval-and (make-and (rest-of-predicates predicates)) env)   
        #f))))

(define (eval-or exp env)
  (let ((predicates (or-predicates exp)))                       
    (if (no-predicates? predicates)                            
      #f                                              
                                                      
      (if (true? (eval (first-predicate predicates) env)))
        #t                                            
        (eval-or (make-or (rest-of-predicates predicates)))))))

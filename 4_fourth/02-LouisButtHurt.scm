; 2020-02-26 23:33 :: zenAndroid ::  Oh louis 

; a) Will make it so that sometimes his evaluator will parse '(define x 3) as a
; function application and will attempt to apply the define procedure on '(x
; 3), which doesn't make sense.
; In essence, the problem is that the clause that checks for function
; application is way too vague, because it pretty much just checks to see if
; the expression is a list? or not (or was it a pair?, idk).
; 
; b) To integrate the 'call special form :
; 
; (define (aplication? exp) (tagged-list? 'call))
; (define (operator exp) (cadr exp))
; (define (operands exp) (cddr exp))

; 2020-03-16 17:48 :: zenAndroid :: Huh, ... should be rather easy no ?

; Exercise 4.33: Ben Bitdiddle tests the lazy list implementation given above
; by evaluating the expression

; (car '(a b c))

; To his surprise, this produces an error. After some thought, he realizes that
; the “lists” obtained by reading in quoted expressions are different from the
; lists manipulated by the new definitions of cons, car, and cdr. Modify the
; evaluator’s treatment of quoted expressions so that quoted lists typed at the
; driver loop will produce true lazy lists. 


; 2020-03-16 18:01 :: zenAndroid :: I think I an beginning to understand whta is going on.
The evaluation of (quote (1 2 3)) yields (1 2 3) which is a list.

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



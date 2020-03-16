; 2020-03-16 17:48 :: zenAndroid :: Huh, ... should be rather easy no ?

; Exercise 4.33: Ben Bitdiddle tests the lazy list implementation given above
; by evaluating the expression

; (car '(a b c))

; To his surprise, this produces an error. After some thought, he realizes that
; the “lists” obtained by reading in quoted expressions are different from the
; lists manipulated by the new definitions of cons, car, and cdr. Modify the
; evaluator’s treatment of quoted expressions so that quoted lists typed at the
; driver loop will produce true lazy lists. 

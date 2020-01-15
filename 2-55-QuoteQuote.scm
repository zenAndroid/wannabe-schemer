#lang scheme
(car ''random-symbol)
;This returns `quote` and that's because
;(car ''random-symbol)
;is syntactic sugar (i think?) for
;(car (quote (quote random-symbol)))
;which is equivalent to
;(car '(quote random-symbol))
;'(quote random-symbol) ==> a literal list
;with quote as a 1st element and random-symbol as 2nd element
; so applying car to that yields quote
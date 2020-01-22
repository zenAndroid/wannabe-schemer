#lang scheme
(list 'a 'b 'c)

;1st instinct is that it'll output ('a 'b 'c)
;which is ((quote a) (quote b) (quote c))
;> (list 'a 'b 'c)
;(a b c)
;At first i thought that this was counter intuitive
;as i have been expecting ((quote a) (quote b) (quote c))
;but then i realized that
;(quote a) evaluates to a
;(quote b) evaluates to b
;(quote c) evaluates to c
;so it gets reduced further down to (a b c)
;((quote a) (quote b) (quote c))
;    |         |          |
;    V         V          V
;(   a         b          c    )
;
;This explanation was brought to you by
;the 'i think i may forget how to explain
;this to myself and so im noting it here
;for posterity's sake' gang

(list (list 'george))

;Expectation :
;(list (list 'george))
;            |
;            v
;(list ('george))
;       |
;       v
;((george))
; Result was as expected, nice!


(cdr '((x1 x2) (y1 y2)))
; ==> ((y1 y2))
; nice!

(cadr '((x1 x2) (y1 y2)))
; Output is (y1 y2) as expected


(pair? (car '(a short list)))

; False?
; Yup !
; For curiosity's sake

(car '(a short list)) ;==> a

(memq 'red '((red shoes) (blue socks)))

; pretty sure it'll output #f

(memq 'red '(red shoes blue socks))

; pretty sure it'll output #t

; Oh lol i actually forgot that when it *does*
; find an item that's equal it ouputs the **rest**
; of the list from that point onward.


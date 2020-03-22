; 2020-03-22 15:33 :: zenAndroid :: 38 exercises later (pun intended)

; Exercise 4.38: Modify the multiple-dwelling procedure to omit the requirement
; that Smith and Fletcher do not live on adjacent floors. How many solutions
; are there to this modified puzzle?

(load "00-AmbEval.scm")

; One annoying thing I'm facing with the ambiguious evaluator is that I can't
; do something like (ambeval '(S-EXPRESSION ...) the-global-environment), I
; will see if I can gather something from Eli or something.
; And if it doesn't work out then I guess it's not that big a loss ... *would*
; be nice if I could do it though

; Oof, by the way you need require and distinct?


; WARNING TO ALL THOSE WHO ARE READING; this file is NOT for being loaded by
; guile as is, the ONLY line of code that gets read by GUILE/RACKET/what have
; you is the LOAD line, all the other lines are not for the guile/underlying
; scheme's evaluator, but for the AMG evaluator.  Caveat Emptor.

; BLESS VIM-SLIME (altho you can paste stuff from a window to a terminal fine
; using just built-in vim tbh)


(define (require p)
  (if (not p)
    (amb)))

(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require (distinct? (list baker cooper fletcher miller smith)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (require (> miller cooper))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))

(multiple-dwelling)

try-again


; Yeah it has a bunch other solutions ...

; 2020-02-22 21:37 :: zenAndroid ::  Lets do this, hopefully I can do it, cuz
; the last exercises dealt a huge blow to my self-confidence,

(load "69-Nice.scm")

(define (integral integrand initial-value dt)
  (define int
    (stream-cons initial-value
                 (add-streams (scale-stream integrand dt)
                              int)))
  int)

(define (RC R C dt)
  (lambda(current-stream initial-value)
    (add-streams
      (scale-stream current-stream R)
      (integral 
        (scale-stream current-stream (/ 1.0 C))
        initial-value 
        dt))))

; Hopefully this is it!

; HOOOOOOOOOOOOOOOOO

; Heere's a tip when reading signal-flow diagrams, read the diagrams from the ending to the beginning.
; 
; For instance (taking the diagram of this exercise as an example):
; 
; Read form the last
; What is the last "Combinator"? --> ADD
; What aare it arguments?
; 1. The "Scaling by R" of the input stream.
; 2. The integral of the "scaling by 1/C" of the input stream, whose initial value is V_0
; 
; SO
; 
; ADD 
;     SCALE INPUT-STREAM R
;     INTEGRATE (SCALE INPUT-STREAM 1/C) v0 dt      (the dt and R come as arguments
; 
; This should help you I hope.
; 

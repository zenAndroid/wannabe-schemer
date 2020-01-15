#lang scheme

(define (make-from-mag-angle x y)
  (define (dispatch op)
    (cond ((eq? op 'real-part) (* (cos y) x))
          ((eq? op 'imag-part) (* (sin y) x))
          ((eq? op 'magnitude) x)
          ((eq? op 'angle) y)
          (else 
            (error
              "Something ain't working right with this operator, senpai" op))))
  dispatch)

; real part, given the magnitude and angle is equql to .. 
; i actually forget but lemme think nout it for a sec
; its r*cosine(A)
; and for the imaginary part its r*sine(A)


(define polar-complex
        (make-from-mag-angle 5 (/ pi 4)))

(polar-complex 'real-part)
(polar-complex 'imag-part)
(polar-complex 'magnitude)
(polar-complex 'angle)

; Works as expected, good!

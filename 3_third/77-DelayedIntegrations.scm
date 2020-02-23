; 2020-02-23 10:30 :: zenAndroid :: Hmmmm :thonk:

(load "65-Ln2.scm") 

; Did not Include te previous ones, cince I forget whether
;; or not useful things are defined in them


; (define (solve f y0 dt)
;   (define y (integral dy y0 dt))
;   (define dy (stream-map f y))
;   y)

; So, just a note to myself here, because I know my first intuition was to wonder why the let form was not used.
; Say you tried to write let in there.
; It wont work, because the first let will be defining y to be the integral of dy etc ..., except dy isnt exactly defined so
; And you cant write it the othe way because they are dependent on each other

; What is truly puzzling to me is why this way of defining it wouldnt work 
; 
; ... Went and investigated for a bit, dunno if what I found was correct or
; not, but it seems to make sense.  Will need to ask again to make sure I'm not
; shooting my own foot withh bw=ad misconceptions.

; Scratch all of this I just understiid why.  It is because of applicative
; order; the arguments need to be evaluated right when they are written, as
; opposed to normal order evaluation which I think is like lazy evaluation.

; (define (integral delayed-integrand initial-value dt)
;   (define int
;     (stream-cons initial-value
;                  (let ((integrand (force delayed-integrand)))
;                    (add-streams (scale-stream integrand dt)
;                                 int))))
;   int)

(define (integral delayed-integrand initial-value dt)
  (define int
    (stream-cons initial-value
                 (let ((integrand (force delayed-integrand)))
                   (add-streams (scale-stream integrand dt)
                                int))))
  int)


(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

(define E (solve (lambda(y) y) 1 0.001))

; The smaller the timestep the more items I have to traverse in the stream to
; get to a decent approximation of e, wonder why.

; future zenAndroid here: Nope I was being silly, if you go with a timestep of
; 0.001 then you need to reference the 1000th element of the output stream to
; get the exponential function evaluated at 1, because 0.001*1000 = 1.
; Understand that the output stream is a *function*, just represented as a
; stream, and each element is one timestep away from the previous one, nad this
; prompts me to try smaller and smaller timesteps and accessing the
; appropriiate output stream to try and approximate e better, and compare
; between timesteps.

; > (define E (solve (lambda(y) y) 1 0.1))
; > (stream-ref E 10)
; 2.5937424601
; > (define E (solve (lambda(y) y) 1 0.01))
; > (stream-ref E 100)
; 2.704813829421526
; > (define E (solve (lambda(y) y) 1 0.001))
; > (stream-ref E 1000)
; 2.716923932235896
; > (define E (solve (lambda(y) y) 1 0.0001))
; > (stream-ref E 10000)
; 2.7181459268252266
; > (define E (solve (lambda(y) y) 1 0.00001))
; > (stream-ref E 100000)
; 2.7182682371744953
; > (define E (solve (lambda(y) y) 1 0.0000001))
; > (stream-ref E 10000000)
; 2.7182816925440676
; NEAT


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  Another defintion for integral coming right up  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; (define (integral integrand initial-value dt)
;   (cons-stream
;     initial-value
;     (if (stream-null? integrand)
;       the-empty-stream
;       (integral
;         (stream-cdr integrand)
;         (+ (* dt (stream-car integrand))
;            initial-value)
;         dt))))

; This aint gunna work since it has the same issue
; Should be the exact same thing ? I don't understand ...

; (define (integral delayed-integrand initial-value dt)
;   (stream-cons initial-value
;                (let ((integrand (force delayed-integrand)))
;                  (if (stream-empty? integrand)
;                    the-empty-stream
;                    (integral
;                      (stream-rest integrand)
;                      (+ (* dt (stream-first integrand))
;                         initial-value)
;                      dt)))))

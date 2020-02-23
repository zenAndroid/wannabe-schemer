; 2020-02-23 12:45 :: zenAndroid :: Less go less go less go we finna finish CHAPRTE 3 TODAY LESS GO

(load "77-DelayedIntegrations.scm")

(define (integral delayed-integrand initial-value dt)
  (define int
    (stream-cons initial-value
                 (let ((integrand (force delayed-integrand)))
                   (add-streams (scale-stream integrand dt)
                                int))))
  int)

(define (solve-2nd a b dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (add-streams
                (scale-stream dy a)
                (scale-stream y b)))
  y)


; Does this work ... 

; well, it *should* ...`

; The solutions concord with this so I imagine it works .... *suspicious eyes*
; since I know that is not really that strong an argument

(stream-ref (solve-2nd 1 0 0.0001 1 1) 10000)  ; e

(stream-ref (solve-2nd 0 -1 0.0001 1 0) 10472)  ; cos pi/3 = 0.5
(stream-ref (solve-2nd 0 -1 0.0001 0 1) 5236)  ; sin pi/6 = 0.5



; YEP
; YEET

; 2020-02-22 11:30 :: zenAndroid ::  This sequence acceleration things is really interegsting

(load "63-SeqAccel.scm")

(define (ln-2-summands n)
  (stream-cons (/ 1.0 n)
               (stream-map - (ln-2-summands (+ n 1)))))

(define lns-stream (partial-sums (ln-2-summands 1)))


(define accel-ln (euler-transform lns-stream))

(define rec-accel-ln 
  (accelerated-sequence euler-transform lns-stream))

; (stream->list (stream-take rec-accel-ln 15))

; > (stream->list (stream-take rec-accel-ln 15))
; '(1.0
;   0.7
;   0.6932773109243697
;   0.6931488693329254
;   0.6931471960735491
;   0.6931471806635636
;   0.6931471805604039
;   0.6931471805599445
;   0.6931471805599427
;   0.6931471805599454
;   +nan.0
;   +nan.0
;   +nan.0
;   +nan.0
;   +nan.0)
; > ^D

; Weird, I dunno why but anything after the tenth iteration s NotANumber.

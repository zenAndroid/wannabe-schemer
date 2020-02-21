; 2020-02-20 18:01 :: zenAndroid ::  Yeet
(load "58-EXPAND.scm")

(define (div-streams s1 s2)
  (zen-stream-map (lambda(x y) (/ (exact->inexact x) y)) s1 s2))

; Welcome to Racket v7.5.
;   (load "58-EXPAND.scm")
; '(1 4 2 8 5 7 1 4 2 8)
; > (define (div-streams s1 s2)
;     (zen-stream-map (lambda(x y) (/ (exact->inexact x) y)) s1 s2))
; > (define temp (div-streams integers integers))
; > (sample temp)
; '(1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0)
;
; Seems to work nicely ... nice!

(define (integrate-series s)
  (div-streams s integers))

(define test-stream (stream 2 16 9 4))

; (stream->list (integrate-series test-stream))

; > (define test-stream (stream 2 16 9 4))
; > (stream->list (integrate-series test-stream))
; '(2.0 8.0 3.0 1.0)

; Integration seems to work nicely

(define exp-series
  (stream-cons 1 (integrate-series exp-series)))

(define sine-series
  (stream-cons 0 (integrate-series cosine-series)))

(define cosine-series
  (stream-cons 1 (stream-map - (integrate-series sine-series))))


; I will be overjoyed if this turns out to be correct

; Hell yeah !!

; 2020-02-20 22:39 :: zenAndroid ::  I guess I'm kind of proud that I stuck
; around and tried my best to solve this, but in the end I couldn't come up
; with the right solution, I *almost* did though, in the end I didnt want to
; stick around too much and saw the online solution :(
;
; This is the solution
;
; (define (mul-series s1 s2)
;   (strem-cons 
;     (* (stream-first s1) (stream-first s2))
;     (add-streams 
;       (scale-stream (stream-rest s2) (stream-first s1))
;       (mul-series (stream-rest s1) s2))))

; And this is what I came up with
; 
; (define (mul-series s1 s2)
;   (strem-cons 
;     (* (stream-first s1) (stream-first s2))
;     (add-streams 
;       (scale-stream s2 (stream-first s1))
;       (mul-series (stream-rest s1) s2))))
; 
; SO CLOSE


; STILL DONT UNDERSTAND WHY THAT IS NEEDED
; FRUSTRATED AAAAAAAAAAAAAAAAAAAAAAAAAA

(load "59-SpookyStreams.scm")

(define (mul-series s1 s2)
  (stream-cons 
    (* (stream-first s1) (stream-first s2))
    (add-streams 
      (scale-stream (stream-rest s2) (stream-first s1))
      (mul-series (stream-rest s1) s2))))

(define foo
  (add-streams
    (mul-series sine-series sine-series)
    (mul-series cosine-series cosine-series)))

; > (define foo
;     (add-streams
;       (mul-series sine-series sine-series)
;       (mul-series cosine-series cosine-series)))
; > (sample foo)
; '(1 -0.0 0.0 0.0 5.551115123125783e-17 0.0 -6.938893903907228e-18 0.0 0.0 0.0)

; Good enough I guess ...

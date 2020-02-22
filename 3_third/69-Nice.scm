; 2020-02-22 17:20 :: zenAndroid ::  Nice

(load "66-ConfusedMeatFirst.scm")
(load "66-ConfusedMeatFirst.scm")

; I am a fraud 


(define (triplets s1 s2 s3)
  (stream-cons
    (list (stream-first s1)
          (stream-first s2)
          (stream-first s3))
    (interleave
      (stream-map
        (lambda(x) (append (list (stream-first s1)) x))
        (stream-rest (pairs s2 s3)))
      (triplets
        (stream-rest s1)
        (stream-rest s2)
        (stream-rest s3)))))

(define ttt (triplets integers integers integers))

(stream->list (stream-take ttt 34))

(define pyth
  (stream-filter
    (lambda(triplet)
      (=
        (sqr (caddr triplet))
        (+
          (sqr (car triplet))
          (sqr (cadr triplet)))))
  ttt))

(stream->list (stream-take pyth 34))

; Works as intended !

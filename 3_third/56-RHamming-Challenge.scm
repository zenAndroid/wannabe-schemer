; 2020-02-19 22:18 :: zenAndroid ::  This seems a bit easy ...

(load "55-PartialSums.scm")

(define (merge s1 s2)
  (cond ((stream-empty? s1) s2)
        ((stream-empty? s2) s1)
        (else
          (let ((s1car (stream-first s1))
                (s2car (stream-first s2)))
            (cond ((< s1car s2car)
                   (stream-cons
                     s1car
                     (merge (stream-rest s1)
                            s2)))
                  ((> s1car s2car)
                   (stream-cons
                     s2car
                     (merge s1
                            (stream-rest s2))))
                  (else
                    (stream-cons
                      s1car
                      (merge
                        (stream-rest s1)
                        (stream-rest s2)))))))))

(define S (stream-cons 1 (merge (scale-stream S 2) (merge (scale-stream S 3) (scale-stream S 5)))))

; > (sample S)
; '(1 2 3 4 5 6 8 9 10 12)
; > (stream->list (stream-ta
; stream-tail  stream-take 
; > (stream->list (stream-take S 30))
; '(1 2 3 4 5 6 8 9 10 12 15 16 18 20 24 25 27 30 32 36 40 45 48 50 54 60 64 72
;   75 80)
; > (stream->list (stream-take S 20))
; '(1 2 3 4 5 6 8 9 10 12 15 16 18 20 24 25 27 30 32 36)
; > ^D

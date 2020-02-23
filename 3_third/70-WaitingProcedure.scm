;  2020-02-22 19:41 :: zenAndroid :: SIGH

(load "66-ConfusedMeatFirst.scm")


(define (weighted-merge s1 s2 weight)
  (cond ((stream-empty? s1) s2)
        ((stream-empty? s2) s1)
        (else
          (let ((s1car (stream-first s1))
                (s2car (stream-first s2)))
            (let ((first-weight (weight s1car))
                  (second-weight (weight s2car)))
              (cond ((< first-weight second-weight)
                     (stream-cons
                       first-weight
                       (weighted-merge (stream-rest s1)
                              s2)))
                    ((> first-weight second-weight)
                     (stream-cons
                       s2car
                       (weighted-merge s1
                              (stream-rest s2))))
                    (else
                      (stream-cons
                        s1car
                        (weighted-merge
                          (stream-rest s1)
                          (stream-rest s2))))))))))
; (define (pairs s t)
;   (stream-cons
;    (list (stream-first s) (stream-first t))
;    (interleave
;     (stream-map (lambda (x) (list (stream-first s) x))
;                 (stream-rest t))
;     (pairs (stream-rest s) (stream-rest t)))))

(define (weighted-pairs 1st-stream 2nd-stream weight)
  (let ((unordered-pairs (pairs 1st-stream 2nd-stream)))
    (stream-cons \\


;; I HAVE DECIDE TO STOP DOING THESE FOR NOW AND WILL ATTEMPT TO COME BACK TO THEM LATER

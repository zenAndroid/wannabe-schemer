; (define (estimate-pi trials)
;   (sqrt (/ 6 (monte-carlo trials 
;                           cesaro-test))))
; (define (cesaro-test)
;    (= (gcd (rand) (rand)) 1))
; 
; (define (monte-carlo trials experiment)
;   (define (iter trials-remaining trials-passed)
;     (cond ((= trials-remaining 0)
;            (/ trials-passed trials))
;           ((experiment)
;            (iter (- trials-remaining 1) 
;                  (+ trials-passed 1)))
;           (else
;            (iter (- trials-remaining 1) 
;                  trials-passed))))
;   (iter trials 0))

(require sicp) ; Because racket's random does not accept decimals ... go figure 

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (estimate-integral predicate x1 x2 y1 y2 trials)
  (define (integral-test p)
    (p (random-in-range x1 x2) (random-in-range y1 y2)))
  (define inner-predicate (lambda () (integral-test predicate)))
  (define (dist x y) (abs (- x y)))
  (* (* (dist x2 x1) (dist y2 y1))
     (monte-carlo trials
                  inner-predicate)))


(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) 
                 (+ trials-passed 1)))
          (else
            (iter (- trials-remaining 1) 
                  trials-passed))))
  (iter trials 0))


; Note to self: The monte carlo function body is pretty much constant,
; the only things that change are the experiments, and that is outside the body
; and passed as an argument either way

(define predicate-for-test
  (lambda (x y) 
    (<= (+ (sqr x) (sqr y)) 1)))

(define (the-test num) 
  (estimate-integral predicate-for-test 1.0 -1.0 -1.0 1.0 num))


; > (the-test 30)
; 2.933333333333333
; > (the-test 300)
; 3.2533333333333334
; > (the-test 3000)
; 3.148
; > (the-test 30000)
; 3.1448
; > (the-test 300000)
; 3.1452533333333332
; > (the-test 3000000)
; 
; 3.1416186666666666
; > 
;   (the-test 30000000)
; 3.141206133333333
; > (the-test (/30000000 2))
; ; /30000000: undefined;
; ;  cannot reference an identifier before its definition
; ;   in module: top-level
; ; [,bt for context]
; > (the-test (/ 30000000 2))
; 3.141039466666667
; > ^D

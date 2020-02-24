; 2020-02-23 21:18 :: zenAndroid ::  AAAAaaAAaAAA

(load "81-RandomStream.scm")

(require sicp)

(define (rand-update x) 
   (modulo (+ 101 (* x 713)) 53))

(define random-init 234234) ; Some random number

(define random-numbers
  (stream-cons random-init
               (stream-map rand-update random-numbers)))

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (stream-cons
      (/ passed (+ passed failed))
      (monte-carlo
        (stream-rest experiment-stream) passed failed)))
  (if (stream-first experiment-stream)
    (next (+ passed 1) failed)
    (next passed (+ failed 1))))

(define predicate-for-test
  (lambda (x y) 
    (<= (+ (sqr x) (sqr y)) 1)))

(define (estimate-integral predicate x1 x2 y1 y2)
  (let ((n1 (random-in-range x1 x2))
        (n2 (random-in-range y1 y2))
        (area (* (- x2 x1) (- y2 y1))))
    (scale-stream (stream-cons
                    (predicate n1 n2)
                    (estimate-integral predicate x1 x2 y1 y2)) area)))

; ... fuck it

(define please
  (monte-carlo (estimate-integral
                 predicate-for-test
                 -1.0 1.0 -1.0 1.0) 0 0))

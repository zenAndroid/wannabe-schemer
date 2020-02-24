; 2020-02-23 19:02 :: zenAndroid ::  AAaaAAAAAaaA please make it so I know how
; to do these exercises

(load "79-Generalize.scm")

(define (rand-update x) 
   (modulo (+ 101 (* x 713)) 53))

(define random-init 234234) ; Some random number

(define random-numbers
  (stream-cons random-init
               (stream-map rand-update random-numbers)))


(define (map-successive-pairs f s)
  (stream-cons
    (f (stream-first s)
       (stream-first (stream-rest s)))
    (map-successive-pairs
      f (stream-rest (stream-rest s)))))

(define cesaro-stream
  (map-successive-pairs
    (lambda (r1 r2) (= (gcd r1 r2) 1))
    random-numbers))


(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (stream-cons
      (/ passed (+ passed failed))
      (monte-carlo
        (stream-rest experiment-stream) passed failed)))
  (if (stream-first experiment-stream)
    (next (+ passed 1) failed)
    (next passed (+ failed 1))))


(define pi
  (stream-map
    (lambda (p) (sqrt (/ 6 p)))
    (monte-carlo cesaro-stream 0 0)))

; Saw the solution because I found the verbiage confusing and because I didnt
; focus on it too much since I am too excite, but I didnt look at the solution
; too much, so I think I might be able to come up with the solution on my own
; again ?



(define (req-stream input-request-stream) ; It takes an input-request-stream that contains the requests
  (define (react random-stream-element request)
    (cond ((eq? request 'gen) (rand-update random-stream-element))
          ((and (pair? request) (eq? (car request) 'reset))
           (cadr request))
          (else 
            (error "ERROR IN REQ-STREAM -- " 
                   (list random-stream-element request)))))
  (define retval
    (stream-cons random-init
                 (zen-stream-map react retval input-request-stream)))
  retval)


; (define request-example-stream
;   (stream 'gen 'gen 'gen 'gen 'gen 'gen '(reset 54) 'gen 'gen 'gen 'gen 'gen 'gen '(reset 54) 'gen 'gen '(reset 9) 'gen 'gen 'gen))

(define request-example-stream
  (stream-cons 
    'gen 
    (stream-cons 
      'gen 
      (stream-cons 
        '(reset 34) 
        (stream-cons 
          'gen 
          (stream-cons 
            'gen 
            (stream-cons '(reset 187)
                         request-example-stream)))))))
        


(stream->list (stream-take (req-stream request-example-stream) 25))

; > (stream->list (stream-take (req-stream request-example-stream) 25))
; '(234234 7 4 34 16 8 187 31 50 34 16 8 187 31 50 34 16 8 187 31 50 34 16 8 187)

; It WORKS, YEEET

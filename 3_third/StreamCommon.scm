
(define (zen-stream-map proc . argstreams)
  (if (stream-empty? (car argstreams))
      empty-stream
      (stream-cons
       (apply proc (map stream-first argstreams))
       (apply zen-stream-map
	      (cons proc (map stream-rest argstreams))))))

; Taking the code from the book, and rewriting it for racket

(define (integers-starting-from n)
  (stream-cons n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

(define (divisible? x y) (= (remainder x y) 0))

(define no-sevens
  (stream-filter (lambda (x) (not (divisible? x 7)))
                 integers))

;: (stream-ref no-sevens 100)

(define (fibgen a b)
  (stream-cons a (fibgen b (+ a b))))

(define fibs (fibgen 0 1))

(define (sieve stream)
  (stream-cons
   (stream-first stream)
   (sieve (stream-filter
           (lambda (x)
             (not (divisible? x (stream-first stream))))
           (stream-rest stream)))))

(define primes (sieve (integers-starting-from 2)))

;: (stream-ref primes 50)


;;;Defining streams implicitly;;;Defining streams implicitly

(define ones (stream-cons 1 ones))

(define (add-streams s1 s2)
  (zen-stream-map + s1 s2))

(define integers (stream-cons 1 (add-streams ones integers)))

(define fibs
  (stream-cons 0
               (stream-cons 1
                            (add-streams (stream-rest fibs)
                                         fibs))))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

(define double (stream-cons 1 (scale-stream double 2)))

(define primes
  (stream-cons
   2
   (stream-filter prime? (integers-starting-from 3))))

(define (prime? n)
  (define (iter ps)
    (cond ((> (sqr (stream-first ps)) n) true)
          ((divisible? n (stream-first ps)) false)
          (else (iter (stream-rest ps)))))
  (iter primes))



; 2020-02-23 15:36 :: zenAndroid ::  Let's see ...

(load "79-Generalize.scm")


(define (RLC R L C dt)
  (lambda(V_c0 I_l0)
    (define v_C
      (integral
        (delay (scale-stream i_L (/ -1.0 C)))
        I_l0
        dt))
    (define i_L
      (integral
        (delay (add-streams
                 (scale-stream i_L (/ (- R) L))
                 (scale-stream v_C (/ 1.0 L))))
        V_c0
        dt))
    (cons v_C i_L)))


; This should be it.

; Let's generate what they ask for.

(define exo3.80 ((RLC 1 0.2 1 0.1) 10 0))

(define dootcar (stream->list (stream-take (car exo3.80) 30)))
(define dootcdr (stream->list (stream-take (cdr exo3.80) 30)))

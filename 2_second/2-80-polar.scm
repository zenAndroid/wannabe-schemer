(define (install-polar-package op-table)
  ;; internal procedures

  (define (square x) (* x x))

  (define (magnitude z) (car z))

  (define (angle z) (cdr z))

  (define (make-from-mag-ang r a) (cons r a))

  (define (real-part z)
    (* (magnitude z) (cos (angle z))))

  (define (imag-part z)
    (* (magnitude z) (sin (angle z))))

  (define (make-from-real-imag x y)
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))

  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))

  (define first-op 
    (put op-table 'real-part '(polar) real-part))
  
  (define second-op 
    (put first-op 'imag-part '(polar) imag-part))

  (define third-op 
    (put second-op 'magnitude '(polar) magnitude))

  (define fourth-op 
    (put third-op 'angle '(polar) angle))

  (define fifth-op 
    (put fourth-op 'make-from-real-imag 'polar
       (lambda (x y)
         (tag (make-from-real-imag x y)))))

  (define sixth-op 
    (put fifth-op 'make-from-mag-ang 'polar
       (lambda (r a)
         (tag (make-from-mag-ang r a)))))

  sixth-op)

(define (make-from-mag-ang r a)
  ((get MAIN-TABLE 'make-from-mag-ang 'polar) r a))

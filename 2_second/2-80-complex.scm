(define (install-complex-package op-table)
  (define (make-real-imag x y)
    ((get op-table 'make-from-real-imag 'rectangular)
     x y))
  (define (make-from-mag-ang r a)
    ((get op-table 'make-from-mag-ang 'polar)
     r a))
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag
     (+ (real-part z1) (real-part z2))
     (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag
     (- (real-part z1) (real-part z2))
     (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang
     (* (magnitude z1) (magnitude z2))
     (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang
     (/ (magnitude z1) (magnitude z2))
     (- (angle z1) (angle z2))))
  ;; Iterfacing zith the system now
  (define (tag x) (attach-tag 'complex x))

  (define first-op
    (put op-table 'add '(complex complex)
         (lambda (x y) (tag (add-complex x y)))))
  (define second-op
    (put first-op 'sub '(complex complex)
         (lambda (x y) (tag (sub-complex x y)))))
  (define third-op
    (put second-op'mul '(complex complex)
         (lambda (x y) (tag (mul-complex x y)))))
  (define fourth-op
    (put third-op 'div '(complex complex)
         (lambda (x y) (tag (div-complex x y)))))
  (define fifth-op
    (put fourth-op 'make-from-real-imag 'complex
         (lambda(x y) (tag (make-from-real-imag x y)))))
  (define sixth-op
    (put fifth-op 'make-from-mag-ang 'complex
         (lambda(x y) (tag (make-from-mag-ang x y)))))
  (define seven-op
    (put sixth-op 'real-part '(complex) real-part))
  (define eight-op
    (put seven-op 'imag-part '(complex) imag-part))
  (define nineth-op 
    (put eight-op 'magnitude '(complex) magnitude))
  (define tenth-op
    (put nineth-op 'angle '(complex) angle))
  (define eleventh-op
    (put tenth-op 'equ? '(complex complex) 
         (lambda(x y) 
           (and (= (real-part x) (real-part y)) 
                (= (imag-part x) (imag-part y))))))
  (define twelfth-op 
    (put eleventh-op '=zero? '(complex)
         (lambda(z) (and (= (real-part z) 
                            (imag-part z)
                            0)))))

twelfth-op)

(define (make-complex-from-real-imag x y) 
  ((get MAIN-TABLE 'make-from-real-imag 'complex) x y))

(define (make-complex-from-mag-ang r a)
  ((get MAIN-TABLE 'make-from-mag-ang 'complex) r a))

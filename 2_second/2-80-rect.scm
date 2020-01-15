(define (install-rectangular-package op-table) ; op-table is the table that shall be passe in
  ;; internal procedures, we wont touch these because they are internal

  (define (square x) (* x x))

  (define (real-part z) (car z))

  (define (imag-part z) (cdr z))

  (define (make-from-real-imag x y) (cons x y))

  (define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))

  (define (angle z)
    (atan (imag-part z) (real-part z)))

  (define (make-from-mag-ang r a)
    (cons (* r (cos a)) (* r (sin a))))

  ;; interface to the rest of the system

  (define (tag x) (attach-tag 'rectangular x))

  ; (put 'real-part '(rectangular) real-part) 
  ; becomes
  ; (put op-table 'real-part '(rectangular) real-part)
  ; Same thing for the other ones
  ; 
  ; /!\
  ;
  ; The above is a mistake, no side-effetcs remember?
  ; So after a put call, op-table goes back to pointing
  ; to the argument op-table.
  ; so i have to define a temporary variable to hold onto
  ; the result.
  ; Pretty ironic that i fell for the same problem
  ; i set out to solve.
  ; # 2020-01-11 17:27 :: zenAndroid Modification For some reason racket
  ; interpreter complained when i did something like `redefine a symbol`
  ; complaining about duplicate binding names
  ; so the variables are all temporary
  ; so the result goes flowing down like 
  ; a relay course


  (define first-op
    (put op-table 'real-part '(rectangular) real-part))

  (define second-op 
    (put first-op 'imag-part '(rectangular) imag-part))

  (define third-op 
    (put second-op 'magnitude '(rectangular) magnitude))

  (define fourth-op 
    (put third-op 'angle '(rectangular) angle))

  (define fifth-op 
    (put fourth-op 'make-from-real-imag 'rectangular
       (lambda (x y)
         (tag (make-from-real-imag x y)))))

  (define sixth-op
    (put fifth-op 'make-from-mag-ang 'rectangular
       (lambda (r a)
         (tag (make-from-mag-ang r a)))))

  sixth-op)


(define (make-from-real-imag x y)
  ((get MAIN-TABLE 'make-from-real-imag 'rectangular) x y))

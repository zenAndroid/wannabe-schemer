(define (install-scheme-number-package op-table)

  (define (tag x) (attach-tag 'scheme-number x))
  
  (define first-op
    (put op-table 'add '(scheme-number scheme-number)
         (lambda (x y) (tag (+ x y)))))

  (define second-op
    (put first-op 'sub '(scheme-number scheme-number)
         (lambda (x y) (tag (- x y)))))

  (define third-op
    (put second-op'mul '(scheme-number scheme-number)
         (lambda (x y) (tag (* x y)))))

  (define fourth-op
    (put third-op 'div '(scheme-number scheme-number)
         (lambda (x y) (tag (/ x y)))))

  (define fifth-op
    (put fourth-op 'make 'scheme-number
         (lambda(x) (tag x)))) 
  (define sixth-op 
    (put fifth-op 'equ? '(scheme-number scheme-number) =))

  (define seventh-op 
    (put sixth-op '=zero? '(scheme-number)
         (lambda(x) (= 0 x))))

  (define eight-op
    (put seventh-op 'negate '(scheme-number) -))

  eight-op)

(define (make-scheme-number n)
  ((get MAIN-TABLE 'make 'scheme-number) n))

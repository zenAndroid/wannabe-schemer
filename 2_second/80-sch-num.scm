(define (install-scheme-number-package op-table)

  (define (tag x) (attach-tag 'scheme-number x))

  (define (scheme-number-gcd a b)
    (if (= b 0)
      (abs a)
      (scheme-number-gcd b (remainder a b))))
  
  (define (reduce-integers n d)
    (list (/ n (gcd n d)) (/ d (gcd n d))))

  
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

  (define ninth-op
    (put eight-op 'gcd '(scheme-number scheme-number)
         scheme-number-gcd))

  (define tenth-op
    (put ninth-op 'reduce '(scheme-number scheme-number)
         reduce-integers))

  tenth-op)

(define (make-scheme-number n)
  ((get MAIN-TABLE 'make 'scheme-number) n))

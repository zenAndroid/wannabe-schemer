(define (install-rational-package op-table)
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d) (cons (/ n (gcd n d)) (/ d (gcd n d)))) 
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x))) 
              (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))
  ;; Iterfacing zith the system now
  (define (tag x) (attach-tag 'rational x))

  (define first-op
    (put op-table 'add '(rational rational)
         (lambda (x y) (tag (add-rat x y)))))
  (define second-op
    (put first-op 'sub '(rational rational)
         (lambda (x y) (tag (sub-rat x y)))))
  (define third-op
    (put second-op'mul '(rational rational)
         (lambda (x y) (tag (mul-rat x y)))))
  (define fourth-op
    (put third-op 'div '(rational rational)
         (lambda (x y) (tag (div-rat x y)))))
  (define fifth-op
    (put fourth-op 'make 'rational
         (lambda(n d) (tag (make-rat n d)))))
  ; 2020-01-13 16:04 :: zenAndroid Modification Adding numerator and donominator functions
  (define sixth-op
    (put fifth-op 'numer 'rational (lambda(x) (car (contents x)))))
  (define seventh-op
    (put sixth-op 'denom 'rational (lambda(x) (cdr (contents x)))))

  seventh-op)


(define (numer x)
  ((get MAIN-TABLE 'numer 'rational) x))

(define (denom x)
  ((get MAIN-TABLE 'denom 'rational) x))

(define (make-rat n d)
  ((get MAIN-TABLE 'make 'rational) n d))

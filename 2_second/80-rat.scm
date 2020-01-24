(require racket/trace)

(define (install-rational-package op-table)

  (define (numer x) (car x))

  (define (denom x) (cadr x))

  ; (define (make-rat n d) (cons 
  ;                          (let ((reduced-n-d (reduce n d)))
  ;                            (div n (custom-gcd (car reduced-n-d) (cadr reduced-n-d)))
  ;                            (div d (custom-gcd (car reduced-n-d) (cadr reduced-n-d)))))) 
   (define (make-rat n d) (list 
                              (div n (custom-gcd n d))
                              (div d (custom-gcd n d))))

  (define (add-rat x y)
    (make-rat (add (mul (numer x) (denom y))
                   (mul (numer y) (denom x))) 
              (mul (denom x) (denom y))))

  (define (sub-rat x y)
    (make-rat (sub (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))

  (define (mul-rat x y)
    (make-rat (mul (numer x) (numer y))
              (mul (denom x) (denom y))))

  (define (div-rat x y)
    (make-rat (mul (numer x) (denom y))
              (mul (denom x) (numer y))))

  ;; Interfacing with the system now

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

  (define sixth-op 
    (put fifth-op 'equ? '(rational rational)
         (lambda(x y) 
           (= (* (numer x) (denom y))
              (* (denom x) (numer y))))))

  (define seventh-op 
    (put sixth-op '=zero? '(rational)
         (lambda(rat) (= (numer rat) 0))))

  (define eighth-op
    (put seventh-op 'negate '(rational)
         (lambda(pq) (tag (make-rat (- (numer pq))  (denom pq))))))

  ; 2020-01-24 00:16 :: zenAndroid Hmmm ... just as i close this chapter im struck with 
  ; this realization that this a handy shortcut better than that god-awful nth-op nonsense
  ; 
  ; Still not ideal, but light years better, if you want to add a new op all you have to do is add
  ; a line at the beginning and one at the end.
  ;
  ; My brain does not like me very much ... :thinking:
  ; 
  ; (define foo
  ;   (put
  ;     (put
  ;       (put
  ;         (put MAIN-TABLE 'foo 'bar +)
  ;         'bar 'foo -)
  ;       'fii 'bor *))
  ;   'faa 'quux /)

  eighth-op)

(define (make-rat n d)
  ((get MAIN-TABLE 'make 'rational) n d))

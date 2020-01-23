(require racket/include)

(require racket/trace)

(include "81GenericApply-generic.scm")

;; 2020-01-15 20:31 :: zenAndroid
;; I am being intentionnally verbose.
;; The code honestly seems self-documenting, however maybe i'll change opinion
;; if i get back to this code some time in the future :thinking:


;; Either way, the best way *I* understood this was by taking apen and paper
;; and going through the process manually.

;; Let's see what I need now:
;; order, coeff        ==> for the term
;; make-term           ==> for the term
;; empty-term-list?
;; the-empty-term-list

;; Already implemented:
;; make-poly                 ==> for the polynomial
;; variable, term-list       ==> for the polynomial
;; same-variable?, variable? ==> for controlling the polynomial variables
;; first-term                ==> selects the first term out of a list of terms

(define (install-polynomial-package op-table)

  (define (tag x) (attach-tag 'polynomial x))

  (define (make-poly variable term-list)
    (cons variable term-list))

  (define (variable poly) (car poly))

  (define (term-list poly) (cdr poly))

  (define (first-term term-list) (car term-list))

  (define (rest-of-terms term-list) (cdr term-list))

  (define (variable? var) (symbol? var))

  (define (same-variable? v1 v2)
    (and (variable? v1)
         (variable? v2)
         (eq? v1 v2)))

  (define (empty-term-list? term-list) (null? term-list))

  (define (the-empty-term-list) '())

  (define (make-term order coeff) (list order coeff))

  (define (order term) (car term))

  (define (coeff term) (cadr term))

  (define (append-terms term term-list)
    (if (=zero? (coeff term))
        term-list
        (cons term term-list)))

  (define (gcd-terms a b)
    (define (simplify-terms L)
      (let ((gcd-coeff (apply gcd (map coeff L))))
        (let ((new-terms (map (lambda(term) (make-term (order term) (/ (coeff term) gcd-coeff))) L)))
          new-terms)))
            
    (if (empty-term-list? b)
      (simplify-terms a)
      (gcd-terms b (pseudoremainder-terms a b))))

  (define (negate-term term)
    (make-term
      (order term)
      (negate (coeff term))))

  (define (negate-termlist L)
    (if (empty-term-list? L)
      L
      (append-terms (negate-term (first-term L))
                    (negate-termlist (rest-of-terms L)))))

  (define (sub-terms L1 L2)
    (add-terms L1 (negate-termlist L2)))

  (define (remainder-terms L1 L2)
    (cadr (div-terms L1 L2)))

  (define (pseudoremainder-terms L1 L2)
    (let ((order-l1 (order (first-term L1)))
          (order-l2 (order (first-term L2)))
          (leading-coeff (coeff (first-term L2))))
      (let ((integerizer (expt
                           leading-coeff
                           (- (+ 1 order-l1) order-l2))))
        (let ((new-dividend (mul-by-all-terms (make-term 0 integerizer) L1)))
          (cadr (div-terms new-dividend L2))))))

  (define (gcd-polys P1 P2)
    (if (same-variable? (variable P2) (variable P1))
      (let ((gcd-term-list (gcd-terms (term-list P1) (term-list P2))))
        (make-poly (variable P1) gcd-term-list))
      (error "Polynomials not in same variable ! -- GCD-POLYS" (list P1 P2))))


  (define (add-polys P1 P2);{{{
    (if (same-variable? (variable P1) (variable P2))
        (make-poly
          (variable P1)
          (add-terms
            (term-list P1)
            (term-list P2)))
        (error "Polynomials not in same variable " (list P1 P2))));}}}

  (define (mul-polys P1 P2);{{{
    (if (same-variable? (variable P1) (variable P2))
        (make-poly
          (variable P1)
          (mul-terms
            (term-list P1)
            (term-list P2)))
        (error "Polynomials not in same variable " (list P1 P2))));}}}

  (define (div-polys P1 P2);{{{
    (if (same-variable? (variable P1) (variable P2))
      (let ((result-meta-list (div-terms (term-list P1) (term-list P2))))
        (let ((div-quotient (car result-meta-list))
              (div-remainder (cadr result-meta-list)))
          (list
            (make-poly (variable P1) div-quotient)
            (make-poly (variable P1) div-remainder))))
      (error "POLYNOMIALS NOT IN SAME VARIABLE" (list P1 P2))));}}}

  (define (add-terms term-list1 term-list2);{{{
    (cond ((empty-term-list? term-list1) term-list2)
          ((empty-term-list? term-list2) term-list1)
          (else
            (let ((t1 (first-term term-list1))
                  (t2 (first-term term-list2)))
              (cond ((> (order t1) (order t2))
                     (append-terms t1
                                   (add-terms (rest-of-terms term-list1) term-list2)))
                    ((< (order t1) (order t2))
                     (append-terms t2
                                   (add-terms term-list1 (rest-of-terms term-list2))))
                    (else
                      (append-terms (make-term (order t1) (add (coeff t1) (coeff t2)))
                                    (add-terms
                                      (rest-of-terms term-list1)
                                      (rest-of-terms term-list2)))))))));}}}

  (define (mul-terms term-list1 term-list2);{{{
    (cond ((empty-term-list? term-list1)
           (the-empty-term-list))
          (else
            (add-terms
              (mul-by-all-terms (first-term term-list1) term-list2)
              (mul-terms (rest-of-terms term-list1) term-list2)))));}}}

  (define (mul-by-all-terms term term-list);{{{
    (if (empty-term-list? term-list)
        ;(the-empty-term-list)
        (the-empty-term-list)
        (append-terms
          (make-term
            (+ (order term) (order (first-term term-list)))
            (mul (coeff term) (coeff (first-term term-list))))
          (mul-by-all-terms term (rest-of-terms term-list)))));}}}

  (define (div-terms L1 L2);{{{
    (if (empty-term-list? L1)
        (list (the-empty-term-list) (the-empty-term-list))
        (let ((t1 (first-term L1))
              (t2 (first-term L2)))
          (if (> (order t2) (order t1))
              (list (the-empty-term-list) L1)
              (let ((new-c (div (coeff t1) (coeff t2)))
                    (new-o (- (order t1) (order t2))))
                (let ((f-term (make-term new-o new-c)))
                  (let ((rest-of-result (div-terms (sub-terms L1
                                                              (mul-by-all-terms f-term L2))
                                                   L2)))
                  (list (append-terms f-term (car rest-of-result)) (cadr rest-of-result)))))))));}}}

  (define (nil-polynomial poly);{{{
    (cond ((empty-term-list? (term-list poly)) #t)
          ((not (=zero? (coeff (first-term (term-list poly)))))
           #f)
          (else
            (nil-polynomial
              (make-poly
                (variable poly)
                (rest-of-terms (term-list poly)))))));}}}

  (define (negate-polynomial poly);{{{
    ; The negation of a polynomial:
    ;
    ; - Has the seme variable
    ; - The same degrees
    ; - Tne coefficients get negated

    ; Trying out the first strat that comes to mind
    ; might be inefficient, but for a first try, i ll go with this.
    ; Ill get the list of terms, then ill map a function that
    ; negates coefficients along that.
    ; then ill make a polynomial with that.
    (let ((negated-list (map (lambda(term) (make-term (order term)
                                                      (negate (coeff term))))
                             (term-list poly))))
      (make-poly (variable poly)
                 negated-list)));}}}

  ;; ---------------------------------

  (define first-op
    (put op-table 'make 'polynomial
         (lambda(polyvar poly-term-list)
           (tag (make-poly polyvar poly-term-list)))))

  (define second-op
    (put first-op 'add '(polynomial polynomial)
         (lambda(pol1 pol2) (tag (add-polys pol1 pol2)))))

  (define third-op
    (put second-op 'mul '(polynomial polynomial)
         (lambda(pol1 pol2) (tag (mul-polys pol1 pol2)))))

  (define fourth-op
    (put third-op 'sub '(polynomial polynomial)
         (lambda(pol1 pol2) (tag (add-polys pol1 (negate-polynomial pol2))))))

  (define fifth-op
    (put fourth-op 'div '(polynomial polynomial)
         (lambda (pol1 pol2) (tag (div-polys pol1 pol2)))))

  (define sixth-op
    (put fifth-op 'negate '(polynomial)
         (lambda(pol) (tag (negate-polynomial pol)))))

  (define seventh-op
    (put sixth-op '=zero? '(polynomial)
         (lambda(pol) (nil-polynomial pol))))

  (define eigth-op
    (put seventh-op 'gcd '(polynomial polynomial)
         (lambda(pol1 pol2) (tag (gcd-polys pol1 pol2)))))

  eigth-op)


;; Exposing the functions to make polynomials

(define (make-poly variable term-list)
  ((get MAIN-TABLE 'make 'polynomial) variable term-list))

(define MAIN-TABLE (install-polynomial-package MAIN-TABLE))

; (map displayln MAIN-TABLE)

; (define poly-example
;   (make-poly 'x '((7 2) (5 -4) (2 3) (1 1) (0 7))))
;
; (define p
;   (make-poly 'x '((4 2) (2 4) (0 1))))
;
; ; (map displayln (list p poly-example))
; ;
; ; (displayln (add p poly-example))
;
; (define complex (make-complex-from-real-imag 8 7))
; (define rqt (make-rat 7 8))
;
; (define t1 (list 3 complex))
; (define t2 (list 1 rqt))
; (define term-lost (list t1 t2))
; (define zero-list (list
;                     (list 3 (make-rat 0 2))
;                     (list 2 0)
;                     (list 1 (make-complex-from-real-imag 0 0))))
;
;
; (define pol (make-poly 'x term-lost))
;(make-poly 'x (list (list 3 5)
                    ;(list 2 (make-rat 3 4))
                    ;(list 1 (make-complex-from-real-imag 5 0))))

(require racket/include)

(require racket/trace)
;; 2020-01-15 20:31 :: zenAndroid
;; I am being intentionnally verbose.
;; The code honestly seems self-documenting, however maybe i'll change opinion
;; if i get back to this code some time in the future :thinking:


;; Either way, the best way *I* understood this was by taking apen and paper
;; and going through the process manually.

;; Adding two polynomials

(define (add-polys P1 P2)
  (if (same-variable? P1 P2)
      (make-poly 
        (variable P1)
        (add-terms 
          (term-list P1)
          (term-list P2))))
      (error "Polynomials not in same variable " (list P1 P2)))

;; Multiplying two polynomials

(define (mul-polys P1 P2)
  (if (same-variable? P1 P2)
      (make-poly 
        (variable P1)
        (mul-terms 
          (term-list P1)
          (term-list P2))))
      (error "Polynomials not in same variable " (list P1 P2)))

;; Adding two polynomial term lists

(define (add-terms term-list1 term-list2)
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
                                    (rest-of-terms term-list2)))))))))


;; Multiplying two polynomial term lists.

(define (mul-terms term-list1 term-list2)
  (define (mul-by-all-terms term term-list)
    (if (empty-term-list? term-list)
        the-empty-term-list
        (append-terms
          (make-term 
            (+ (order term) (order (first-term term-list))) 
            (mul (coeff t1) (coeff (first-term term-list))))
          (mul-terms term (rest-of-terms term-list)))))
  (cond ((empty-term-list? term-list1) the-empty-term-list)
        (else
          (add-terms 
            (mul-by-all-terms (first-term term-list1) term-list2)
            (mul-terms (rest-of-terms term-list1) term-list2)))))

;; Let's see what I need now:
;; same-variable?, variable? ==> for controlling the polynomial variables
;; variable, term-list ==> for the polynomial
;; make-poly           ==> for the polynomial
;; first-term          ==> selects the first term out of a list of terms
;; order, coeff        ==> for the term
;; make-term           ==> for the term
;; empty-term-list?
;; the-empty-term-list

(define (install-polynomial-package op-table)

  (define (make-poly variable term-list)
    (cons variable term-list))

  (define (variable poly)
    (car poly))

  (define (term-list poly)
    (cdr poly))

  (define (first-term poly)
    (car (term-list poly)))

  (define (variable? var)
    (symbol? var))

  (define (same-variable? v1 v2)
    (and (variable? v1)
         (variable? v2)
         (eq? v1 v2)))

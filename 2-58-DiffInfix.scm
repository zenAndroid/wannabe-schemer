#lang scheme
(require racket/trace)
; DERIVATE BOI
; COME ON BOI
; YE BOI
;;; Infix style
; 
; predicates and functions that should be available:
; - variable?
; - sum?
; - addend
; - augend
; - make-sum
; - product?
; - multiplicand
; - multiplier
; - make-product

(define (number-eq exp num)
  (and (number? exp) (= exp num)))

(define (variable? symbol) (symbol? symbol))

(define (same-variable? exp var) (and (variable? exp) (variable? var) (eq? exp var)))

(define (sum? e) (and (pair? e) (eq? (cadr e) '+))); A sum: list whose middle element is the symbol +

(define addend car)

(define augend caddr)

(define (make-infix-sum e1 e2)
  (cond ((number-eq e1 0) e2)
        ((number-eq e2 0) e1)
        ((and (number? e1) (number? e2)) (+ e1 e2))
        (else (list e1 '+ e2))))

(define (product? e) (and (pair? e) (eq? (cadr e) '*)))

(define multiplier car)

(define multiplicand caddr)

(define (make-infix-product e1 e2)
  (cond ((or (number-eq e1 0) (number-eq e2 0)) 0)
        ((number-eq e1 1) e2)
        ((number-eq e2 1) e1)
        ((and (number? e1) (number? e2)) (* e1 e2))
        (else (list e1 '* e2))))

; - exponentiention?
; - exponent
; - base
; - make-exponentiation

; TODO


; Infix notation would be : (base ** exponent)
; ... so

(define (exponentiention? e) (and (pair? e) (eq? (cadr e) '**)))

(define base car)

(define exponent caddr)

(define (make-exponentiation base exponent)
  (cond ((and (eq? base 0) (eq? exponent 0)) (error "0**0 don't make no sense" base " " exponent))
        ((eq? base 0) 0)
        ((eq? exponent 0) 1)
        ((eq? exponent 1) base)
        (else (list base '** exponent))))

; (x + (3 * (x + (y + 2))))

; assume + and * take two arguments and expressions are fully parenthesized!

(trace-define (derivate expression variable) ; Derivate Expression with respect to variable
              ; (dc)/(dx) = 0
              ; (dx)/(dx) = 1
              ; d(u+v)/d(x) = d(u)/d(x) + d(v)/d(x)
              ; d(uv)/(dx) = u*((d(v))/(dx)+v*((d(u)/(dx))
              (cond ((number? expression) 0)
                    ((variable? expression) (if (same-variable? expression variable) 1 0))
                    ((sum? expression) (make-infix-sum
                                        (derivate (addend expression) variable)
                                        (derivate (augend expression) variable)))
                    ((product? expression) (make-infix-sum
                                            (make-infix-product
                                             (multiplier expression)
                                             (derivate (multiplicand expression) variable))
                                            (make-infix-product
                                             (multiplicand expression)
                                             (derivate (multiplier expression) variable))))
                    ((exponentiention? expression) ; n * u * u' ==> (n) * ((u**(n-1) * u')
                     (make-infix-product
                      (make-infix-product (exponent expression) 1)
                      (make-infix-product
                       (derivate (base expression) variable)
                       (make-exponentiation (base expression) (- (exponent expression) 1)))))
                    (else (error "unknown expression type: DERIV" expression))))

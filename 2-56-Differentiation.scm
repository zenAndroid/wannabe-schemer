
#lang scheme
(require racket/trace)
; DERIVATE BOI
; COME ON BOI
; YE BOI

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
(define (predicate-operation operation)
  (lambda(expression) (and (pair? expression) (eq? (car expression) operation))))

; this way you can have (define sum? (predicate-expression '+))
; and so on
; just did that cuz i couldn't help it.

(define (number-eq exp num)
  (and (number? exp) (= exp num)))

(define (variable? symbol) (symbol? symbol))

(define (same-variable? exp var) (and (variable? exp) (variable? var) (eq? exp var)))

(define (sum? e) (and (pair? e) (eq? (car e) '+))) ; A sum: list whose first element is the symbol +

(define (addend e) (cadr e))

(define (augend e) (foldr make-sum 0 (cddr e)))
  ; (+ 5 f r x 8)
  ; addend = 5
  ; augend = (+ f r x 8)
; GAHHHHHHHHHH i caved in and saw the solution, I HAD THE INITIAL HUNCH OF FOLDR

(define (make-sum e1 e2)
  (cond ((number-eq e1 0) e2)
        ((number-eq e2 0) e1)
        ((and (number? e1) (number? e2)) (+ e1 e2))
        (else (list '+ e1 e2))))            ; Was really confused about this at first,
                                            ; because i thought that they should all be quoted,
                                            ; but then i remembered that e1 and e2 will *already*
                                            ; have been quoted by the time they pass as arguments
                                            ; for the function

(define (product? e) (and (pair? e) (eq? (car e) '*)))

(define (multiplier e) (cadr e))

(define (multiplicand e) (foldr make-product 1 (cddr e)))

(define (make-product e1 e2)
  (cond ((or (number-eq e1 0) (number-eq e2 0)) 0)
        ((number-eq e1 1) e2)
        ((number-eq e2 1) e1)
        ((and (number? e1) (number? e2)) (* e1 e2))
        (else (list '* e1 e2))))

; - exponentiention?
; - exponent
; - base
; - make-exponentiation


(define (exponentiention? e) (and (pair? e) (eq? (car e) '**)))

(define (base e) (cadr e))

(define (exponent e) (caddr e))

(define (make-exponentiation base exponent)
  (cond ((and (eq? base 0) (eq? exponent 0)) (error "0**0 don't make no sense" base " " exponent))
        ((eq? base 0) 0)
        ((eq? exponent 0) 1)
        ((eq? exponent 1) base)
        (else (list '** base exponent))))



(trace-define (derivate expression variable) ; Derivate Expression with respect to variable
  ; (dc)/(dx) = 0
  ; (dx)/(dx) = 1
  ; d(u+v)/d(x) = d(u)/d(x) + d(v)/d(x)
  ; d(uv)/(dx) = u*((d(v))/(dx)+v*((d(u)/(dx))
  (cond ((number? expression) 0)
        ((variable? expression) (if (same-variable? expression variable) 1 0))
        ((sum? expression) (make-sum
                             (derivate (addend expression) variable)
                             (derivate (augend expression) variable)))
        ((product? expression) (make-sum
                                 (make-product
                                   (multiplier expression)
                                   (derivate (multiplicand expression) variable))
                                 (make-product
                                   (multiplicand expression)
                                   (derivate (multiplier expression) variable))))
        ((exponentiention? expression) ; n * u * u' ==> (n) * ((u**(n-1) * u')
         (make-product
           (make-product (exponent expression) 1)
           (make-product (derivate (base expression) variable)
                         (make-exponentiation (base expression) (- (exponent expression) 1)))))
        (else (error "unknown expression type: DERIV" expression))))

; For now i'm going to settle in with this format but i have this itch that's telling me there
; are myriad ways to improve/optimize this stuff.

(derivate '(+ x x) 'x)
(define fugg (derivate '(** x 2) 'x))

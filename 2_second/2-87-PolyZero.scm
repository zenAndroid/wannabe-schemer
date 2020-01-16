(require racket/include)

(require racket/trace)

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


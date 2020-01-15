; Functions to handle a table of triplets


(define (put table op type item) 
  (cons (cons op (cons type item)) table))

(define (get table op type)
  (cond ((null? table) (error "Empty table ... RIP !"))
        ((and (equal? op (caar table)) (equal? type (cadar table))) (cddar table))
        (else (get (cdr table) op type))))


; Functions to handle tagged data

(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum: 
              TYPE-TAG" datum)))

(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum: 
              CONTENTS" datum)))


; Functions to handle generic functionality


(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get MAIN-TABLE op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error
            "No method for these types:
             APPLY-GENERIC"
            (list op type-tags))))))


(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z)     (apply-generic 'angle z))

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))

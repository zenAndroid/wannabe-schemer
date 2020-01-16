(require racket/trace)

; Functions to handle a table of triplets


(define (put table op type item) 
  (cons (cons op (cons type item)) table))

(define (get table op type)
  (cond ((null? table) #f)
        ((and (equal? op (caar table)) (equal? type (cadar table))) (cddar table))
        (else (get (cdr table) op type))))


; Functions to handle tagged data

(define (attach-tag type-tag contents)
  (if (number? contents)
      contents
      (cons type-tag contents)))

(define (type-tag datum)
  (cond ((number? datum) 'scheme-number)
        ((pair? datum) (car datum))
        (else (error "Bad tagged datum: TYPE-TAG" datum))))

(define (contents datum)
  (cond ((number? datum) datum)
        ((pair? datum) (cdr datum))
        (else (error "Bad tagged datum: CONTENTS" datum))))


; Functions to handle generic functionality


; (define (apply-generic op . args)
;   (let ((type-tags (map type-tag args)))
;     (let ((proc (get MAIN-TABLE op type-tags)))
;       (if proc
;           (apply proc (map contents args))
;           (error
;             "No method for these types:
;              APPLY-GENERIC"
;             (list op type-tags))))))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get MAIN-TABLE op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((first-arg (car args))
                    (second-arg (cadr args))
                    (first-type (type-tag (car args)))
                    (second-type (type-tag (cadr args))))
                (let ((first-type->second-type (get COERCION first-type second-type))
                      (second-type->first-type (get COERCION second-type first-type)))
                  (cond (first-type->second-type (apply-generic op (first-type->second-type first-arg) second-arg))
                        (second-type->first-type (apply-generic op first-arg (second-type->first-type second-arg)))
                        (error "Cannot find a fitting operation" (list op type-tags)))))
              (error "No method found" (list op type-tags args)))))))


(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z)     (apply-generic 'angle z))

(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (equ? x y) (apply-generic 'equ? x y))
(define (=zero? x) (apply-generic '=zero? x))

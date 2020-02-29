; 2020-02-28 18:49 :: zenAndroid :: Making DG look like a neurotypical with
; this density of mine, but eh, no use sweating over it too much


(use-modules (ice-9 pretty-print)) 
; Just so you know, zen, this is for pretty printing the 'code' (the data (((At this point what's the difference? yEEeeEEEt

(define test-code
  '(let fib-iter ((a 1) (b 0) (count n))
     (if (= count 0)
       b
       (fib-iter (+ a b)
                 a
                 (- count 1)))))

; Just for reference: (let <var> <bindings> <body>)

(define (named-let-var exp) (cadr exp))

(define (named-let-var-exps exp) (caddr exp))

(define (named-let-vars exp) (map car (named-let-var-exps exp))) 

(define (named-let-exps exp) (map cadr (named-let-var-exps exp)))

(define (named-let-body exp) (cdddr exp)) 
; cadddr or cdddr ? I wonder, not actually I think I rather use cdddr since
; technically there could be a series of expressions with a regular let body,
; so I figure functionaliy is transferred over to this more specialized
; version.

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))

(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (make-lambda p b) (list 'lambda p b))

(define (named-let? exp)
  (and (tagged-list 'let)
       (symbol? (cadr exp))))

(define (named-let-temp-handler exp)
  (let ((proc (list 'define (cons (named-let-var exp)
                                  (named-let-vars exp))
                    (sequence->exp (named-let-body exp)))))
    (list (make-lambda '() (sequence->exp 
                             (list proc 
                                   (cons 
                                     (named-let-var exp) 
                                     (named-let-exps exp))))))))


(pretty-print (named-let-temp-handler test-code))

; scheme@(guile-user)> (pretty-print (named-let-temp-handler test-code))
; ((lambda ()
;    (define (fib-iter a b count)
;      (if (= count 0)
;        b
;        (fib-iter (+ a b) a (- count 1)))))
;  (fib-iter 1 0 n))

;;;  (define (fib n)
;;;    ((lambda ()
;;;       (define (fib-iter a b count)
;;;         (if (= count 0)
;;;           b
;;;           (fib-iter (+ a b) a (- count 1)))))
;;;     (fib-iter 1 0 n)))

; Yep, good thing I tested this, there is a bug ...

(define (fib n)
  ((lambda ()
     (begin
       (define (fib-iter a b count)
         (if (= count 0)
           b
           (fib-iter (+ a b) a (- count 1))))
       (fib-iter 1 0 n)))))

; Seems correct
; .. I hope I did not miss something obious, though I don't think so.

(define I-wonder
  '(let foo ((a 5)
             (b 30))
     (display (foo a b))))

; Yep, it seems to work, took me a while but I got it.

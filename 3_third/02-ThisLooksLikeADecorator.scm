; 2020-01-25 23:07 :: zenAndroid :: Here we go

(define (make-monitored procedure)
  (let ((no-of-calls 0))
    (lambda(arg) 
      (cond ((eq? arg 'how-many-calls?) no-of-calls)
            ((eq? arg 'reset-count) (set! no-of-calls 0))
            ((symbol? arg) (error "This function only takes numbers -- make-monitored" no-of-calls))
            (else
              (begin (set! no-of-calls (+ no-of-calls 1))
                     (procedure arg))))

(define s (make-monitored sqrt))

(s 100)

; Seems to be acting as expected 

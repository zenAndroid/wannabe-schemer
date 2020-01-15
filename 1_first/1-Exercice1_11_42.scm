#lang scheme

(define (f n)
   (cond ((< n 3) n)
          (else 
            (+ (f (- n 1) )
                (* (f (- n 2)) 2)
                (* (f (- n 3)) 3)))))

(define (fi n)
   (cond ((< n 3) n)
          (else (fh 2 1 0 n ))))

(define (fh a b c count )
   (cond ((< count 3) a)
          (else (fh (+ a (* b 2 ) (* c 3 )) a b (- count 1)))))

(define foo 50)

(displayln (fi foo))
(display ( f foo))

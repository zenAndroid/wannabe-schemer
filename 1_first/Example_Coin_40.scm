#lang scheme
(define (change amount)
         (changeHelper amount 5))

(define (changeHelper amount noCoins)
         ( cond ((= amount 0) 1) 
                (( or (< amount 0) (= noCoins 0)) 0)
                (else (+
                         (changeHelper amount (- noCoins 1))
                         (changeHelper (- amount (denomination noCoins)) (- noCoins 0))))))

(define (denomination noCoins)
         (cond ((= noCoins 1) 1)
                ((= noCoins 2) 5)
                ((= noCoins 3) 10)
                ((= noCoins 4) 25)
                ((= noCoins 5) 50)))

(require racket/trace)
(trace change)
(display (change 11))

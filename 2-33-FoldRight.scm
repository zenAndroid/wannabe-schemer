#lang scheme
(require racket/trace)

;; Accumulate function

(trace-define (accumulate op init seq)
  (if (null? seq)
      init
      (op (car seq) (accumulate op init (cdr seq)))))


(define (map p sequence)
  (accumulate (lambda (first acc) (cons (p first) acc)) '() sequence))

(map (lambda(x) (+ 1 x)) '(1 1 8))

;; Fold-right is easy but i always get tripped up if i dont see it
;; in a while, perhaps i haven't internalized it yet :s
;; ... perhaps i still haven't understood it in my _spleen_

#lang scheme
(require racket/trace) ; Enables (trace foo) to ... trace the execution of foo
(trace-define (accumulate op init seq)
  (if (null? seq)
      init
      (op (car seq) (accumulate op init (cdr seq)))))

(define fold-right accumulate)

(trace-define (fold-left op acc seq)
  (if (null? seq)
      acc
      (fold-left op (op acc (car seq)) (cdr seq))))

;; To fold a sequence by the left, in the general case, you call
;; the same function with the same operator but the accumulator
;; gets transformed (it's combined with the first element in the
;; sequence using the function's operator ('op')) and the sequence
;; becomes itself without the first element (cdr seq)
;; If the sequence is empty, then you simply return the accumulator.

(define (reverse-right seq)
  (fold-right (lambda(x y) (append y (list x))) '() seq))

(reverse-right (list 10 20 30 40 50 60 70 80 90 100))

(define (reverse-left seq)
  (fold-left (lambda (x y) (append (list y) x)) '() seq))

(reverse-left (list 1 2 3 4 5 6 7 8 9 10))
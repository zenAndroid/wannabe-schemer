#lang scheme
(require sicp-pict)


;; Naive version of the splits

(define (right-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split painter (- n 1))))
        (beside painter (below smaller smaller)))))


(define (up-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (up-split painter (- n 1))))
        (below painter (beside smaller smaller)))))


; Right-split and up-split can be expressed as instances of a general splitting operation.
; Define a procedure split with the property that evaluating
;
; (define right-split (split beside below))
; (define up-split (split below beside))
; produces procedures right-split and up-split with the same behaviors as the ones already defined.

(define (split foo bar)
  (lambda(painter n)
    (if (= n 0)
        painter
        (let ((smaller ((split foo bar) painter (- n 1))))
          (foo painter (bar smaller smaller))))))

;; Look ma, not even looking at the internet i swear!
;; Son, im proud of you!
(define new-r-split (split beside below))

(paint (new-r-split einstein 3))


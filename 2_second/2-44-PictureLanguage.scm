#lang scheme
(require sicp-pict) ; Needed to install a package to get these apinter thingies.
(require racket/trace)
; (paint einstein)

; (paint (flip-vert einstein))

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

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((bottom-right
            (below (right-split painter (- n 1))
                   (right-split painter (- n 1))))
            (upper-left
             (beside (up-split painter (- n 1))
                     (up-split painter (- n 1)))))
        (below
         (beside painter bottom-right)
         (beside upper-left (corner-split painter (- n 1)))))))


(paint #:width 700 #:height 700
       (corner-split einstein 5))
; Hmmm ... can let constructs be nested together
; ...
; only one way to find out

(define (dank-square painter n)
  (let ((id (corner-split painter n)))
    (let ((upper (beside (flip-horiz id) id)))
      (let ((bottom (flip-vert upper)))
        (below bottom upper)))))

; Apparently you can ... *yeet*

(paint #:width 700 #:height 700
         (dank-square diagonal-shading 5))
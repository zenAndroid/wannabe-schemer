# 2020-02-23 09:43 :: zenAndroid :: Can't wait to move on ...

(define (make-zero-crossings-smoothing input-stream last-value last-avpt)
  (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
    (stream-cons 
      (sign-change-detector avpt last-avpt)
      (make-zero-crossings-smoothing  
        (stream-cdr input-stream)
        (stream-car input-stream)
        avpt))))

(define (smooth input-stream)
  (zen-stream-map
    (lambda(x y) (/ (+ x y) 2))
    (stream-cons 0 input-stream) input-stream))

; Yep, tfw actually came up with this
; It is pretty much the same thing as Exercise 3.74
; So, without ado, here goes:

(define (make-zero-crossings-smoothing input-stream smoother)
  (let ((smoothed (smoother input-stream)))
    (stream-map sign-change-detector smoothed (stream-cons (stream-first smoothed) smoothed))))




; (+ (f 0) (f 1))
; left-to-right --> 0
; right-to-left --> 1

; 2020-01-28 10:10 :: zenAndroid :: Meh, here goes, i'll give it a few attempts 
; but i shan't waste too much time on it.

(define f
  (let ((retval 5))
    (lambda(x)
      (cond ((= retval 5)
             (cond ((= x 0) (begin (set! retval 6) -1))
                   ((= x 1) (begin (set! retval 6) 1))))
            ((= retval 6)
             (cond ((= x 0) (begin (set! retval 5) 0))
                   ((= x 1) (begin (set! retval 5) 1))))))))
;
; I force the order of evaluation using nested let constructs
; 
; > (let ((r1 (f 0))) (let ((r2 (f 1))) (+ r1 r2)))
; 0
; > (let ((r2 (f 0))) (let ((r1 (f 1))) (+ r1 r2)))
; 0
; > (let ((r1 (f 1))) (let ((r2 (f 0))) (+ r1 r2)))
; 1
; > (let ((r2 (f 0))) (let ((r1 (f 1))) (+ r1 r2)))
; 0
; > ^D

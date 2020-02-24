; 2020-02-23 13:26 :: zenAndroid ::  Lets seethis should be somewhat easy ...


(load "78-SecondOrder.scm")

(define (solve-2nd f dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (f dy y))
  y)


; in the case of the previous exercise, the procedure f would be ..
; 
; (lambda(first-stream second-stream)
;   (add-stream
;     (scale first-stream <some constant>)
;     (scale second-stream <some constant>)))
; 
; ??? 
; 
; Welp, I think so ...
; Seems like it'll work, and i've convinced myself that it is working so it's
; time to check the solutions.
; Seems OK, wanted some test cases, didnt bother too much



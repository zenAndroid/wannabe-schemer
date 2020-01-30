(define (pc x)
  (if (not (pair? x)) 0
  (+ (pc (car x))
     (pc (cdr x))
     1)))

(define 3-p 
  (cons 1 
        (cons 2 
              (cons 3 '())))
  )
(define 4-p (cons (cons 1 2) (cons 2 (cons 3 '()))))

(define 7-p (cons
              (cons 
                (cons 1 2)
                (cons 3 4))
              (cons
                (cons 5 6)
                (cons 7 8))))

; This was my initial answer, i thought it was right then i
; saw the soluutions and realized i forgot the requirements, rip.

; Ended up looking at the solution for 3.17 too, somehow i felt ill spend way
; too much time on it, maybe i did myself a disservice tho
; but the list structure things and box'n'pointer schemas can get real spooky i feel

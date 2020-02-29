; 2020-02-29 15:22 :: zenAndroid :: Hmm? This shouldn't be too hard except if I'm forgetting something obvious?


;;;  (define (make-frame variables values)
;;;    (cons variables values))
;;;  
;;;  (define (frame-variables frame) (car frame))
;;;  (define (frame-values frame) (cdr frame))
;;;  
;;;  (define (add-binding-to-frame! var val frame)
;;;    (set-car! frame (cons var (car frame)))
;;;    (set-cdr! frame (cons val (cdr frame))))

; So I need to change four functions pretty much.

; Also, a brain fart of mine:

; While first attempting to solve this, I decided to model the input to
; make-frame as the answer (so (make-frame list-of-bindings) and I didn't know
; what to do, essentialy I made the input of my function its supposed output,
; was lost there for a moment, but then after looking at the header of Eli's
; solution I resumed thinking normally (although I haven;t yet looked at all of
; the solution, but I'm glad I did because it probably saved me a couple if
; headaches.


(define (make-frame vars vals)
  (cond ((not (= (length vars) (length vals)))
         (error "Length mismatch"))
        ((null? vars) ; No need to check (null? vals) since their length is equal so if one is not empty ...
         '())
        (cons (cons (car vars) (car vals)) (make-frame (cdr vars) (cdr vals)))))

(define (frame-variables frame)
  (map car frame))

(define (frame-values frame)
  (map cdr frame)) ; Rember it's a pair not a list

(define (add-binding-to-frame! var val frame)
  (let ((new-binding (cons var val)))
        (set! frame (cond new-binding frame))))


; SUspected it, cant test this yet, but I have a suspicion this code wont work
; refer to footnote 14:

; Frames are not really a data abstraction in the following code:
; Set-variable-value! and define-variable! use set-car! to directly modify the
; values in a frame. The purpose of the frame procedures is to make the
; environment-manipulation procedures easy to read.

; Gunna have to change the definition of these two I think ...

; Might do it later tho ¯\_(ツ)_/¯

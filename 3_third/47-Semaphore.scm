; Hum, at this moment in tile I feel sleepy, brqin tired, must take things ...
; s...low...l..y ...
; 
; Let's see the final product's behavior.
; 
; (define foo (make-semaphore 3))
; (foo 'acquire)
; ; works
; 
; (foo 'acquire)
; ; works
; 
; (foo 'acquire)
; ; works
; 
; (foo 'acquire)
; ; HANGS
; 
; (foo 'release)
;  
; 
; (foo 'acquire)
; ; works
; 
; This is how it's supposed to work I think ...
; 
; So it appears to have a counter, and it appears that it does not allow
; further acquirings from happening after n (where n is the number the
; semaphore was created with)

;  (define (make-semaphore n) 
;    (let ((lock (make-mutex)) 
;          (taken 0)) 
;      (define (semaphore command) 
;        (cond ((eq? command 'acquire) 
;               (lock 'acquire) 
;               (if (< taken n) 
;                   (begin (set! taken (1+ taken)) (lock 'release)) 
;                   (begin (lock 'release) (semaphore 'acquire)))) 
;              ((eq? command 'release) 
;               (lock 'acquire) 
;               (set! taken (1- taken)) 
;               (lock 'release)))) 
;      semaphore)) 

; Taken from sicp solutions, ... at first I did not understand why a mutex was
; used as that is "hard-coded" to only allow one entry, but then o relized that
; the `(lock 'release)`s took care of that

; Don't know if I could come up with that, possibly, but I dunno. 





; As for the next one my brain is too fried to think about it, I just looked at
; the solution and understood that :(

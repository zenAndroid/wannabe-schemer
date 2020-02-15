; (define (test-and-set! cell)
;   (if (car cell)
;       true
;       (begin (set-car! cell true)
;              false)))
; 
; Preeeety straight forward, two processes call the function,
;                          , they both test (car cell)
;                          , they both both find it to be false
;                          , they both start executing the body of the begin form
;                          , --> they both set cell to true
;                          , --> they both return false
;                          , they now both 'acquired' the mutex
;                          , this is bad.

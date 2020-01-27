; 2020-01-26 20:21 :: zenAndroid :: I dont have rand-update/cant seem to find its equivalent
; so i'll jsut write out the code and hope for the best ...

(define rand
  (let ((x random-init))
    (lambda(arg)
      (cond ((eq? arg 'generate)
             (begin (set! x (rand-update x))
                    x))
            ((eq? arg 'reset)
             (lambda(new-value)
               (set! x new-value)))
            (else (error "Bad symbol as argument"))))))

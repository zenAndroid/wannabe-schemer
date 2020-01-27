(define (make-account pass balance)
  
  (define (withdraw in-pass amount)
    (let ((correct-pass? (eq? in-pass pass))
          (gotEnuf-money? (>= balance amount)))
      (cond ((not correct-pass?) "Incorrect password")
            ((not gotEnuf-money?) "Insufficient funds")
            (else ; Correct password AND Got enough money
              (begin (set! balance (- balance amount))
                     balance)))))

  (define (deposit in-pass amount)
    (let ((correct-pass? (eq? in-pass pass)))
      (cond ((not correct-pass?) "Incorrect password")
            (else ; Correct password
              (begin (set! balance (+ balance amount))
                     balance)))))

  (define (dispatch input-pass m)
    (cond ((eq? m 'withdraw) 
           (lambda (arg) (withdraw input-pass arg)))
          ((eq? m 'deposit) 
           (lambda (arg) (deposit input-pass arg)))
          ((eq? m 'verify-pass)
           (lambda(pass-attempt) (eq? pass-attempt pass)))
          (else (error "Unknown request: 
                 MAKE-ACCOUNT" m))))

  dispatch)

; 
; > (define acc (make-account 'zenandroid 1000))
; > acc
; #<procedure:dispatch>
; > ((acc 'zenandroid 'withdraw) 345)
; 655
; > ((acc 'zenandrid 'withdraw) 345)
; "Incorrect password"
; > ((acc 'zenandroid 'withdraw) 345)
; 310
; > ((acc 'zenandroid 'withdraw) 345)
; "Insufficient funds"
; > ((acc 'zenandroid 'withdraw) 345)
; "Insufficient funds"
; > ((acc 'zenandroid 'withdraw) 35)
; 275
; > ((acc 'zenandroid 'withdraw) 3533)
; "Insufficient funds"
; > ((acc 'zenandroid 'deposit) 3533)
; 3808
; > ((acc 'zendroid 'deposit) 3533)
; "Incorrect password"


; Seems to be acting as expected.

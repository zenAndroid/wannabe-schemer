
; Exercise 3.4: Modify the make-account procedure of Exercise 3.3 by adding another local state variable so that, if an account is accessed more than seven consecutive times with an incorrect password, it invokes the procedure call-the-cops.

(define (make-account pass balance)
  (define (call-the-cops) (error "Calling the cops !"))
  (define unauthorized-access-attempts 0)
    (define (withdraw in-pass amount)
      (let ((correct-pass? (eq? in-pass pass))
            (gotEnuf-money? (>= balance amount)))
        (cond ((not correct-pass?)
               (if (> unauthorized-access-attempts 7)
                 (call-the-cops)
                 (begin (set! unauthorized-access-attempts (+ unauthorized-access-attempts 1))
                        "Incorrect password")))
              ((not gotEnuf-money?)
               (begin (set! unauthorized-access-attempts 0) ; Even though the funds are insufficient
                      ; The fact that we are managing this alternative means that the right password
                      ; has been provided, and thus we reset the counter to zero.
                      "Insufficient funds"))
              (else ; Correct password AND Got enough money
                (begin (set! balance (- balance amount))
                       (set! unauthorized-access-attempts 0)
                       balance)))))

  (define (deposit in-pass amount)
    (let ((correct-pass? (eq? in-pass pass)))
      (cond ((not correct-pass?)
             (if (> unauthorized-access-attempts 7)
               (call-the-cops)
               (begin (set! unauthorized-access-attempts (+ unauthorized-access-attempts 1))
                      "Incorrect password")))
            (else ; Correct password
              (begin (set! balance (+ balance amount))
                     (set! unauthorized-access-attempts 0)
                     balance)))))

  (define (dispatch input-pass m)
    (cond ((eq? m 'withdraw)
           (lambda (arg) (withdraw input-pass arg)))
          ((eq? m 'deposit)
           (lambda (arg) (deposit input-pass arg)))
          (else (error "Unknown request:
                 MAKE-ACCOUNT" m))))

  dispatch)



(define acc (make-account 'pass 1000))
; > ((acc 'pass 'withdraw) 250)
; 750
; > ((acc 'pass 'withdraw) 250)
; 500
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; ; Calling the cops ! [,bt for context]
; > ((acc 'pass 'withdraw) 250)
; 250
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; "Incorrect password"
; > ((acc 'pss 'withdraw) 250)
; ; Calling the cops ! [,bt for context]
; > ((acc 'pss 'deposit) 250)
; ; Calling the cops ! [,bt for context]
; > ((acc 'pass 'deposit) 250)
; 500
; > ((acc 'pss 'deposit) 250)
; "Incorrect password"
; > ((acc 'pss 'deposit) 250)
; "Incorrect password"
; > ((acc 'pss 'deposit) 250)
; "Incorrect password"
; > ((acc 'pss 'deposit) 250)
; "Incorrect password"
; > ((acc 'pss 'deposit) 250)
; "Incorrect password"
; > ((acc 'pss 'deposit) 250)
; "Incorrect password"
; > ((acc 'pss 'deposit) 250)
; "Incorrect password"
; > ((acc 'pss 'deposit) 250)
; "Incorrect password"
; > ((acc 'pss 'deposit) 250)
; ; Calling the cops ! [,bt for context]
; > ^D

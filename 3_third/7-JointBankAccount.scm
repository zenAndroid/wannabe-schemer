(require racket/trace)


(trace-define (make-account pass balance)
  
  (trace-define (withdraw in-pass amount)
    (let ((correct-pass? (eq? in-pass pass))
          (gotEnuf-money? (>= balance amount)))
      (cond ((not correct-pass?) "Incorrect password")
            ((not gotEnuf-money?) "Insufficient funds")
            (else ; Correct password AND Got enough money
              (begin (set! balance (- balance amount))
                     balance)))))

  (trace-define (deposit in-pass amount)
    (let ((correct-pass? (eq? in-pass pass)))
      (cond ((not correct-pass?) "Incorrect password")
            (else ; Correct password
              (begin (set! balance (+ balance amount))
                     balance)))))

  (trace-define (dispatch input-pass m)
    (cond ((eq? m 'withdraw) 
           (lambda (arg) (withdraw input-pass arg)))
          ((eq? m 'deposit) 
           (lambda (arg) (deposit input-pass arg)))
          ((eq? m 'verify-pass)
           (lambda() (eq? input-pass pass)))
          (else (error "Unknown request: 
                 MAKE-ACCOUNT" m))))

  dispatch)





(trace-trace-define (make-joint original-account account-password password)
  (cond ((not (original-account account-password 'verify-pass) (error "Incorrect password ! -- HERE " account-password original-account)))
        ; At this point, we have the right password
        ; (trace-define paul-acc
        ;   (make-joint mary-acc 'marypass 'paulpass))
        ; 
        ; So the access to paul would be normally done with 
        ; ((paul-acc 'paulpass 'withdraw) 50)
        ; This tells me the ordering of the arguments to use in the lambda definition.
        (else 
          (trace-lambda(joint-pass operation)
            (let ((correct-pass? (eq? joint-pass password)))
              (cond ((not (correct-pass?))
                     (error "Incorrect password"))
                    (else ; We have the correct password
                      (cond ((eq? operation 'withdraw)
                             (original-account account-password 'withdraw))
                            ((eq? operation 'deposit)
                             (original-account account-password 'deposit))))))))))


(trace-define zen-acc (make-account 'zenandroid 1000))

(trace-define zen-joint
  (make-joint zen-acc 'zenandroid 'jointpass))

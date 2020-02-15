; I didnt think too much about this and checked the solution almost immediately,
; didnt understand the solution the decided instead of intensely reading the
; solution and understandig that, I'd rather struggle with the exercise myself so
; that what I did ¯\_(ツ)_/¯.

; Lemme get the code to properly explain myself to the future form of me, (the
; shit I do for you man, like I really wanna move on and read the cool looking
; material (MutUAl ExLUsIon MaNG) but damn it I don't want you to waste your time):

; First of all, recall what a serializer is:
; 
; (define x 10)
; (define s (make-serializer))
; (parallel-execute
;  (s (lambda () (set! x (* x x))))
;  (s (lambda () (set! x (+ x 1)))))
; 
; can produce only two possible values for x, 101 or 121. The other possibilities
; are eliminated, because the execution of P 1 and P 2 cannot be interleaved.
; 
; In other terms, If two procedures are serialized using the same serializer,
; then their execution cannot be interleaved.
; 
; This makes explaining what's going on with the exercise a matter of course, because
; 
; (define (exchange account1 account2)
;   (let ((difference (- (account1 'balance)
;                        (account2 'balance))))
;     ((account1 'withdraw) difference)
;     ((account2 'deposit) difference)))
; 
; (define (serialized-exchange account1 account2)
;   (let ((serializer1 (account1 'serializer))
;         (serializer2 (account2 'serializer)))
;     ((serializer1 (serializer2 exchange))
;      account1
;      account2)))
; 
; Louis's version of make account-and-serializer:
; 
; (define (make-account-and-serializer balance)
;   (define (withdraw amount)
;     (if (>= balance amount)
;       (begin (set! balance 
;                (- balance amount))
;              balance)
;       "Insufficient funds"))
;   (define (deposit amount)
;     (set! balance (+ balance amount))
;     balance)
;   (let ((balance-serializer 
;           (make-serializer)))
;     (define (dispatch m)
;       (cond ((eq? m 'withdraw) 
;              (balance-serializer withdraw))
;             ((eq? m 'deposit) 
;              (balance-serializer deposit))
;             ((eq? m 'balance) 
;              balance)
;             ((eq? m 'serializer) 
;              balance-serializer)
;             (else (error "Unknown request: MAKE-ACCOUNT"
;                          m))))
;     dispatch))
; 
; ---------------------------------------------------------------------------
; 
; serialized-exchange is called -> exhange is serialzed by two accounts (say, accounts A & B).
; Exchenge tries to do its business, which first equates to calculating the
; difference, so it calls (A 'balance) then (B 'balance) to calculate the
; difference, then ((A 'withdraw) difference), everything is all and well.
; 
; EXCEPT WAIT ...

; (A 'withdraw) does not return the normal, raw procedure, it returns a
; /protected/,/serialized/ procedure, and the things is *its serialzed by the
; same serializer that serialzed the serialized-exchange procedure, so at the
; moment where the exchange procedure needs to use A's withdraw procedure, it
; can't, because it has to wait for the serialized-exchange procedure to
; return, which it wont because it too needs to waint for (A 'withdraw)
; procedure to complete, and so on ... CATASTROPHE.

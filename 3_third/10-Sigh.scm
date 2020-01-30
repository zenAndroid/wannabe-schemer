
(define (make-withdraw initial-amount)
  (let ((balance initial-amount)) (lambda (amount) (if (>= balance amount) (begin (set! balance (- balance amount)) balance) "I"))))

(let ((⟨var⟩ ⟨exp⟩)) ⟨body⟩)

is interpreted as an alternate syntax for

((lambda (⟨var⟩) ⟨body⟩) ⟨exp⟩)

(let ((balance initial-amount)) )

(define (make-withdraw initial-amount)
  ((lambda (balance) (lambda (amount) (if (>= balance amount) (begin (set! balance (- balance amount)) balance) "I")) initial-amount)))

(define W1 (make-withdraw 100))
(W1 50)
(define W2 (make-withdraw 100))

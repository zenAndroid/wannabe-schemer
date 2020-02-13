(load "28-Gates.scm")

(define the-agenda (make-agenda))
(define inverter-delay 2)
(define and-gate-delay 3)
(define or-gate-delay 5)

(define input-1 (make-wire))
(define input-2 (make-wire))
(define output (make-wire))

(probe 'sum output)

(define (xor-gate a b c)
  (let ((ap (make-wire))
        (bp (make-wire))
        (abp (make-wire))
        (apb (make-wire)))
    (inverter a ap)
    (inverter b bp)
    (and-gate a bp abp)
    (and-gate ap b apb)
    (or-gate abp apb c)))

(xor-gate input-1 input-2 sum)

(set-signal! input-1 1)
(set-signal! input-2 0)

(propagate)

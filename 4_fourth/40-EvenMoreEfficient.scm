; 2020-03-18 23:31 :: zenAndroid :: :thinking:

; (define (multiple-dwelling)
;   (let ((baker (amb 1 2 3 4 5))
;         (cooper (amb 1 2 3 4 5))
;         (fletcher (amb 1 2 3 4 5))
;         (miller (amb 1 2 3 4 5))
;         (smith (amb 1 2 3 4 5)))
;     (require
;      (distinct? (list baker cooper fletcher
;                       miller smith)))
;     (require (not (= baker 5)))
;     (require (not (= cooper 1)))
;     (require (not (= fletcher 5)))
;     (require (not (= fletcher 1)))
;     (require (> miller cooper))
;     (require
;      (not (= (abs (- smith fletcher)) 1)))
;     (require
;      (not (= (abs (- fletcher cooper)) 1)))
;     (list (list 'baker baker)
;           (list 'cooper cooper)
;           (list 'fletcher fletcher)
;           (list 'miller miller)
;           (list 'smith smith))))

;; ^ Old, inefficient version


(load "00-AmbEval.scm")
(driver-loop)

(define (require p)
  (if (not p)
    (amb)))
(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5)))
    (let ((cooper (amb 1 2 3 4 5)))
      (require (distinct? (list baker cooper)))
      (let ((fletcher (amb 1 2 3 4 5)))
        (require (distinct? (list baker cooper fletcher)))
        (let ((miller (amb 1 2 3 4 5)))
          (require (distinct? (list baker cooper fletcher miller)))
          (let ((smith (amb 1 2 3 4 5)))
            (require (distinct? (list baker cooper fletcher miller smith)))))))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))

(multiple-dwelling)

; This looks like it???
; Suspicious ...

        

; 2020-03-23 21:41 :: zenAndroid :: Eeeeehh ...

(load "00-AmbEval.scm")

(driver-loop)

(define (require p)
  (if (not p)
    (amb)))

(define (integer-between low high)
  (require (<= low high))
  (amb low (integer-between (+ low 1) high)))

(define (eight-queens)
  (let ((first-queen (list (integer-between 1 8) (integer-between 1 8)))
        (second-queen (list (integer-between 1 8) (integer-between 1 8)))
        (third-queen (list (integer-between 1 8) (integer-between 1 8)))
        (fourth-queen (list (integer-between 1 8) (integer-between 1 8)))
        (fifth-queen (list (integer-between 1 8) (integer-between 1 8)))
        (sixth-queen (list (integer-between 1 8) (integer-between 1 8)))
        (seventh-queen (list (integer-between 1 8) (integer-between 1 8)))
        (eigth-queen (list (integer-between 1 8) (integer-between 1 8))))
    (require (nice-queens? (list first-queen second-queen third-queen fourth-queen
                                 fifth-queen sixth-queen seventh-queen eigth-queen)))
    (list (list 'first-queen first-queen)
          (list 'second-queen second-queen)
          (list 'third-queen third-queen)
          (list 'fourth-queen fourth-queen)
          (list 'fifth-queen fifth-queen)
          (list 'sixth-queen sixth-queen)
          (list 'seventh-queen seventh-queen)
          (list 'eigth-queen eigth-queen))))

; Idk, this should be it ?
; Haven't tested it yet mainly cuz I didn't develop the rest of the functions ... yet ...
; Funny realization, this is stratified design lol

(define (nice-queens? items)
  (define (safe-q q roq)
    (cond ((null? roq) true)
          ((null? (cdr roq)) true)
          (else (if (not (= (car q) (caar roq)))
                  (if (not (= (cadr q) (cadar roq)))
                    (if (not (= (+ (car q) (caar roq)) (+ (cadr q) (cadar roq))))
                      true))
                  false))))
  (cond ((null? items) true)
        (else (if (safe-q (car items) (cdr items))
                (if (nice-queens? (cdr items))
                  true)))))

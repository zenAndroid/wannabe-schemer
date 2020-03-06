# 2020-03-05 23:01 :: zenAndroid :: Good nnight now

(define retval
  (list 'let (map (lambda(x) (list x ''*unassigned*)) (lr-vars test-exp))
        (cons 'begin (append (map (lambda(x) (append '(set!) x)) (lr-bd test-exp))
                             (lr-bod test-exp)))))

scheme@(guile-user) [1]> (pretty-print retval )
(let ((u '*unassigned*)
      (v '*unassigned*)
      (w '*unassigned*))
  (begin
    (set! u (S_EXP1))
    (set! v (S_EXP2))
    (set! w 4)
    (display "yeet")
    (u v w)))

; Seems to be allright, ... yeet

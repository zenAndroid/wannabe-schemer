; 2020-03-01 22:50 :: zenAndroid :: Yey, it's the halting problem \o/

; I don't really think it needs an explanation

;; (define (loop) (loop))
;; 
;; (define (try p)
;;   (if (halts? p p) ; halts? determaines if the first argument (which is a function) halts on the second argument
;;     (loop)
;;     'halted))
;; 
;; Doing (try try), tests to see if (try try) halts or not.
;; 
;; If it DOES halt, then by definition (of its function description) it''ll call (loop), which ... loops foreveer ??? *Huh*.
;; 
;; If it DOES NOT halt, then by definition, it'll .... return 'halted ??
;; 
;; Both cases lead to a logical impossibility, thus there is no silution to this problem.

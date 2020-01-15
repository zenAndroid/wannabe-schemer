;(define (subsets s)
;  (if (null? s)
;    (list (list))
;    (let ((rest (subsets (cdr s))))
;      (append rest (map ?? rest)))))

; subset of (2 3)
; () (2) (3) (2 3)
; the final result of powersetting (1 2 3) is
; () (1) (2) (3) (1 2) (1 3) (2 3) (1 2 3)
; So the stuff that should be appended to the power set of (2 3) is
; (1) (1 2) (1 3) (1 2 3)
; :thinking:
; Ah, ok, i see, every time we add the (car s) to every element of the powerset of the subset
; ie
;  take () (2) (3) (2 3)
; in this case add 1 to the beginning of every element in there, so you end up with
; (1) (1 2) (1 3) (1 2 3)
; and that's what should be appended to the `rest`, to have the final result

(define (subsets s)
  (if (null? s)
    (list (list))
    (let ((rest (subsets (cdr s))))
      (append rest (map (lambda(x) (append (list (car s)) x)) rest)))))

(length (subsets (list 1 2 4 5 6 7 8 9 10 3))) ; => 1024

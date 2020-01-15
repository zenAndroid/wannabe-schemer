; Define a procedure last-pair that returns the list that contains only the last element of a given (nonempty) list:
;
;(last-pair (list 23 72 149 34))
;(34)
; Testing web-based git
; Testing CLI git


(define (last-pair aList)
    (if (= (length aList) 1)
        (car aList)
        (last-pair (cdr aList))))

(last-pair (list (cons 3 4) (cons 22 44) (cons "foo" "bar")))


; '("foo" . "bar")

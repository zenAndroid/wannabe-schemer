(define (oddOnesOut aList) ; To "filter" the even numbers and only have the odd ones
    (cond ((null? aList) (list))
          ((odd? (car aList)) (cons (car aList) (oddOnesOut (cdr aList))))
          (else (oddOnesOut (cdr aList)))))

(define (evenOnesOut aList); To "filter" the odd numbers and only have the even ones
    (cond ((null? aList) (list))
          ((even? (car aList)) (cons (car aList) (evenOnesOut (cdr aList))))
          (else (evenOnesOut (cdr aList)))))


(define integers (list 1 2 3 4 5 6 7 8 9 11 -1 2 23 -7 -6))
(oddOnesOut integers)
(evenOnesOut integers)


; And now that we have the "filters" the definition is v v easy

(define (sameparity . w)
    (cond ((null? w) w)
          ((odd? (car w)) (oddOnesOut w))
          ((even? (car w)) (evenOnesOut w))))


(sameparity 1 2 3 4 5 6)
(sameparity )
(sameparity 2 1 2 3 4 5 6 7 8 9 10)

;> (define integers (list 1 2 3 4 5 6 7 8 9 11 -1 2 23 -7 -6))
;> (oddOnesOut integers)
;(1 3 5 7 9 11 -1 23 -7)
;> (evenOnesOut integers)
;(2 4 6 8 2 -6)
;> (sameparity 1 2 3 4 5 6)
;(1 3 5)
;> (sameparity )
;()
;> (sameparity 2 1 2 3 4 5 6 7 8 9 10)
;(2 2 4 6 8 10)

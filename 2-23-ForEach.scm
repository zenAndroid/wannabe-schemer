(define (foreach f aList)
  (map f aList))

(for-each 
 (lambda (x) (newline) (display x))
 (list 57 321 88))

; Gives expected output, hopefully no confirmation bias here

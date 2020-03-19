; 2020-03-18 14:39 :: zenAndroid :: Non-deterministic computing here we go.

; Exercise 4.35: Write a procedure an-integer-between that returns an integer
; between two given bounds. This can be used to implement a procedure that
; finds Pythagorean triples, i.e., triples of integers ( i , j , k ) between
; the given bounds such that i ≤ j and i 2 + j 2 = k 2 , as follows:
; 
; (define (a-pythagorean-triple-between low high)
;   (let ((i (an-integer-between low high)))
;     (let ((j (an-integer-between i high)))
;       (let ((k (an-integer-between j high)))
;         (require (= (+ (* i i) (* j j)) 
;                     (* k k)))
;         (list i j k)))))

(define (an-integer-between low high)
  (require (<= low high))
  (amb low (an-integer-between (+ low 1) high)))

; My first version was basically the correct one, the only difference was that
; I forgot that require existed and explicitly decrred that if low is higher
; that high then the function ought to return (amb)

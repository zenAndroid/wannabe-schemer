# 2020-03-18 21:52 :: zenAndroid :: My intuition says yes, but lets see ...

; Exercise 4.39: Does the order of the restrictions in the multiple-dwelling
; procedure affect the answer? Does it affect the time to find an answer? If
; you think it matters, demonstrate a faster program obtained from the given
; one by reordering the restrictions. If you think it does not matter, argue
; your case.

;;;  Theory:
;;;  
;;;  Re-arranging the requirements DOES have an effect.
;;;  
;;;  Elaboration:
;;;  
;;;  So in the procedure, we have 
;;;  
;;;  (baker (amb 1 2 3 4 5))
;;;  (cooper (amb 1 2 3 4 5))
;;;  (fletcher (amb 1 2 3 4 5))
;;;  (miller (amb 1 2 3 4 5))
;;;  (smith (amb 1 2 3 4 5))
;;;  
;;;  As the order of 'variable' 'declarations', an then we start writing
;;;  requirements in the order thhey were specified in the textual version of
;;;  the riddle, iE:
;;;  
;;;  (require (distinct? (list baker cooper fletcher miller smith)))
;;;  (require (not (= baker 5)))
;;;  (require (not (= cooper 1)))
;;;  (require (not (= fletcher 5)))
;;;  (require (not (= fletcher 1)))
;;;  (require (> miller cooper))
;;;  
;;;  SO, consider the behavior of this spell at spell invocation time:
;;;  
;;;  Given the behavior of the amb form,
;;;  baker will take 1
;;;  cooper will take 1
;;;  fletcher will take 1
;;;  miller will take 1
;;;  smith will take 1
;;;  
;;;  The first requirement is met, it leads to a termination of the 'timeline'
;;;  smith will take 2
;;;  The requirement is still not met
;;;  smith will take 3, and so on.
;;;  Ahhhh, I'm not sure how to explain this ....
;;;  Something feels awfully inefficient about this, because smith will have to
;;;  go through all those 5 floors, then it will 'propagate' to miller, who
;;;  will also, propagate the previous people, then cooper will get 2, and this
;;;  entire circus will begin anew because now fletcher, miller and smith will
;;;  get 1, and this will continue until it stabilizes for the first time at 1,
;;;  2, 3, 4, 5.
;;;  
;;;  I don't know about you, but this seems like heck
;;;  
;;;  It seems to me, and I'm not actually sure on this, but I think rearranging
;;;  the requirements such that they test the later people first would be a
;;;  better idea?
;;;  
;;;  Not sure though.
;;;  
;;;  So something like:
;;;  
;;;  (require (> miller cooper))                                  (baker (amb 1 2 3 4 5))
;;;  (require (not (= fletcher 1)))                               (cooper (amb 1 2 3 4 5))     
;;;  (require (not (= fletcher 5)))                               (fletcher (amb 1 2 3 4 5))   
;;;  (require (not (= cooper 1)))                                 (miller (amb 1 2 3 4 5))   
;;;  (require (not (= baker 5)))                                  (smith (amb 1 2 3 4 5))
;;;  (require (distinct? (list baker cooper fletcher miller smith))
;;;  
;;;  
;;;  Not sure anymore, I think the same number of 'iterations' will take place ?
;;;  
;;;  Am I overthinking this ?
;;;  I'm overthinking this aren't I?
;;;  
;;;  
;;;  Hmm, I suppose a more rigorous way of putting it would be ...
;;;  
;;;  If requirement A DEPENDS on requirement B then it should come before it??
;;;  If requirement A IMPLIES requirement B then it should come before it??
;;;  
;;;  Dunno if this is correct, but I spent enough time on this, maybe I should
;;;  check the solutions now?
;;;  
;;;  I think I'll do it tomorrow. Maybe my subconscious will figure out
;;;  something interesting ¯\_(ツ)_/¯


; 2020-03-22 16:49 :: zenAndroid :: Hey, so, it turns I had the correct
; intuition, but a far better way to put would be that in this example, if you
; put the distinctness requirement down then it will get called less often
; since a lot of the attempts will be gleaned off by other,
; less-computationnaly intensive requirements (See Eli's explanation which
; helped me Formulate this)

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
  (let ((baker (amb 1 2 3 4))
        (cooper (amb 2 3 4 5))
        (fletcher (amb 2 3 4))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require (> miller cooper))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (distinct? (list baker cooper fletcher miller smith)))
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))

(multiple-dwelling)

try-again


; Yeah it has a bunch other solutions ...

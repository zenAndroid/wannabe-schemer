;; Meh, i disagree with the footnote i think.
;; It hurts readability if it's always like that.
;; 
;; Though i admit that sometimes it *is* nicer to write things out like that ...
;; 
;; 
;; Also, btw,, i didnt really waste my time eith the exercises since i suspected
;; it's just raw going to be co;pletely analogous, so i didnt bother.
;; 
;; I will admit that c-'s implementation caught me off gard since i keep
;; forgetting that i can take the constraint as input and build a constraint
;; specifying the input one as output ...
;; 
;; I suspect that i may forget what this means if i read it later ...
;; 
;; For instance, stuff like the following definiton is what intuitively comes to
;; mind
;; 
;; (define (c+ x y)
;;    (let ((z (make-connector)))
;;      (adder x y z)
;;      z))
;; 
;; You get two input constraints, you shove them in some constraint box, and you
;; return the outgoing connector as a retval (return value)
;; 
;; 
;; However, that is not necessarily a rule or anything, as showcased by the next case.
;; 
;; (define (c- x y)
;;   (let ((z (make-connector)))
;;     (adder z y x)
;;     z))
;; 
;; You do get x and y asinputsm but you shove them in the constraint box not
;; necessarily as both inputs.
;; 
;; Here is how to parse this: (c- x y) is supposed to return an output that
;; satisfies (z is the output here): x-y=z we can "only" use he adder constraint,
;; so we have to find an equivalent way of saying x-y=z and with the help of some
;; basic mathematics : x-y=z => -y-z = -x => y+z=x And so we encode x-y=z as the
;; different BUT EQUIVALENT y+z=x, and in our language, we describe y+z=x as the
;; (adder y z x)/(adder z y x) constraint and thus the definition body above.
;; 
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This one is straight forward
;; (define (c* x y)
;;   (let ((z (make-connector)))
;;     (multiplier x y z)
;;     z))
;; 
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Same reasoning as the spooky one above
;; (define (c/ x y)
;;   (let ((z (make-connector)))
;;     (multiplier z y x)
;;     z))
;; 
;; 

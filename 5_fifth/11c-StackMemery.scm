(load "ch5-regsim.scm")

'(LOADED BASIC REGISTER SIMULATOR)

;; I've decided not to do this exercise, because I think it is largely going to be a waste of time.
;; Here is my reasoning:
;; 1- It will take me a lot of fiddling around just to get things working: iE
;; - fiddle with make-register
;; - fiddle with corresponding execution procedures (make-save and make-restor)
;; - fiddle with make-machine
;; - fiddle with a whole lotta other unknowns
;; 
;; Now, this would be fine, if this carries over, but the problem is that just the next section we basically go into parametrizing the MACHINE STACK, with NO care for individual register stacks, and so, it feels like this is going to be an expensive, but possibly pointless endeavor.
;; 
;; Could be wrong though, I guess.




;; And to be honest, I don't even know what will happen if I apply this same reasoning to the next exercises, however at least I think the next couple should be quite interesting.

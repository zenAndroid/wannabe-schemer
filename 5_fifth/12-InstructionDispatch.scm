;; The controller test is the list of instructions.

What I want: A function to scan a this list of instruction and deal with each one accordingly.
(define (scan-insts insts)
  (define (scan-helper insts accumulator)
    (if (null? insts)
      accumulator
      ;; Do stuff
      ))
  

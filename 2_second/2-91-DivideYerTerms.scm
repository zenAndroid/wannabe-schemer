#!/usr/bin/racket -f
(require racket/include)
(require racket/trace)



(include "2-88-NegateYerTerms.scm")

(define (div-terms L1 L2)
  (if (empty-term-list? L1)
      (list (the-empty-termlist) 
            (the-empty-termlist))
      (let ((t1 (first-term L1))
            (t2 (first-term L2)))
        (if (> (order t2) (order t1))
            (list (the-empty-termlist) L1)
            (let ((new-c (div (coeff t1) 
                              (coeff t2)))
                  (new-o (- (order t1) 
                            (order t2))))
              (let ((rest-of-result
                     ;⟨compute rest of result 
                     ;recursively⟩ ))
                ;⟨form complete result⟩ ))))))

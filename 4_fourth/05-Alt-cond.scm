; 2020-02-27 14:35 :: zenAndroid ::  I am realizing that I am going slowly through this, wonder if what I am doing is optimal or not ...

; The alternate form of the cond clause is the following
; 
; (<test> => <recipient>)
; 
; I'm an idiot sometimes.
; 
; Anyways, so at first I kept forgetting that I'm *programmaticaly writing code* and so I was trying to produce evals and applys withing the code but that wasn't it.
; 
; Anyways.
; 
; So, Zen, next time, reason like this:
; 
; The code (<test> => <recipient>) produces this (if test (recipient test)), so
; 
; in the cond->if this needs a couple of things:
; 
; 1. a way to detect this form.
; 2. a way to extract the components.
; 3. a way to generate the necessary code.
; 
; point 1:

(define (alt-cond-clause? clause)
  (and (list? clause)
       (eq? (length clause) 3)
       (eq? (cadr clause '=>))))

; point 2.

(define (alt-cond-clause-test clause)
  (car clause))

(define (alt-cond-clause-recipient clause)
  (caddr clause))

; point 3.

(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

; (define (expand-clauses clauses)
;   (if (null? clauses)
;     'false     ; no else clause
;     (let ((first (car clauses))
;           (rest (cdr clauses)))
;       (if (cond-else-clause? first)
;         (if (null? rest)
;           (sequence->exp (cond-actions first))
;           (error "ELSE clause isn't last: COND->IF" clauses))
;       (make-if (cond-predicate first)
;                (sequence->exp (cond-actions first))
;                (expand-clauses rest))))))

(define (expand-clauses clauses)
  (if (null? clauses)
    'false     ; no else clause
    (let ((first (car clauses))
          (rest (cdr clauses)))
      (if (cond-else-clause? first)
        (if (null? rest)
          (sequence->exp (cond-actions first))
          (error "ELSE clause isn't last: COND->IF" clauses))
        (if (alt-cond-clause? first)
          (make-if (alt-cond-clause-test first)
                   (list
                     (alt-cond-clause-recipient first)
                     (alt-cond-clause-test first))
                   (expand-clauses rest)))
      (make-if (cond-predicate first)
               (sequence->exp (cond-actions first))
               (expand-clauses rest))))))

; That should be it, ... Eli used cond to avoid those ugly nested ifs, but I
; didn't do it because using cond while evaluating cond doesnt let me know what's
; going on under the hood.
; Also, looking at Common Lisp code, that stuff looks ugly as heck man ... holy
; hell

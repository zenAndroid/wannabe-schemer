; 2020-02-29 17:09 :: zenAndroid :: Oh yeah had the impulse to this on my own lol


(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals);{{{
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (car vals))
            (else (scan (cdr vars) (cdr vals)))));}}}
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals);{{{
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))));}}}
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (define-variable! var val env)
    (define (scan vars vals);{{{
      (cond ((null? vars)
             (add-binding-to-frame! var val (first-frame env)))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))));}}}
    (scan (frame-variables (first-frame env))
          (frame-values (first-frame env)))))


; I now realize that I havent captured this specific abstraction
; ... rip
(define (abstract-scanner BASE-CASE MATCH-CASE)
  (define (scan vars vals)
    (cond ((null? vars) (BASE-CASE))
          ((eq? var (car vars)) (MATCH-CASE))
          (else (scan (cdr vars) (cdr vals)))))
  scan)

; Now, to REDO the abstraction of envloop

(define (env-loop env BASE-CASE MATCH-CASE)
  (define scan (abstract-scanner BASE-CASE MATCH-CASE))
  (if (eq? env the-empty-environment)
    (error "Unbound variable" var) 
    ; var is unbound now, but it *SHOULD* be 
    ; bound when this function will execute
    (let ((frame (first-frame env)))
      (scan (frame-variables frame)
            (frame-values frame)))))

Re-read that comment for it is crucial.

So this should make the definitions for the three othe function something like ...

(define (lookup-variable-value var env)
  (define base-case (lambda () (env-loop (enclosing-environment env))))
  (define match-case (lambda () (car vals)))
  (env-loop env base-case match-case))

(define (set-variable-value! var val env)
  (define base-case  (lambda () (env-loop (enclosing-environment env))))
  (define match-case (lambda () (set-car! vals val))
  (env-loop env base-case match-case))

(define (define-variable! var val env)
  (define base-case  (lambda () (add-binding-to-frame! var val (first-frame env))))
  (define match-case (lambda () (set-car! vals val)))
  ((abstract-scanner base-case match-case)
   (frame-variables (first-frame env))
   (frame-values (first-frame env))))

; There's something to note here, it's quite subtle, but still,
; *applicative order is at odds with this style of definition*, because 
; the Right-Hand-Side of define is going to get evaluated instantly, and envloop is not defined, nor is env, etc .., so I am going tto make it into the body of a lambda expression

; 2020-02-29 17:09 :: zenAndroid :: Oh yeah had the impulse to di this on my own lol


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


What they all have in common ...

(define (scan vars vals)
  (cond ((null? vars) <some action>)
        ((eq? var (car vars)) <some action>)
        (else (scan (cdr vars) (cdr vars)))))

; I *think* the more general solution is this

(define (scan vars vals null-action eq-action)
  (cond ((null? vars) (null-action))
        ((eq? var (car vars)) (eq-action))
        (else (scan (cdr vars) (cdr vars)))))

; ---------------------------------------------

(define (env-loop env)
  <scan-variant-definition>
  (if (eq? env the-empty-environment)
    (error "Unbound variable" var)
    (let ((frame (first-frame env)))
      (scan (frame-variables frame)
            (frame-values frame)))))

; I *think* the more general solution is this
; Env-loop needs to instantiate a specific variant of scan
; So env-loop will have to get at least two new parameters to specify the
; scan variant I think

(define (env-loop env scan-null scan-eq)
  (let ((scan-proc (scan vars vals scan-null scan-eq)))
    (if (eq? env the-empty-environment)
      (error "Unbound variable" var)
      (let ((frame (first-frame env)))
        (scan-proc (frame-variables frame)
                   (frame-values frame))))))

In the set-variable-value! procedure for instance:

(define (the-procedure var val env) ; Same input variables
  (let ((scan-null (lambda() (SOMEFUNCTION (enclosing-environment env))))
        (scan-eq (lambda() (set-car! vals val))))
    (define (env-loop env)
      (define (


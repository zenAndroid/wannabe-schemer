; 2020-02-27 21:03 :: zenAndroid :: ... I am ... yikes at this point I am
; officially even worse than Dragon God ...

; (let* <bindings> <body>)

(define (bindings exp) (cadr exp))

(define (let*-body exp) (cddr exp))

(define (first-binding bindings) (car bindings))

(define (rest-bindings bindings) (cdr bindings))

(define (make-let bindings body) (list 'let bindings body))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (let*->nested-lets exp)
  ; 2020-02-28 18:50 :: zenAndroid ::I don't even remember clearly my thought process at the time, hopefully my notes are clear enough :sweat:
  (define (iter bindings)
    (if (null? bindings)
      (sequence->exp (let*-body exp))
      (make-let (list (first-binding bindings))
                (iter (rest-bindings bindings)))))
  (iter (bindings exp)))

(define foo
  `(let*
     ((a 5)
      (b a)
      (c b))
     (foo) (bar) (baz)))

; scheme@(guile-user)> (define foo
; ...   `(let*
; ...      ((a 5)
; ...       (b a)
; ...       (c b))
; ...      (foo) (bar) (baz)))
; scheme@(guile-user)> (let*->nested-lets foo)
; $1 = (let ((a 5)) (let ((b a)) (let ((c b)) (begin (foo) (bar) (baz)))))
; scheme@(guile-user)> (use-modules (ice-9 pretty-print))
; scheme@(guile-user)> (pretty-print(let*->nested-lets foo))
; (let ((a 5))
;   (let ((b a))
;     (let ((c b)) (begin (foo) (bar) (baz)))))

; Seems to be working correctly, yey

; 2020-03-04 18:05 :: zenAndroid :: Hello

(load "09-WhileUntil.scm")

(define (not-define? exp) (not (definition? exp)))

(define (actual-body exp) (filter not-define? exp))

(define (scan-out-defines exp) (filter definition? exp))

(define (remove-defines exp) (map cdr exp))

(define (inner-vars exp) (map car exp))

(define (inner-exps exp) (map cadr exp))

(define (inner-definitions-handler exp) ; Wher exp is the body
  (let* ((lists-of-interest (scan-out-defines exp))
         (body-exps (actual-body exp))
         (assoc-list (remove-defines lists-of-interest))
         (vars (inner-vars assoc-list))
         (exps (inner-exps assoc-list)))
    (list 'let
          (map (lambda(x) (list x '*unassigned*)) vars)
          (sequence->exp (map (lambda(x) (append '(set!) x)) assoc-list))
          (sequence->exp body-exps))))

; There goes, the first prototype, I am confused as to whether, for example,
; when I run (remove-defines X) and I get ((u <E>) (v <E>)) I wonder, should I
; quote that and all of it will be included ? or should I map something ??
; For instance this code right here 
; (map (lambda(x) (list x '*unassigned*)) vars)
; Any ways I don't know how to explain this and in any case it doesnt matter
; since I'll try to elucidate any confusion by running this code and then
; coming back here and commenting profusely

(pretty-print (inner-definitions-handler '((define u (+ x 2)) (define v (+ n n2)) (define reee (* 3 f F)) (displayln (* v v v reee reee)))))


; (let (((u *unassigned*)
;        (v *unassigned*)
;        (reee *unassigned*)))
;   ((set! u (+ x 2))
;    (set! v (+ n n2))
;    (set! reee (* 3 f F)))
;   ((displayln (* v v v reee reee))))

; Result of running it, I hope I learn from this.


; (let ((u *unassigned*)
;       (v *unassigned*)
;       (reee *unassigned*))
;   (begin
;     (set! u (+ x 2))
;     (set! v (+ n n2))
;     (set! reee (* 3 f F)))
;   (displayln (* v v v reee reee)))

; 2nd attempt, good, it is improvement, altho I would prefer if I found a way
; without having to use (begin ...), but I suppose improvement are slow and
; incremental ...

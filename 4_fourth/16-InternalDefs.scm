; 2020-03-04 18:05 :: zenAndroid :: Hello

(load "09-WhileUntil.scm")

(define (not-define? exp) (not (definition? exp)))

(define (actual-body exp) (filter not-define? exp))

(define (only-defines exp) (filter definition? exp))

(define (inner-vars exp) (map definition-variable exp))

(define (inner-exps exp) (map definition-value exp))

(define (scan-out-defines exp) ; Wher exp is the body
  (if (null? (only-defines exp))
    exp
    (let* ((lists-of-interest (only-defines exp))
           ; ((define u <>)
           ;  (define v <>))
           (body-exps (actual-body exp))
           ; Whatever else (<E3>)
           (vars (inner-vars lists-of-interest))
           (exps (inner-exps lists-of-interest)))
      (append 
        (list 'let (map (lambda(x) (list x ''*unassigned*)) vars))
        (make-assignements lists-of-interest)
        body-exps))))

(define (make-assignements defs)
  (map
    (lambda(def) (list 'set! (definition-variable def) (definition-value def)))
    defs))


; There goes, the first prototype, I am confused as to whether, for example,
; when I run (remove-defines X) and I get ((u <E>) (v <E>)) I wonder, should I
; quote that and all of it will be included ? or should I map something ??
; For instance this code right here 
; (map (lambda(x) (list x '*unassigned*)) vars)
; Any ways I don't know how to explain this and in any case it doesnt matter
; since I'll try to elucidate any confusion by running this code and then
; coming back here and commenting profusely

(pretty-print 
  (scan-out-defines 
    '((define u (+ x 2)) 
      (define v (+ n n2)) 
      (define reee (* 3 f F)) 
      (displayln (* v v v reee reee)))))

(display "\n")

(pretty-print 
  (scan-out-defines 
    '((displayln (* v v v reee reee)))))


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

; 3rd attempt, I am pleased with this.

; 2020-03-04 21:47 :: zenAndroid :: HAHAHAH, I was thinking of making the
; definition of the helper functions internal, but then I decided against that
; because it would be too funny.

(define (make-procedure parameters body env)
  (list 'procedure 
        parameters 
        (scan-out-defines body)
        env))

(load "ch5-regsim.scm")

(define (make-register name)
  (let ((contents '*unassigned*) (reg-name name))
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'name) reg-name)
            ((eq? message 'set)
             (lambda (value) (set! contents value)))
            (else
             (error "Unknown request -- REGISTER" message))))
    dispatch))

(define (make-stack)
  (let ((s '()))
    (define (push x)
      (set! s (cons x s)))
    (define (peek)
      (if (null? s)
          (error "Empty stack -- POP")
          (car s)))
    (define (pop)
      (if (null? s)
          (error "Empty stack -- POP")
          (let ((top (car s)))
            (set! s (cdr s))
            top)))
    (define (initialize)
      (set! s '())
      'done)
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) (pop))
            ((eq? message 'peek) (peek))
            ((eq? message 'initialize) (initialize))
            (else (error "Unknown request -- STACK"
                         message))))
    dispatch))

;; zenAndroid :: when pushing the pair in the stack, helps to save the register's name.

(define (get-reg-name register)
  (register 'name))

;; zenAndroid :: Should be obvious what this is for.

(define (peek stack)
  (stack 'peek))

;; zenAndroid :: I feel this is going to be where the main trick/shtick is going to happen.

(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (lambda () ;; zenAndroid :: Here goes, instead of pushing the content alone
               ;; I will push the name as well, and cons the two together.
               ;; So the stack thingies are composed like this: <reg-name,reg-content>
      (push stack (cons (get-reg-name reg) (get-contents reg)))
      (advance-pc pc))))

;; So, to restore register y, I will first 
;; 1 - peek to see if the topmost frame is reserved for register y.
;; 2 - Assuming so, all goes without any further problems
;; 3 - Else, I throw an error.

;; Question remains, ....
;; Assembly time, or simulation time?

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    (let ((reg-name (get-reg-name reg)))
      (lambda()
        (let ((reg-at-top-of-stack (car (peek stack))))
          (if (eq? reg-name reg-at-top-of-stack)
            (begin
              (set-contents! reg (cdr (pop stack)))
              (advance-pc pc))
            (error "Stack top not conforming to the request -- MAKE-RESTORE" 
                   (list reg-name reg-at-top-of-stack))))))))

(define mach
  (make-machine
    '(x y)
    (list (list '* *) (list '- -) (list '= =))
    '(
      (assign x (const 5))
      (assign y (const 1))
      (save x)
      (save y)
      (restore y)
      )))

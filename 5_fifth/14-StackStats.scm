(load "13-RegisterDetermination.scm")

;; And then I'll simply change make-stack, I'm not doing anuthing by the way, this was
;; provided by the book.


(define (make-stack);{{{
  (let ((s '())
        (number-pushes 0)
        (max-depth 0)
        (current-depth 0))
    (define (push x)
      (set! s (cons x s))
      (set! number-pushes (+ 1 number-pushes))
      (set! current-depth (+ 1 current-depth))
      (set! max-depth (max current-depth max-depth)))
    (define (pop)
      (if (null? s)
          (error "Empty stack -- POP")
          (let ((top (car s)))
            (set! s (cdr s))
            (set! current-depth (- current-depth 1))
            top)))    
    (define (initialize)
      (set! s '())
      (set! number-pushes 0)
      (set! max-depth 0)
      (set! current-depth 0)
      'done)
    (define (print-statistics)
      (newline)
      (display (list 'total-pushes  '= number-pushes
                     'maximum-depth '= max-depth))
      (newline))
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) (pop))
            ((eq? message 'initialize) (initialize))
            ((eq? message 'print-statistics)
             (print-statistics))
            (else
             (error "Unknown request -- STACK" message))))
    dispatch));}}}

(define fib-machine ;{{{
  (make-machine ;register-names ops controller-text 
    (list (list '< <) (list '- -) (list '+ +)) 
    '(  ; from ch5.scm 
        (assign continue (label fib-done)) 
        fib-loop 
        (test (op <) (reg n) (const 2)) 
        (branch (label immediate-answer)) 
        ;; set up to compute Fib(n-1) 
        (save continue) 
        (assign continue (label afterfib-n-1)) 
        (save n)                           ; save old value of n 
        (assign n (op -) (reg n) (const 1)); clobber n to n-1 
        (goto (label fib-loop))            ; perform recursive call 
        afterfib-n-1                         ; upon return, val contains Fib(n-1) 
        (restore n) 
        (restore continue) 
        ;; set up to compute Fib(n-2) 
        (assign n (op -) (reg n) (const 2)) 
        (save continue) 
        (assign continue (label afterfib-n-2)) 
        (save val)                         ; save Fib(n-1) 
        (goto (label fib-loop)) 
        afterfib-n-2                         ; upon return, val contains Fib(n-2) 
        (assign n (reg val))               ; n now contains Fib(n-2) 
        (restore val)                      ; val now contains Fib(n-1) 
        (restore continue) 
        (assign val                        ; Fib(n-1)+Fib(n-2) 
                (op +) (reg val) (reg n))  
        (goto (reg continue))              ; return to caller, answer is in val 
        immediate-answer 
        (assign val (reg n))               ; base case: Fib(n)=n 
        (goto (reg continue)) 
        fib-done
        (perform (op print-stack-statistics))
        (perform (op initialize-stack)))));}}}

(define fact-machine ;{{{
  (make-machine 
    (list (list '- -) (list '* *) (list '+ +) (list '= =))
    '( (assign continue (label fact-done))     ; set up final return address
      fact-loop
      (test (op =) (reg n) (const 1))
      (branch (label base-case))
      ;; Set up for the recursive call by saving n and continue.
      ;; Set up continue so that the computation will continue
      ;; at after-fact when the subroutine returns.
      (save continue)
      (save n)
      (assign n (op -) (reg n) (const 1))
      (assign continue (label after-fact))
      (goto (label fact-loop))
      after-fact
      (restore n)
      (restore continue)
      (assign val (op *) (reg n) (reg val))   ; val now contains n(n-1)!
      (goto (reg continue))                   ; return to caller
      base-case
      (assign val (const 1))                  ; base case: 1!=1
      (goto (reg continue))                   ; return to caller
      fact-done
      (perform (op print-stack-statistics))
      (perform (op initialize-stack)))));}}}

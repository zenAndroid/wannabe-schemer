(load "13-RegisterDetermination.scm")

;; And then I'll simply change make-stack, I'm not doing anything by the way, this was
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

(define (make-new-machine);{{{
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
        (instruction-count 0)
        (entry-regs '())
        (stack-regs '())
        (sorted-instructions '())
        (reg-sources (make-hash-table)))
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))
                 ;;**next for monitored stack (as in section 5.2.4)
                 ;;  -- comment out if not wanted
                 (list 'print-stack-statistics
                       (lambda () (stack 'print-statistics)))))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name)
        (if (assoc name register-table)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated)
      (define (lookup-register name);{{{
        (let ((val (assoc name register-table)))
          (if val
              (cadr val)
              (error "Unknown register:" name))));}}}
      (define (execute);{{{
        (let ((insts (get-contents pc)))
          (if (null? insts)
              (begin (stack 'print-statistics)
                     (stack 'initialize)
                     'done)
              (begin
                (set! instruction-count (+ instruction-count 1)); Counting this instruction
                ((instruction-execution-proc (car insts)))
                (execute)))));}}}
      (define (dispatch message);{{{
        (case message
          ((start) (set! instruction-count 0); Initializing the instruction-count at the beginning of an execution.
                   (set-contents! pc the-instruction-sequence)
                   (execute))
          ((install-instruction-sequence)
           (lambda (seq) (set! the-instruction-sequence seq)))
          ((allocate-register) allocate-register)
          ((get-register) lookup-register)
          ((install-operations) 
           (lambda (ops) (set! the-ops (append the-ops ops))))
          ((stack) stack)
          ((install-instruction-scan-results) 
           (lambda(arg-list) (set! sorted-instructions (car arg-list))
                             (set! entry-regs (cadr arg-list))
                             (set! stack-regs (caddr arg-list))))
          ((operations) the-ops)
          ((reg-source) reg-sources)
          ((get-sorted-insts) sorted-instructions)
          ((show-inst-scan) (pretty-print (list "Sorted Instructions: " sorted-instructions
                                                "Entry point registers: " entry-regs
                                                "Stack-interacting registers: " stack-regs
                                                "Register sources: " (hash-fold
                                                                       (lambda(k v p)
                                                                         (cons (list k v) p))
                                                                       '() reg-sources))))
          ((print-instruction-count) instruction-count); Access to instruction-count
          ((reset-instruction-count) (set! instruction-count 0)); Explicitly resetting the instruction count (not needed per se)
          (else (error "Unknown request -- MACHINE" message))));}}}
      dispatch)));}}}

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
      fact-done)));}}}

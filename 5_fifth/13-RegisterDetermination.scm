(load "12-InstScanner.scm")

(define (make-machine ops controller-text);{{{
  (let ((machine (make-new-machine)))
    (let ((raw-insts (filter (lambda(arg) (not (symbol? arg))) controller-text)))
      (let ((assign-insts (filter (lambda(arg) (eq? (car arg) 'assign)) raw-insts)))
        (let ((register-list (delete-duplicates (map cadr assign-insts))))
          (for-each (lambda (register-name)
                      ((machine 'allocate-register) register-name))
                    register-list))))
    ((machine 'install-operations) ops)    
    ((machine 'install-instruction-sequence)
     (assemble controller-text machine))
    ((machine 'install-instruction-scan-results)
     (inst-scan controller-text (machine 'reg-source)))
    machine));}}}

(define (make-new-machine);{{{
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
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
              'done
              (begin
                ((instruction-execution-proc (car insts)))
                (execute)))));}}}
      (define (dispatch message);{{{
        (case message
          ((start) (set-contents! pc the-instruction-sequence)
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
          ((install-entries) (lambda (arg) (set! entry-regs arg)))
          ((install-stack-regs) (lambda (arg) (set! stack-regs arg)))
          ((install-sorted) (lambda (arg) (set! sorted-instructions arg)))
          ((show-inst-scan) (pretty-print (list "Sorted Instructions: " sorted-instructions
                                                "Entry point registers: " entry-regs
                                                "Stack-interacting registers: " stack-regs
                                                "Register sources: " (hash-fold
                                                                       (lambda(k v p)
                                                                         (cons (list k v) p))
                                                                       '() reg-sources))))
          (else (error "Unknown request -- MACHINE" message))));}}}
      dispatch)));}}}

(define fib-machine 
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
        fib-done)))

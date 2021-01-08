(load "ch5-regsim.scm")

(use-modules (ice-9 pretty-print)) ; Pretty printing
(use-modules (srfi srfi-1)) ; Remove duplicate
;; Nota bene: To make the changes required, I think I should:
;; 1 - Load the regular register simulator.
;; 2 - Override the make-machine procedure and make some modifications on it.
;; 3 - Namely, add the call to my instruction scanner, after installing the instruction sequence.
;; 4 - Still have to think about the details of how to handle the return and such.
;; 5 - Override the make-new-machine procedure and make some modifications on it.
;; 6 - A machine is going to have four new variables to hold the contents of scanning.
;; 7 - A machine is ALSO going to have a new dispatch message that it will respond to print out
;;     the scan results.

(define (inst-scan insts reg-source);{{{
  (define (insts->entry raw-insts);{{{
    (let* ((goto-insts (filter
                         (lambda(arg-inst)
                           (and (eq? (car arg-inst) 'goto)
                                (eq? (caadr arg-inst) 'reg)))
                         raw-insts)))
      (delete-duplicates (map cadadr goto-insts))));}}}
  (define (insts->stack-regs raw-insts);{{{
    (let* ((stack-insts (filter
                          (lambda (arg-inst)
                            (or (eq? (car arg-inst) 'save)
                                (eq? (car arg-inst) 'restore)))
                          raw-insts)))
      (delete-duplicates (map cadr stack-insts))));}}}
  (define (insts->reg-sources! raw-insts);{{{
    (hash-clear! reg-source)
    (let* ((assign-insts (delete-duplicates (filter 
                                              (lambda (arg-inst)
                                                (eq? (car arg-inst) 'assign))
                                              raw-insts))))
      (for-each (lambda(arg-inst) (let ((reg (cadr arg-inst))
                                        (source (cddr arg-inst)))
                                    (if (not (hashq-ref reg-source reg))
                                      (hashq-set! reg-source reg (list source))
                                      (hashq-set! reg-source
                                                  reg
                                                  (cons source
                                                        (hashq-ref reg-source
                                                                   reg))))))
                assign-insts)));}}}
  (define (insts->sorted raw-insts);{{{
    (delete-duplicates (sort raw-insts 
                             (lambda(inst inst2) (string< 
                                                   (symbol->string (car inst))
                                                   (symbol->string (car inst2)))))));}}}
    (let* ((raw-insts (filter (lambda (arg) (not (symbol? arg))) insts)))
      (insts->reg-sources! raw-insts)
      (list (insts->sorted raw-insts)
            (insts->entry raw-insts)
            (insts->stack-regs raw-insts))));}}}

(define (make-machine register-names ops controller-text);{{{
  (let ((machine (make-new-machine)))
    (for-each (lambda (register-name)
                ((machine 'allocate-register) register-name))
              register-names)
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
          ((start) ((set-contents! pc the-instruction-sequence)
                    (execute)))
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



(define expt-machine
  (make-machine
    '(n b val continue)
    (list (list '* *) (list '- -) (list '= =))
    '(
      (assign continue (label done))
      loop
      (test (op =) (reg n) (const 0))
      (branch (label base-case))
      (save continue)
      (assign continue (label after))
      (assign n (op -) (reg n) (const 1))
      (goto (label loop))
      after
      (restore continue)
      (assign val (op *) (reg val) (reg b))
      (goto (reg continue))
      base-case
      (assign val (const 1))   
      (goto (reg continue))
      done)))

(define fib-machine 
  (make-machine ;register-names ops controller-text 
    '(n val continue) 
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


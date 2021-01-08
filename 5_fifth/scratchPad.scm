(use-modules (ice-9 pretty-print)) ; Pretty printing
(use-modules (srfi srfi-1)) ; Remove duplicate
;{{{ Factorial machine
(define smh-im-hecking-tired 
  '((assign continue (label done))
    loop
    (test (op =) (reg n) (const 0))
    (branch (label base-case))
    (save continue)
    (assign continue (label after))
    (assign n (op -) (reg n) (const 1))
    (assign n (reg z))
    (goto (label loop))
    after
    (restore continue)
    (assign val (op *) (reg val) (reg b))
    (goto (reg continue))
    base-case
    (assign val (const 1))   
    (goto (reg continue))
    done));}}}
;{{{ Fibonacci machine
(define oh-man 
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
      fib-done));}}}

(define (inst-scan insts reg-source)
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
    (delete-duplicates (sort raw-insts (lambda(inst inst2) (string< 
                                                             (symbol->string (car inst))
                                                             (symbol->string (car inst2)))))));}}}
    (let* ((raw-insts (filter (lambda (arg) (not (symbol? arg))) insts)))
      (insts->reg-sources! raw-insts)
      (pretty-print (list "Sorted Instructions: " (insts->sorted raw-insts)
                          "Entry point registers: " (insts->entry raw-insts)
                          "Stack-interacting registers: " (insts->stack-regs raw-insts)
                          "Register sources: " (hash-fold
                                                 (lambda(k v p)
                                                   (cons (list k v) p))
                                                 '() reg-source)))))

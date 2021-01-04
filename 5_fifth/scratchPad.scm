(use-modules (ice-9 pretty-print))

(define smh-im-hecking-tired '(
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
                               done))


(define oh-man '(  ; from ch5.scm 
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
                   fib-done))

(define (register-exp? exp) (tagged-list? exp 'reg))

(define (register-exp-reg exp) (cadr exp))

(define (constant-exp? exp) (tagged-list? exp 'const))

(define (constant-exp-value exp) (cadr exp))

(define (label-exp? exp) (tagged-list? exp 'label))

(define (label-exp-label exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (stack-inst-reg-name stack-instruction)
  (cadr stack-instruction))

(define (goto-dest goto-instruction)
  (cadr goto-instruction))

(define (goto-reg-extract goto-dest)
  (cadr goto-dest))

(define (assign-reg-name assign-instruction)
  (cadr assign-instruction))

(define (assign-value-exp assign-instruction)
  (cddr assign-instruction))


(define (inst-scanner insts)

  (define sorted-instructions '())
  (define entry-points '())
  (define stack-relevant-registers '())
  (define reg-sources '())

  (define (zenAppend array element)
    (set! array (append array element)))

  (define (regSource-handler reg-name reg-source)
    (let ((val (assoc reg-name reg-sources)))
      (if val
        (append! val (list reg-source))
        (set! reg-sources (cons (cons reg-name (list reg-source)) reg-sources)))))

  (define (helper insts saved restored assigned gotoed tested branched performed)
    (if (null? insts)
      (begin (set! sorted-instructions (append! assigned saved restored gotoed tested branched performed))
             (list "Instructions: " sorted-instructions 
                   "Entry-points: " entry-points 
                   "Stack-Relevant: " stack-relevant-registers
                   "Register Assignement sources" reg-sources))
      (if (symbol? (car insts))
        ;; SKIP LABELS, THEY DONT *REALLY* AFFECT THE EXECUTION, (except they kinda d-)
        (helper (cdr insts) saved restored assigned gotoed tested branched performed)
        (let ((first-inst (car insts)))
          (cond ((eq? (car first-inst) 'save)
                 (begin (zenAppend stack-relevant-registers (list (stack-inst-reg-name first-inst)))
                        (helper (cdr insts) (append saved (list first-inst)) restored assigned gotoed tested branched performed)))
                ((eq? (car first-inst) 'restore)
                 (begin (zenAppend stack-relevant-registers (list (stack-inst-reg-name first-inst)))
                        (helper (cdr insts) saved (append restored (list first-inst)) assigned gotoed tested branched performed)))
                ((eq? (car first-inst) 'goto)
                 (begin (if (register-exp? (goto-dest first-inst)) (zenAppend entry-points (list (goto-reg-extract (goto-dest first-inst)))))
                        (helper (cdr insts) saved restored assigned (append gotoed (list first-inst)) tested branched performed)))
                ((eq? (car first-inst) 'test)
                 (helper (cdr insts) saved restored assigned gotoed (append tested (list first-inst)) branched performed))
                ((eq? (car first-inst) 'branch)
                 (helper (cdr insts) saved restored assigned gotoed tested (append branched (list first-inst)) performed))
                ((eq? (car first-inst) 'perform)
                 (helper (cdr insts) saved restored assigned gotoed tested branched (append performed (list first-inst))))
                ((eq? (car first-inst) 'assign)
                 (begin (let ((target-reg (assign-reg-name first-inst))
                              (reg-source (assign-value-exp first-inst)))
                          (regSource-handler target-reg reg-source))
                        (helper (cdr insts) saved restored (append assigned (list first-inst)) gotoed tested branched performed))))))))
  (helper insts '() '() '() '() '() '() '()))



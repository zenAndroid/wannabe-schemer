(use-modules (ice-9 pretty-print))
(use-modules (srfi srfi-1)) ; Remove duplicate

(define (get-contents register)
  (register 'get))

(define (set-contents! register value)
  ((register 'set) value))

(define (pop stack)
  (stack 'pop))

(define (push stack value)
  ((stack 'push) value))

(define (start machine)
  (machine 'start))

(define (get-register-contents machine register-name)
  (get-contents (get-register machine register-name)))

(define (set-register-contents! machine register-name value)
  (set-contents! (get-register machine register-name) value)
  'done)

(define (get-register machine reg-name)
  ((machine 'get-register) reg-name))

(define (assemble controller-text machine);{{{
  (extract-labels controller-text
    (lambda (insts labels)
      (update-insts! insts labels machine)
      insts)));}}}

(define (update-insts! insts labels machine);{{{
  (let ((pc (get-register machine 'pc))
        (flag (get-register machine 'flag))
        (stack (machine 'stack))
        (ops (machine 'operations)))
    (for-each
     (lambda (inst)
       (set-instruction-execution-proc! 
        inst
        (make-execution-procedure
         (instruction-text inst) labels machine
         pc flag stack ops)))
     insts)));}}}

(define (make-label-entry label-name insts)
  (cons label-name insts))

(define (lookup-label labels label-name)
  (let ((val (assoc label-name labels)))
    (if val
        (cdr val)
        (error "Undefined label -- ASSEMBLE" label-name))))


(define (make-execution-procedure inst labels machine;{{{
                                  pc flag stack ops)
  (cond ((eq? (car inst) 'assign)
         (make-assign inst machine labels ops pc))
        ((eq? (car inst) 'test)
         (make-test inst machine labels ops flag pc))
        ((eq? (car inst) 'branch)
         (make-branch inst machine labels flag pc))
        ((eq? (car inst) 'goto)
         (make-goto inst machine labels pc))
        ((eq? (car inst) 'save)
         (make-save inst machine stack pc))
        ((eq? (car inst) 'restore)
         (make-restore inst machine stack pc))
        ((eq? (car inst) 'perform)
         (make-perform inst machine labels ops pc))
        (else (error "Unknown instruction type -- ASSEMBLE"
                     inst))));}}}


(define (make-assign inst machine labels operations pc);{{{
  (let ((target
         (get-register machine (assign-reg-name inst)))
        (value-exp (assign-value-exp inst)))
    (let ((value-proc
           (if (operation-exp? value-exp)
               (make-operation-exp
                value-exp machine labels operations)
               (make-primitive-exp
                (car value-exp) machine labels))))
      (lambda ()                ; execution procedure for assign
        (set-contents! target (value-proc))
        (advance-pc pc)))));}}}

(define (assign-reg-name assign-instruction)
  (cadr assign-instruction))

(define (assign-value-exp assign-instruction)
  (cddr assign-instruction))

(define (advance-pc pc)
  (set-contents! pc (cdr (get-contents pc))))

(define (make-test inst machine labels operations flag pc);{{{
  (let ((condition (test-condition inst)))
    (if (operation-exp? condition)
        (let ((condition-proc
               (make-operation-exp
                condition machine labels operations)))
          (lambda ()
            (set-contents! flag (condition-proc))
            (advance-pc pc)))
        (error "Bad TEST instruction -- ASSEMBLE" inst))));}}}

(define (test-condition test-instruction)
  (cdr test-instruction))

(define (make-branch inst machine labels flag pc);{{{
  (let ((dest (branch-dest inst)))
    (if (label-exp? dest)
        (let ((insts
               (lookup-label labels (label-exp-label dest))))
          (lambda ()
            (if (get-contents flag)
                (set-contents! pc insts)
                (advance-pc pc))))
        (error "Bad BRANCH instruction -- ASSEMBLE" inst))));}}}

(define (branch-dest branch-instruction)
  (cadr branch-instruction))


(define (make-goto inst machine labels pc);{{{
  (let ((dest (goto-dest inst)))
    (cond ((label-exp? dest)
           (let ((insts
                  (lookup-label labels
                                (label-exp-label dest))))
             (lambda () (set-contents! pc insts))))
          ((register-exp? dest)
           (let ((reg
                  (get-register machine
                                (register-exp-reg dest))))
             (lambda ()
               (set-contents! pc (get-contents reg)))))
          (else (error "Bad GOTO instruction -- ASSEMBLE"
                       inst)))));}}}

(define (goto-dest goto-instruction)
  (cadr goto-instruction))

(define (stack-inst-reg-name stack-instruction)
  (cadr stack-instruction))

(define (make-perform inst machine labels operations pc);{{{
  (let ((action (perform-action inst)))
    (if (operation-exp? action)
        (let ((action-proc
               (make-operation-exp
                action machine labels operations)))
          (lambda ()
            (action-proc)
            (advance-pc pc)))
        (error "Bad PERFORM instruction -- ASSEMBLE" inst))));}}}

(define (perform-action inst) (cdr inst))

(define (make-primitive-exp exp machine labels);{{{
  (cond ((constant-exp? exp)
         (let ((c (constant-exp-value exp)))
           (lambda () c)))
        ((label-exp? exp)
         (let ((insts
                (lookup-label labels
                              (label-exp-label exp))))
           (lambda () insts)))
        ((register-exp? exp)
         (let ((r (get-register machine
                                (register-exp-reg exp))))
           (lambda () (get-contents r))))
        (else
         (error "Unknown expression type -- ASSEMBLE" exp))));}}}

(define (register-exp? exp) (tagged-list? exp 'reg))

(define (register-exp-reg exp) (cadr exp))

(define (constant-exp? exp) (tagged-list? exp 'const))

(define (constant-exp-value exp) (cadr exp))

(define (label-exp? exp) (tagged-list? exp 'label))

(define (label-exp-label exp) (cadr exp))


(define (make-operation-exp exp machine labels operations);{{{
  (let ((op (lookup-prim (operation-exp-op exp) operations))
        (aprocs
         (map (lambda (e)
                (make-primitive-exp e machine labels))
              (operation-exp-operands exp))))
    (lambda ()
      (apply op (map (lambda (p) (p)) aprocs)))));}}}

(define (operation-exp? exp)
  (and (pair? exp) (tagged-list? (car exp) 'op)))
(define (operation-exp-op operation-exp)
  (cadr (car operation-exp)))
(define (operation-exp-operands operation-exp)
  (cdr operation-exp))


(define (lookup-prim symbol operations)
  (let ((val (assoc symbol operations)))
    (if val
        (cadr val)
        (error "Unknown operation -- ASSEMBLE" symbol))))

;; from 4.1
(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

'(REGISTER SIMULATOR LOADED)



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

(define (make-restore inst machine stack pc);{{{
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
                   (list reg-name reg-at-top-of-stack))))))));}}}

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
    (define (peek)
      (if (null? s)
          (error "Empty stack -- POP")
          (car s)))    
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
            ((eq? message 'peek) (peek))
            ((eq? message 'initialize) (initialize))
            ((eq? message 'print-statistics)
             (print-statistics))
            (else
             (error "Unknown request -- STACK" message))))
    dispatch));}}}

; ; ; ; ; (define (make-instruction text)
; ; ; ; ;   (cons text         (cons '()            '())))
; ; ; ; ; ;         ^                 ^              ^
; ; ; ; ; ;         |                 |              |
; ; ; ; ; ;    Instruction          Execution    Instruction
; ; ; ; ; ;       Text              Procedure       labels
; ; ; ; ; 
; ; ; ; ; (define (instruction-text inst)
; ; ; ; ;   (car inst))
; ; ; ; ; 
; ; ; ; ; (define (instruction-execution-proc inst)
; ; ; ; ;   (cadr inst))
; ; ; ; ; 
; ; ; ; ; (define (instruction-labels inst)
; ; ; ; ;   (cddr inst))
; ; ; ; ; 
; ; ; ; ; (define (set-instruction-execution-proc! inst proc)
; ; ; ; ;   (set-car! (cdr inst) proc))
; ; ; ; ; 
; ; ; ; ; (define (set-instruction-labels! inst labels)
; ; ; ; ;   (set-cdr! (cdr inst) labels))
; ; ; ; ; 
; ; ; ; ; (define (add-a-instruction-label! inst label)
; ; ; ; ;   (set-instruction-labels! inst (cons label (instruction-labels inst))))

(define (make-instruction instruction-number text)
  (cons instruction-number (cons text (cons '()            '()))))
;            ^              ^                ^              ^
;            |              |                |              |
;        Instruction    Instruction         Execution    Instruction
;        Order/Number      Text             Procedure       labels

(define (instruction-order inst)
  (car inst))

(define (instruction-text inst)
  (cadr inst))

(define (instruction-execution-proc inst)
  (caddr inst))

(define (instruction-labels inst)
  (cdddr inst))

(define (set-instruction-execution-proc! inst proc)
  (set-car! (cddr inst) proc))

(define (set-instruction-labels! inst labels)
  (set-cdr! (cddr inst) labels))

(define (add-a-instruction-label! inst label)
  (set-instruction-labels! inst (cons label (instruction-labels inst))))

;;Changes in procedure extract-labels

(define (extract-labels text receive);{{{
  (if (null? text)
    (receive '() '())
    (extract-labels  
                    (cdr text)
                    (lambda (insts labels)
                      (let ((next-inst (car text)))
                        (if (symbol? next-inst)
                          (begin
                            ;;initially i forgot this null check which caused me some
                            ;;trouble while testing.
                            (if (not (null? insts))                                 ;;; 
                              (add-a-instruction-label! (car insts) next-inst))   ;;;
                            (receive insts
                                     (cons (make-label-entry next-inst
                                                             insts)
                                           labels)))
                          (receive (cons (make-instruction next-inst)
                                         insts)
                                   labels)))))));}}}

(define (make-register name);{{{
  (let ((contents '*unassigned*)
        (tracing-mode #f)
        (reg-name name))
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set)
             (lambda (value) (if tracing-mode 
                               (begin (display (list "Setting register" reg-name " to value: " value))
                                      (set! contents value))
                               (set! contents value))))
            ((eq? message 'name) reg-name)
            ((eq? message 'tracing-on) (set! tracing-mode #t))
            ((eq? message 'tracing-off) (set! tracing-mode #f))
            (else
             (error "Unknown request -- REGISTER" message))))
    dispatch));}}}

(define (make-new-machine);{{{
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
        (instruction-count 0) ; Instruction counter
        (tracing-mode #f) ; Tracing mode defaulting on the OFF position.
        (entry-regs '())
        (stack-regs '())
        (sorted-instructions '())
        (reg-sources (make-hash-table)))
    (let ((the-ops
           (list (list 'initialize-stack
                       (lambda () (stack 'initialize)))
                 (list 'print-stack-statistics
                       (lambda () (stack 'print-statistics)))))
          (register-table
           (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name);{{{
        (if (assoc name register-table)
            (error "Multiply defined register: " name)
            (set! register-table
                  (cons (list name (make-register name))
                        register-table)))
        'register-allocated);}}}
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
              (if tracing-mode
                (begin
                  (for-each (lambda(label)                     ;;;
                              (display "Moving over label: ")  ;;;
                              (display label))                 ;;;
                            (instruction-labels (car insts)))  ;;;
                  (newline)
                  (display "Executing instruction: ") (newline)
                  (display (instruction-text (car insts))) (newline)))
              ((instruction-execution-proc (car insts)))
              (set! instruction-count (+ instruction-count 1))
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
          ((reset-instruction-count) (set! instruction-count 0)); Explicitly resetting the instruction count
          ; (not needed per se, but SICP asks and I try to deliver ¯\_(ツ)_/¯)
          ((tracing-on) (set! tracing-mode #t)) ;; Tracing mode toggles
          ((tracing-off) (set! tracing-mode #f))
          ((nst-seq) the-instruction-sequence)
          ((print-formatted-insts) (for-each
                                     (lambda(inst)
                                       (display
                                         (list (instruction-text inst)
                                               (instruction-labels inst)))(newline))
                                     the-instruction-sequence))
          (else (error "Unknown request -- MACHINE" message))));}}}
      dispatch)));}}}

; (define fib-machine ;{{{
;   (make-machine ;register-names ops controller-text 
;     (list (list '< <) (list '- -) (list '+ +)) 
;     '(  ; from ch5.scm 
;         (assign continue (label fib-done)) 
;         fib-loop 
;         (test (op <) (reg n) (const 2)) 
;         (branch (label immediate-answer)) 
;         ;; set up to compute Fib(n-1) 
;         (save continue) 
;         (assign continue (label afterfib-n-1)) 
;         (save n)                           ; save old value of n 
;         (assign n (op -) (reg n) (const 1)); clobber n to n-1 
;         (goto (label fib-loop))            ; perform recursive call 
;         afterfib-n-1                         ; upon return, val contains Fib(n-1) 
;         (restore n) 
;         (restore continue) 
;         ;; set up to compute Fib(n-2) 
;         (assign n (op -) (reg n) (const 2)) 
;         (save continue) 
;         (assign continue (label afterfib-n-2)) 
;         (save val)                         ; save Fib(n-1) 
;         (goto (label fib-loop)) 
;         afterfib-n-2                         ; upon return, val contains Fib(n-2) 
;         (assign n (reg val))               ; n now contains Fib(n-2) 
;         (restore val)                      ; val now contains Fib(n-1) 
;         (restore continue) 
;         (assign val                        ; Fib(n-1)+Fib(n-2) 
;                 (op +) (reg val) (reg n))  
;         (goto (reg continue))              ; return to caller, answer is in val 
;         immediate-answer 
;         (assign val (reg n))               ; base case: Fib(n)=n 
;         (goto (reg continue)) 
;         fib-done)));}}}

(define gcd-machine
  (make-machine
   (list (list 'rem remainder) (list '= =))
   '(test-b
       (test (op =) (reg b) (const 0))
       (branch (label gcd-done))
       (assign t (op rem) (reg a) (reg b))
       (assign a (reg b))
       (assign b (reg t))
       (goto (label test-b))
     gcd-done)))

(for-each
  (lambda (inst)
    (display inst)
    (newline))
  (gcd-machine 'nst-seq))))

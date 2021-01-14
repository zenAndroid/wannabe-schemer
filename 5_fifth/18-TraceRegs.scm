(load "17-PrecedingLabels.scm")

;; I'll make the necessary modifications in make-register first.


(define (make-register name);{{{
  (let ((contents '*unassigned*)
        (tracing-mode #f)
        (reg-name name))
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set)
             (lambda (value) (if tracing-mode 
                               (begin (display (list "Setting register" reg-name " to value: " value))
                                      (newline)
                                      (set! contents value))
                               (set! contents value))))
            ((eq? message 'tracing-on) (set! tracing-mode #t))
            ((eq? message 'tracing-off) (set! tracing-mode #f))
            (else
             (error "Unknown request -- REGISTER" message))))
    dispatch));}}}

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

((get-register fact-machine 'n) 'tracing-on)
((get-register fact-machine 'val) 'tracing-on)
(set-register-contents! fact-machine 'n 18)
(fact-machine 'tracing-on)
(start fact-machine)

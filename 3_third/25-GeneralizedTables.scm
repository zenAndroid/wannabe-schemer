(define (make-table)
  (list '*table*))
; 
; (define (lookup key table)
;   (let ((record (assoc key (cdr table))))
;     (if record
;         (cdr record)
;         #f)))
; 
; (define tolerance 0.1)
; 
; (define (close-enough? key1 key2)
;   (let ((dist (abs (- key1 key2))))
;     (<= dist tolerance)))
; 
; (define (same-key? key1 key2)
;   (if (and (number? key1) (number? key2))
;     (close-enough? key1 key2)
;     (equal? key1 key2)))
; 

(define (assoc key records)
  (cond ((null? records) #f)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

; Please make it so that this works

(define (lookup keys table)
  (define (lookup-helper keys subtable)
    (cond ((null? subtable) #f)
          ((null? keys) (cdr subtable))
          (else
            ( let ((deeper (assoc (car keys) subtable)))
                  (if deeper
                    (lookup-helper (cdr keys) deeper)
                    #f)))))
  (lookup-helper keys (cdr table)))

; 
; (define (insert! key value table)
;   (let ((record (assoc key (cdr table))))
;     (if record
;         (set-cdr! record value)
;         (set-cdr! table
;                   (cons (cons key value) (cdr table)))))
;   'ok)
; 
; (define (lookup key-1 key-2 table)
;   (let ((subtable (assoc key-1 (cdr table))))
;     (if subtable
;         (let ((record (assoc key-2 (cdr subtable))))
;           (if record
;               (cdr record)
;               #f))
;         #f)))
; 
; (define (insert! key-1 key-2 value table)
;   (let ((subtable (assoc key-1 (cdr table))))
;     (if subtable
;         (let ((record (assoc key-2 (cdr subtable))))
;           (if record
;               (set-cdr! record value)
;               (set-cdr! subtable
;                         (cons (cons key-2 value)
;                               (cdr subtable)))))
;         (set-cdr! table
;                   (cons (list key-1
;                               (cons key-2 value))
;                         (cdr table)))))
;   'ok)
; 
; ;; local tables
; (define (make-tolerant-table)
;   (let ((local-table (list '*table*)))
;     (define (lookup key-1 key-2)
;       (let ((subtable (assoc key-1 (cdr local-table))))
;         (if subtable
;             (let ((record (assoc key-2 (cdr subtable))))
;               (if record
;                   (cdr record)
;                   #f))
;             #f)))
;     (define (insert! key-1 key-2 value)
;       (let ((subtable (assoc key-1 (cdr local-table))))
;         (if subtable
;             (let ((record (assoc key-2 (cdr subtable))))
;               (if record
;                   (set-cdr! record value)
;                   (set-cdr! subtable
;                             (cons (cons key-2 value)
;                                   (cdr subtable)))))
;             (set-cdr! local-table
;                       (cons (list key-1
;                                   (cons key-2 value))
;                             (cdr local-table)))))
;       'ok)    
;     (define (dispatch m)
;       (cond ((eq? m 'lookup-proc) lookup)
;             ((eq? m 'insert-proc!) insert!)
;             (else (error "Unknown operation -- TABLE" m))))
;     dispatch))
; 
(define operation-table (make-tolerant-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))


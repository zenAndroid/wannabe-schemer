(define (list->graphviz lst);{{{
  """Convert a list into a set of Graphviz instructions"""
  (define number 0)
  (define result "")
  (define ordinals '())
  (define (result-append! str)
    (set! result (string-append result str)))

  (define* (nodename n #:optional cell)
    (format #f "cons~a~a" n (if cell (string-append ":" cell) "")))

  (define* (build-connector from to #:optional from-cell)
    (format #f "\t~a -> ~a;~%" (nodename from from-cell) (nodename to)))

  (define (build-shape elt)
    (define (build-label cell)
      (cond ((null? cell) "&#x2205;") ; null character
            ((pair? cell) "&#x2022;") ; bullet dot character
            (else (format #f "~a" cell))))
    (set! number (+ number 1))

    (format #f "\t~a [shape=record,label=\"<car> ~a | <cdr> ~a\"];~%"
            (nodename number)
            (build-label (car elt))
            (build-label (cdr elt))))

  (define* (search xs #:optional from-id from-cell)
    (let ((existing (assq xs ordinals)))
      (if (pair? existing) ;; handle lists with cycles
          ;; we've already built a node for this entry, just make a connector
          (result-append! (build-connector from-id (cdr existing) from-cell))
          (begin
            (result-append! (build-shape xs))
            (set! ordinals (assq-set! ordinals xs number))
            (let ((parent-id number))
              ;; make a X->Y connector
              (if (number? from-id)
                  (result-append! (build-connector from-id parent-id from-cell)))
              ;; recurse
              (if (pair? (car xs)) (search (car xs) parent-id "car"))
              (if (pair? (cdr xs)) (search (cdr xs) parent-id "cdr")))))))

  (search lst)
  (string-append "digraph G {\n" result "}\n"));}}}

(define (make-table)
  (list '*table*))

(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
        (cdr record)
        #f)))

(define tolerance 0.1)

(define (close-enough? key1 key2)
  (let ((dist (abs (- key1 key2))))
    (<= dist tolerance)))

(define (same-key? key1 key2)
  (if (and (number? key1) (number? key2))
    (close-enough? key1 key2)
    (equal? key1 key2)))

(define (assoc key records)
  (cond ((null? records) #f)
        ((same-key? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (insert! key value table)
  (let ((record (assoc key (cdr table))))
    (if record
        (set-cdr! record value)
        (set-cdr! table
                  (cons (cons key value) (cdr table)))))
  'ok)

(define (lookup key-1 key-2 table)
  (let ((subtable (assoc key-1 (cdr table))))
    (if subtable
        (let ((record (assoc key-2 (cdr subtable))))
          (if record
              (cdr record)
              #f))
        #f)))

(define (insert! key-1 key-2 value table)
  (let ((subtable (assoc key-1 (cdr table))))
    (if subtable
        (let ((record (assoc key-2 (cdr subtable))))
          (if record
              (set-cdr! record value)
              (set-cdr! subtable
                        (cons (cons key-2 value)
                              (cdr subtable)))))
        (set-cdr! table
                  (cons (list key-1
                              (cons key-2 value))
                        (cdr table)))))
  'ok)

;; local tables
(define (make-tolerant-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (cdr record)
                  #f))
            #f)))
    (define (insert! key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key-1
                                  (cons key-2 value))
                            (cdr local-table)))))
      'ok)    
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define operation-table (make-tolerant-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))


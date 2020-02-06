#|

Exercise 3.23: A deque ("double-ended queue") is a sequence
in which items can be inserted and deleted at either the
front or the rear. Operations on deques are the constructor
"make-deque", the predicate "empty-deque?", selectors
"front-deque" and "rear-deque", mutators
"front-insert-deque!", "rear-insert-deque!",
"front-delete-deque!", and "rear-delete-deque!". Show how to
represent deques using pairs, and give implementations of
the operations. All operations should be accomplished in
Theta(1) steps.

|#

#|

Defining procedures for the creation and manipulation of doubly linked lists.
PS: DLL = Doubly Linked List

|#


(define (DLL-element element)
  (list '() element '()))

(define (prev dll-element)
  (car dll-element))

(define (val dll-element)
  (cadr dll-element))

(define (next dll-element)
  (caddr dll-element))

(define (make-deque) (cons '() '()))

(define (front-deque deque) (car deque))

(define (rear-deque deque) (cdr deque))

(define (set-front-ptr! deque item)
  (set-car! deque item))

(define (set-rear-ptr! deque item)
  (set-cdr! deque item))

(define (empty-deque? deque)
  (or
    (null? (front-deque deque))
    (null? (rear-deque deque))))

#|
Introducing abstract mutators
set-next-ddl! - set-prev-dll!
These are going to use list-set!
|#

(define (set-next-ddl! dll-element new-element)
  (list-set! dll-element 2 new-element)) 
; The justification for number 2 is the a DLL-element
; is (list previous-link element next-link) 
;                0          1       2

(define (set-prev-dll! dll-element new-element)
  (list-set! dll-element 0 new-element))
; The justification for number 0 is the a DLL-element
; is (list previous-link element next-link) 
;                0          1       2

#|

Going to introduce list-set!

(list-set! list-name index-to-be-changed new-value)

|#

(define (rear-insert-deque! deque element)
  (let ((new-element (DLL-element element)))
    (cond ((empty-deque? deque)
           (set-front-ptr! deque new-element)
           (set-rear-ptr! deque new-element))
          (else
            ; (set! (next (rear-deque deque)) new-element)
            ; (list-set! (rear-deque deque) 2 new-element)
            (set-next-ddl! (rear-deque deque) new-element)
            ; (set! (prev new-element) (rear-deque deque))
            ; (list-set! new-element 0 (rear-deque deque))
            (set-prev-dll! new-element (rear-deque deque))
            (set-rear-ptr! deque new-element)))))


(define (rear-delete-deque! deque)
  (if (empty-deque? deque)
    (error "CANT DELETE OFF AN EMPTY DEQUE MAN")
    (set-rear-ptr! deque (prev (rear-deque deque)))))

(define (front-insert-deque! deque item)
  (let ((new-element (DLL-element item)))
    (cond ((empty-deque? deque)
           (set-front-ptr! deque new-element)
           (set-rear-ptr! deque new-element))
          (else
            ; (set! (next new-element) (front-deque deque))
            ; (list-set! new-element 2 (front-deque deque))
            (set-next-ddl! new-element (front-deque deque))
            ; (set! (prev (front-deque deque)) new-element)
            ; (list-set! (front-deque deque) 0 new-element)
            (set-prev-dll! (front-deque deque) new-element)
            (set-front-ptr! deque new-element)))))

(define (front-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "CANNOT DELETE FROM AN EMPTY DEQUE"))
        (else 
          (set-front-ptr! deque (next (front-deque deque))))))


(define foo (make-deque))

(rear-insert-deque! foo 1023)
(rear-insert-deque! foo 2023)
(rear-insert-deque! foo 4023)
(rear-insert-deque! foo 8023)
(rear-insert-deque! foo 10236)
(rear-insert-deque! foo 30232)
(rear-delete-deque! foo)
(rear-insert-deque! foo 64)
(front-insert-deque! foo "YEAH")
(front-insert-deque! foo "YEAH")
(front-delete-deque! foo)
(front-insert-deque! foo "TesT")


(define (list->graphviz lst)
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
  (string-append "digraph G {\n" result "}\n"))


(display (list->graphviz foo))

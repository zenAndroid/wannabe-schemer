#|

Defining procedures for the creation and manipulation of doubly linked lists.
PS: DLL = Doubly Linked List

|#

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

(define (rear-insert-deque! deque element)
  (let ((new-element (DLL-element element)))
    (cond ((empty-deque? deque)
           (set-front-ptr! deque new-element)
           (set-rear-ptr! deque new-element))
          (else
            (set! (next (rear-deque deque)) new-element)
            (set! (prev new-element) (rear-deque deque))
            (set-rear-ptr! deque new-element)))))

(define (rear-delete-deque! deque)
  (if (empty-deque? deque)
    (error "CANT DELETE OFF AN EMPTY DEQUE MAN")
    (set-rear-ptr! deque (prev (rear-deque deque)))))

(define (front-insert-deque! deque item)
  (let ((new-element (DLL-element item)))
    (cond ((empty-deque? deque)
           (set-car! deque new-element)
           (set-cdr! deque new-element))
          (else
            (set! (next new-element) (front-deque deque))
            (set! (prev (front-deque deque)) new-element)
            (set-car! deque new-element)))))

(define (front-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "CANNOT DELETE FROM AN EMPTY DEQUE"))
        (else (set-car! deque (next (front-deque deque))))))

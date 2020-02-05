#|

Defining procedures for the creation and manipulation of doubly linked lists.
PS: DLL = Doubly Linked List

|#

(define (DLL-element element)
  (list '() element '()))

(define (DLL-prev dll-element)
  (car dll-element))

(define (DLL-val dll-element)
  (cadr dll-element))

(define (DLL-next dll-element)
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
            (set! (DLL-next (rear-deque deque)) new-element)
            (set! (DLL-prev new-element) (rear-deque deque))
            (set-rear-ptr! deque new-element)))))

(define (rear-delete-deque! deque)
  (if (empty-deque? deque)
    (error "CANT DELETE OFF AN EMPTY DEQUE MAN")
    (set-rear-ptr! deque (DLL-prev (rear-deque deque)))))

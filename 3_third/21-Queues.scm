; Initial definitions

(define (front-ptr q) (car q))
(define (rear-ptr q) (cdr q))
(define (set-front-ptr! q item)
  (set-car! q item))
(define (set-rear-ptr! q item)
  (set-cdr! q item))

; Just as a reminder so the points gets across:
; The queue is NOT the sequence of items.
; The queue is a PAIR of POINTERS.
; The first of which points to the start of the actual elements in the list
; And the second of which points to the last element in the list.

(define (empty-q? q)
  (null? (front-ptr q)))

(define (make-queue) (cons '() '()))

(define (front-q q)
  (if (empty-q? q)
    (error "FRONT called with empty queue" q)
    (car (front-ptr q))))

(define (insert-q! q item)
  (let ((new-pair (cons item '())))
    (cond ((empty-q? q)
           (set-front-ptr! q new-pair)
           (set-rear-ptr! q new-pair)
           q)
          (else (set-cdr! (rear-ptr q) new-pair)
                (set-rear-ptr! q new-pair)
                q))))

; Really easy to forget this and equate (rear-ptr q) with q
; (rear-ptr q) POINTS TO THE LAST ELEMENT
; (set-cdr! (rear-ptr q) new-pair)
; DOES NOT SET THE CDR OF THE QUEUE TO THE NEW PAIR
; IT SETS THE CDR OF THE *LAST ELEMENT* TO THE NEW PAIR

(define (delete-q! q)
  (cond ((empty-q? q)
         (error "DELETE QUEUE called on an empty-q? queue"))
        (else (set-front-ptr! q (cdr (front-ptr q)))
              q)))

; (define q1 (make-queue))

; (insert-q! q1 'a)
; 
; ; ((a) a)
; 
; (insert-q! q1 'b)
; 
; ; ((a b) b)
; 
; (delete-q! q1)
; 
; ; ((b) b)
; 
; (delete-q! q1)

; (() b)


; The reason is that the standar lisp printer shows all of the content 
; of the queue pair so it shows the value of front pointer AND the rear pointer
; whereas logically we'd only care about seeing the value of front pointer since
; that is what shows the actual content of the queue.

; we need to define our own procedure with its own internal logic

; (define (print-q q)
;   (front-ptr q))

; Could be as simple as that or as complex as something that prints
; space between the element or whatever you fancy

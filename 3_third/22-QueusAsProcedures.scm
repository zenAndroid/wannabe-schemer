#|

Exercise 3.22: Instead of representing a queue as a pair of
pointers, we can build a queue as a procedure with local
state. The local state will consist of pointers to the
beginning and the end of an ordinary list. Thus, the
"make-queue" procedure will have the form

(define (make-queue)
  (let ((front-ptr   ...  )
        (rear-ptr   ...  ))
    <definitions of internal procedures>
    (define (dispatch m)   ... )
    dispatch))

Complete the definition of "make-queue" and provide
implementations of the queue operations using this
representation.

|#

(define (make-queue)
  (let ((front-ptr '())
        (rear-ptr '()))
        ; empty
        (define (empty-q?) (null? front-ptr))
        ; front
        (define (front-q)
          (if (empty-q?)
            (error "CANNOT OUTPUT THE FRONT OF AN EMPTY LIST")
            front-ptr))
        ; insert
        (define (insert-q! item)
          (let ((new-pair (cons item '())))
            (cond ((empty-q?)
                   (set! front-ptr new-pair)
                   (set! rear-ptr new-pair))
                  (else
                    (set-cdr! rear-ptr new-pair)
                    (set! rear-ptr new-pair)))))
        ; delete
        (define (delete-q!)
          (cond ((empty-q?)
                 (error "CANNOT DELETE EMPTY QUEUE" front-ptr))
                (else 
                  (set! front-ptr (cdr front-ptr)))))
        (define (dispatch m)
          (cond ((eq? m 'insert) insert-q!)
                ((eq? m 'delete) delete-q!)
                ((eq? m 'front) front-q)
                ((eq? m 'rear) rear-ptr)
                (else "UNKNOWN OPERATION")))
        dispatch))


(define test-q (make-queue))

(define (q-insert queue item)
  ((queue 'insert) item))

(define (q-delete queue)
  ((queue 'delete)))

(define (q-front queue)
  ((queue 'front)))

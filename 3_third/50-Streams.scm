; 2020-02-17 19:45 :: zenAndroid ::  There we goooo 
; Well, just making my life a bit easier for me and using guile's
; implementation of streams.
; 
; Scheme Procedure: make-stream proc initial-state
; 
;     Return a new stream, formed by calling proc successively.
; 
;     Each call is (proc state), it should return a pair, the car being
;     the value for the stream, and the cdr being the new state for the
;     next call. For the first call state is the given initial-state. At
;     the end of the stream, proc should return some non-pair object.
; 
; Scheme Procedure: stream-car stream
; 
;     Return the first element from stream. stream must not be empty.
; 
; Scheme Procedure: stream-cdr stream
; 
;     Return a stream which is the second and subsequent elements of stream.
;     stream must not be empty.
; 
; Scheme Procedure: stream-null? stream
; 
;     Return true if stream is empty.
; 
; Scheme Procedure: list->stream list
; Scheme Procedure: vector->stream vector
; 
;     Return a stream with the contents of list or vector.
; 
;     list or vector should not be modified subsequently, since it’s
;     unspecified whether changes there will be reflected in the stream
;     returned.
; 
; Scheme Procedure: port->stream port readproc
; 
;     Return a stream which is the values obtained by reading from port using
;     readproc. Each read call is (readproc port), and it should return an EOF
;     object (see Binary I/O) at the end of input.
; 
;     For example a stream of characters from a file,
; 
;     (port->stream (open-input-file "/foo/bar.txt") read-char)
; 
; Scheme Procedure: stream->list stream
; 
;     Return a list which is the entire contents of stream.
; 
; Scheme Procedure: stream->reversed-list stream
; 
;     Return a list which is the entire contents of stream, but in reverse order.
; 
; Scheme Procedure: stream->list&length stream
; 
;     Return two values (see Multiple Values), being firstly a list which is
;     the entire contents of stream, and secondly the number of elements in
;     that list.
; 
; Scheme Procedure: stream->reversed-list&length stream
; 
;     Return two values (see Multiple Values) being firstly a list which is the
;     entire contents of stream, but in reverse order, and secondly the number
;     of elements in that list.
; 
; Scheme Procedure: stream->vector stream
; 
;     Return a vector which is the entire contents of stream.
; 
; Function: stream-fold proc init stream1 stream2 …
; 
;     Apply proc successively over the elements of the given streams, from
;     first to last until the end of the shortest stream is reached. Return the
;     result from the last proc call.
; 
;     Each call is (proc elem1 elem2 … prev), where each elem is from the
;     corresponding stream. prev is the return from the previous proc call, or
;     the given init for the first call.
; 
; Function: stream-for-each proc stream1 stream2 …
; 
;     Call proc on the elements from the given streams. The return value is unspecified.
; 
;     Each call is (proc elem1 elem2 …), where each elem is from the
;     corresponding stream. stream-for-each stops when it reaches the end of
;     the shortest stream.
; 
; Function: stream-map proc stream1 stream2 …


(use-modules (ice-9 streams))

(define empty-stream (list->stream '()))

(define foo (make-stream (lambda(x) (cons x (+ x 1))) 1))

(define yeet (stream-car foo))

(define (print-n s n)
  (if (> n 0)
      (begin (newline)
	     (display (stream-car s))
             (print-n (stream-cdr s) (- n 1)))))

(define (stream-map proc s)
  (if (stream-null? s)
      empty-stream
      (cons-stream (proc (stream-car s)); Unfortunately I cant test this :(
                   (stream-map proc (stream-cdr s)))))

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      empty-stream
      (cons-stream; Unfortunately I cant test this :(
       (apply proc (map stream-car argstreams))
       (apply stream-map
	      (cons proc (map stream-cdr argstreams))))))

; Did not test this, but it is correct, so ... ¯\_(ツ)_/¯.
; I hope the other exercises don't use stream-cons much ...

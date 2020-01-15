#lang scheme

(require racket/trace)

(define (enumerate-seq a b)
  (if (> a b)
      '()
      (cons a (enumerate-seq (+ a 1) b))))

(define (until n) (enumerate-seq 1 n))

(define (accumulate op init seq)
  (if (null? seq)
      init
      (op (car seq) (accumulate op init (cdr seq)))))

; Write a procedure to find all ordered triples of distinct positive integers i, j, and k less than
; or equal to a given integer n that sum to a given integer s.

; i -> 1..n
;     j -> 1..i-1
;         k ->1..j-1
;             if i+j+k = s: (i,j,k) is good triplet
(define place-holder 15)
; Trying to develop it the way i did in the previous file: incrementally
; (map      <??>            (until n)      )
; Mapping something     to the sequence 1..n
; what is something?
; capture i then generate 1..(i-1) to apply something to *that*
; (map                (lambda(i) (map <??> (until (- i 1))))            (until n)      )
; map         the capture and processing of a certain sequence      to 1..n
; same question
;
; capture j and do stuff to 1..(j-1)
;
; (map (lambda(i) (map (lambda(j) (lambda(k) <??> (until (- j 1))) (until (- i 1))))) (until 999))
;
; Need to generate the triplet (i,j,k) now. (list i j k)
;

(define (proc n)
  (map
   (lambda(i) (map
               (lambda(j) (map
                           (lambda(k) (list i j k))
                           (until (- j 1))))
               (until (- i 1))))
   (until n)))


; TODO
; - Splitting these things out into function to make them more understandable
; - Getting used to the flatMap higher level function
; - Look at online solutions to see where improvements can be made



; One 'flattening' is not enough ... learned that ~~the hard way~~
; Two flattenings are necesarry.

(define (flat-triplets n) (accumulate append '() (accumulate append '() (proc n))))


; The 'filtering' function
(define (valid-triplet? triplet target-sum)
  (= (+ (car triplet)
        (cadr triplet)
        (caddr triplet)) target-sum))


; To summarize :
; - (flat-triplets n) generates a list of triplets.
; - (valid-triplet? triplet s) returns true if the sum of the components is equal to s

(define (final n target-sum)
  (define my-filter (lambda(triplet) (valid-triplet? triplet target-sum)))
  (filter my-filter (flat-triplets n)))


(final 6 9)

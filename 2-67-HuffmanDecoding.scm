#lang scheme
(require racket/trace)
; Defining the leaf 'data structure'


(define (make-leaf symbol weight) ; A leaf is a list of 'leaf, the symbol, and the weight
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf)) ; To check if a node is a leaf, we check its car with the symbol 'leaf)

(define symbol-leaf cadr)   ; To retrieve a symbol from a leaf, car the cdr of the leaf, in other words, `cadr` the leaf

(define weight-leaf caddr)  ; To retrieve a weight from a leaf, cdr -> cdr -> car, ie caddr.

; Defining the procedure that will make a huffman tree node that respects the following
; 1- First element is the left branch
; 2- Second element is the right branch
; 3- Third element is the (list? set?) of symbols (Built up using append)
; 4- Fourth element is the weight of the current node (which is the sum of the weight of the two left and right branches)

(define (make-hufftree left right)
              (list left
                    right
                    (append (symbols left) (symbols right))
                    (+ (weight left) (weight right))))

(define left-branch car)

(define right-branch cadr)

; A bit of magical thinking used for symbols and weights procedures.
; Implementing them now.

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))


; Tada! now for the decoding procedure, which i won't really comment on since the text itself
; explains it (not this code, i mean the textbook itself)


(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch (choose-branch (car bits) current-branch)))
          (if (leaf? next-branch)
              (cons (symbol-leaf next-branch) (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit: CHOOSE-BRANCH" bit))))

; Adjoin set modified for this kind of structure
; Pre-conditions : x is a pair composed of a symbol and its corresponding frequency

(define (adjoin-set x set)
  (if (null? set)
      (list x)
      (cond ((< (weight x) (weight (car set))) (cons x set))
            (else (cons (car set) (adjoin-set x (cdr set)))))))


(define sample-tree
  (make-hufftree (make-leaf 'A 4)
                 (make-hufftree (make-leaf 'B 2)
                                (make-hufftree (make-leaf 'D 1)
                                               (make-leaf 'C 1)))))

(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

; > (decode sample-message sample-tree)
; (A D A B B C A)
#lang scheme

(define (make-leaf symbol weight) ; A leaf is a list of 'leaf, the symbol, and the weight
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf)) ; To check if a node is a leaf, we check its car with the symbol 'leaf

(define symbol-leaf cadr)   ; To retrieve a symbol from a leaf, car the cdr of the leaf,
; in other words, `cadr` the leaf

(define weight-leaf caddr)  ; To retrieve a weight from a leaf, cdr -> cdr -> car, ie caddr.

; Defining the procedure that will make a huffman tree node that respects the following
; 1- First element is the left branch
; 2- Second element is the right branch
; 3- Third element is the (list? set?) of symbols (Built up using append)
; 4- Fourth element is the weight of the current node (which is the sum of the weight of
;    the two left and right branches)

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
; Pre-conditions : x is a pair composed of a symbol(s) and the corresponding frequency

(define (adjoin-set x set)
  (if (null? set)
      (list x)
      (cond ((< (weight x) (weight (car set))) (cons x set))
            (else (cons (car set) (adjoin-set x (cdr set)))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (let ((symbol (car pair))
              (freq (cadr pair)))
          (adjoin-set (make-leaf symbol freq) (make-leaf-set (cdr pairs)))))))

(define sample-tree
  (make-hufftree (make-leaf 'A 4)
                 (make-hufftree (make-leaf 'B 2)
                                (make-hufftree (make-leaf 'D 1)
                                               (make-leaf 'C 1)))))

(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

; > (decode sample-message sample-tree)
; (A D A B B C A)
(define (element-of-set? x set)
  (cond ((null? set) #f)
        ((eq? x (car set)) #t)
        (else (element-of-set? x (cdr set)))))


(define (encode-symbol symbol tree)
  (cond ((leaf? tree) '())
        ((not (element-of-set? symbol (symbols tree)))
         (error "ERROR --- 404 SYMBOL NOT FOUND" symbol))
        ((element-of-set? symbol (symbols (left-branch tree)))
         (cons 0 (encode-symbol symbol (left-branch tree))))
        ((element-of-set? symbol (symbols (right-branch tree)))
         (cons 1 (encode-symbol symbol (right-branch tree))))))

  
(define (encode message tree)
  (if (null? message)
      '()
      (append 
       (encode-symbol (car message) 
                      tree)
       (encode (cdr message) tree))))

;; Writing the correct implementation of succesive merge after my first wrong one.
;; I looked at it online, so it's be unfair if I wrote it without at least explaining
;; it well. Here it is:

(define (succ-merge pairs)
  (cond ((null? pairs) (error "No pairs passed down -- BAD"))
        ((null? (cdr pairs)) (car pairs)) ;; The null? (cdr pairs) is an alternative way of checking
        ;; that the length of the list of pairs is 1 and in that case you return that element,
        ;; which is the root of the huffman tree.
        (else (let ((first (car pairs))
                    (second (cadr pairs)))
                (succ-merge (adjoin-set
                             (make-hufftree first second)
                             (cddr pairs)))))))

(define (generate-huffman-tree pairs)
  (succ-merge (make-leaf-set pairs)))


(define pair-freq '((a 7) (b 8) (g 2) (t 6)))
(define pair-freq2 '((a 6) (b 6) (g 6) (t 6)))
(define foo (make-leaf-set pair-freq))

(define Exo2-70
  '(
    (A 2)
    (BOOM 1)
    (GET 2)
    (JOB 2)
    (NA 16)
    (SHA 3)
    (YIP 9)
    (WAH 1)))

(define exo270-tree (generate-huffman-tree Exo2-70))


(define encoding (encode '(GET A JOB ;3
                      SHA NA NA NA NA NA NA NA NA;9

                      GET A JOB ; 3
                      SHA NA NA NA NA NA NA NA NA;9

                      WAH YIP YIP YIP YIP ;5
                      YIP YIP YIP YIP YIP;5
                      SHA BOOM) exo270-tree));2

encoding

;; (decode encoding exo270-tree)

;; Gives back the lyrics ==> works as expected

;; Necessary bits = 84

;; There are 8 symbols, so log_2(8) of bits will be needed for a fixed length code per symbol
;; I.E; 3 bits per symbol

;; There is 3 SHA symbol   --> 9 bits
;; There is 1 BOOM symbol  --> 3 bits
;; There is 1 WAH symbol   --> 3 bits
;; THere are 2 GET symbols --> 6 bits
;; There are 2 A symbols   --> 6 bits
;; There are 2 JOB symbols --> 6 bits
;; There is 16 NA symbol   --> 16*3 bits
;; There is 9 YIP symbol   --> 9*3 bits
;; So the minimum amount of bits is equal to: 102 bits

(* (foldl + 0 (map (lambda(pair) (cadr pair)) Exo2-70)) 3)


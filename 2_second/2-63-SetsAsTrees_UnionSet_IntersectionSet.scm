#lang scheme
(require racket/trace)
;                                                                                      
;                                                                                      
;   ;;;;;                                      ;                  ;;        ;          
;   ; ; ;                                     ; ;                  ;              ;    
;     ;                                       ; ;                  ;              ;    
;     ;    ;; ;;   ;;;    ;;;    ;;;;         ;;             ;;;;  ; ;;   ;;;   ;;;;;  
;     ;     ;;    ;   ;  ;   ;  ;   ;         ;  ;;         ;   ;  ;;  ;    ;     ;    
;     ;     ;     ;;;;;  ;;;;;   ;;          ; ; ;           ;;    ;   ;    ;     ;    
;     ;     ;     ;      ;         ;         ; ; ;             ;   ;   ;    ;     ;    
;     ;     ;     ;   ;  ;   ;  ;   ;        ;  ;  ;        ;   ;  ;   ;    ;     ;  ; 
;    ;;;   ;;;;    ;;;    ;;;   ;;;;          ;; ;;         ;;;;  ;;; ;;; ;;;;;    ;;  
;                                                                                      
;                                                                                      

(define (make-tree entry left right) (list entry left right))

(define entry-tree car)
(define left-branch cadr)
(define right-branch caddr)

(define (element-of-set? x set)
  (cond
    ((null? set) #f)
    ((< x (entry-tree set)) (element-of-set? x (left-branch set)))
    ((> x (entry-tree set)) (element-of-set? x (right-branch set)))
    ((= x (entry-tree set)) #t)
    (else (error "Something ain't right sir!"))))

(define (adjoin-set x set)
  (cond
    ((null? set)(make-tree x '() '()))
    ((< x (entry-tree set)) (make-tree
                             (entry-tree set)
                             (adjoin-set x (left-branch set))
                             (right-branch set)))
    ((> x (entry-tree set)) (make-tree
                             (entry-tree set)
                             (left-branch set)
                             (adjoin-set x (right-branch set))))
    ((= x (entry-tree set)) set)))


(define (tree->list tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons
                       (entry-tree tree)
                       (copy-to-list (right-branch tree) result-list)))))
  (copy-to-list tree '()))

(define (list->tree elements)
  (car (partial-tree 
        elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result (partial-tree (cdr non-left-elts) right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree) remaining-elts))))))))

(define foo (list->tree '(1 5 6 7 9 11 15 21 57)))

(define bar (list->tree '(3 5 8 15 19 31 42 43)))

;                                               
;                                               
;                                               
;                                               
;                                               
;                                               
;                                               
;     ;;;;;                 ;;;;;;        ;;;;  
;    ;;;;;;;;              ;;;;;;        ;;;;;  
;   ;;;   ;;;             ;;;            ;;;;;  
;   ;;;   ;;;            ;;;;           ;;;;;;  
;   ;;;   ;;;            ;;;            ;;;;;;  
;         ;;;            ;;; ;;;;      ;; ;;;;  
;        ;;;;            ;;;;;;;;;    ;;; ;;;;  
;       ;;;;    ;;;;;;   ;;;   ;;;;   ;;  ;;;;  
;      ;;;;     ;;;;;;   ;;;    ;;;  ;;;  ;;;;  
;     ;;;;               ;;;    ;;;  ;;;;;;;;;; 
;     ;;;                ;;;    ;;;  ;;;;;;;;;; 
;    ;;;;                ;;;;  ;;;;       ;;;;  
;   ;;;;;;;;;;            ;;;;;;;;        ;;;;  
;   ;;;;;;;;;;              ;;;;          ;;;;  
;                                               
;                                               
;                                               
;                                               
;                                               
; Union set & intersection-set

; Union-set; relatively straight forward :
; You get two sets and u need to merge them
; 1) Transform them into lists;
; 2) Merge those lists
; 2.1) watch out for doubles
;   You merge them sort of like mergesort
; 3) Transfrom the resulting list into ints oiwn set.
; 4) Done


(define (union-set first-set second-set)
  (define (merge f-list s-list)
    (cond ((null? f-list) s-list)
          ((null? s-list) f-list)
          ((= (car f-list) (car s-list)) (cons (car f-list) (merge (cdr f-list) (cdr s-list))))
          ((< (car f-list) (car s-list)) (cons (car f-list) (merge (cdr f-list) s-list)))
          ((> (car f-list) (car s-list)) (cons (car s-list) (merge f-list (cdr s-list))))))
  (let ((first-set-as-list (tree->list first-set))
        (second-set-as-list (tree->list second-set)))
    (let ((merged-lists (merge first-set-as-list second-set-as-list)))
      (list->tree merged-lists))))


; Intersection-set
; I think i'll use the same strategy
; except the merging rules will be different.
; Namely only add stuff the the list if it doesn't exist in the other one.

(define (intersection-set first-set second-set)
  (define (merge f-list s-list)
    (cond ((null? f-list) s-list)
          ((null? s-list) f-list)
          ((= (car f-list) (car s-list)) (merge (cdr f-list) (cdr s-list)))
          ((< (car f-list) (car s-list)) (cons (car f-list) (merge (cdr f-list) s-list)))
          ((> (car f-list) (car s-list)) (cons (car s-list) (merge f-list (cdr s-list))))))
  (let ((first-set-as-list (tree->list first-set))
        (second-set-as-list (tree->list second-set)))
    (let ((merged-lists (merge first-set-as-list second-set-as-list)))
      (list->tree merged-lists))))

(define kar (intersection-set foo bar))

; Forgot to say that this contains the solution to 2.65 too.

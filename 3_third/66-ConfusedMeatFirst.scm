; 2020-02-22 14:53 :: zenAndroid ::  The filename is Confused Me At First, but
; imma roll with this

; But yeah I found the hand way of debuggin this to be a pain, I'm gonna try to
; help myself with actually executing it

(load "65-Ln2.scm")

(define (interleave s1 s2)
  (if (stream-empty? s1)
      s2
      (stream-cons (stream-first s1)
                   (interleave s2 (stream-rest s1)))))

(define (pairs s t)
  (stream-cons
   (list (stream-first s) (stream-first t))
   (interleave
    (stream-map (lambda (x) (list (stream-first s) x))
                (stream-rest t))
    (pairs (stream-rest s) (stream-rest t)))))


(define int-pairs (pairs integers integers))

; (stream->list (stream-take int-pairs 50))


; See Eli's answer ... https://eli.thegreenplace.net/2007/11/10/sicp-section-353


; My attempt at explaining


; '((1 1)    ;  (2 2)    ;  (3 3)      
;   (1 2)    ;  (2 3)    ;  (3 4)      
;   (2 2)    ;  (3 3)    ;  (4 4)      
;   (1 3)    ;  (2 4)    ;  (3 5)      
;   (2 3)    ;  (3 4)    ;  (4 5)      
;   (1 4)    ;  (2 5)    ;  (3 6)      
;   (3 3)    ;  (4 4)    ;  (5 5)      
;   (1 5)    ;  (2 6)    ;  (3 7)      
;   (2 4)    ;  (3 5)    ;  (4 6)      
;   (1 6)    ;  (2 7)    ;  (3 8)      
;   (3 4)    ;  (4 5)    ;  (5 6)      
;   (1 7)    ;  (2 8)          
;   (2 5)    ;  (3 6)          
;   (1 8)    ;  (2 9)          
;   (4 4)    ;  (5 5)          
;   (1 9)    ;  (2 10)         
;   (2 6)    ;  (3 7)          
;   (1 10)   ;  (2 11)          
;   (3 5)    ;  (4 6)          
;   (1 11)   ;  (2 12)          
;   (2 7)    ;  (3 8)          
;   (1 12)   ;  (2 13)          
;   (4 5)    ;  (5 6)          
;   (1 13)   ;  (2 14)          
;   (2 8)             
;   (1 14)             
;   (3 6)             
;   (1 15)             
;   (2 9)             
;   (1 16)             
;   (5 5)             
;   (1 17)             
;   (2 10)             
;   (1 18)             
;   (3 7)             
;   (1 19)             
;   (2 11)             
;   (1 20)             
;   (4 6)             
;   (1 21)             
;   (2 12)             
;   (1 22)             
;   (3 8)             
;   (1 23)             
;   (2 13)             
;   (1 24)             
;   (5 6)             
;   (1 25)             
;   (2 14)             
;   (1 26))             

; We notice that after the first (1 1) all the pairs in the form (1 n) appear each 2 lines, 
; ...
; a few minutes later.
; 
; AaAAAAAaaAAA got confused trying to formalise this
; but here goes
; so the first occurence of interest, (1 2) happens at line 2
; and then each next one is separated by two
; lets put it in a recurrence relation
; U(term)   = line number wheer (1 term) appears
; U(2)      = 2
; U(term+1) = U(term) + 2
; Solving for this, we get
; U(n)      = 2n-2
; So U(100) = 2*100-2 = 198

;  (3 3)
;  (3 4)
;  (4 4)
;  (3 5)
;  (4 5)
;  (3 6)
;  (5 5)
;  (3 7)
;  (4 6)
;  (3 8)
;  (5 6)

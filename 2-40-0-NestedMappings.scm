#lang scheme

(define (accumulate op init seq)
  (if (null? seq)
      init
      (op (car seq) (accumulate op init (cdr seq)))))


(define (enumerate-seq a b)
  (if (> a b)
      '()
      (cons a (enumerate-seq (+ a 1) b))))

(define (until n) (enumerate-seq 1 n))

(define (prime? p)
  (define (non-divisible-by n d)
    (cond
     ((= d 1) #t)
     (else (if(= (remainder n d) 0)
          #f
          (non-divisible-by n (- d 1))))))
  (if (= p 1)
      #t
      (non-divisible-by p (- p 1))))
;; Let's see if i can figure this out

;; First we're going to 'iterate' through 1..n and do something each iteration
;; to generate the list 1..n, we'll use (until n)
;;
;;
;; (map       <??>          (until n)    )
;; We map   something     to the list 1..n
;;
;;
;; What is that something?
;; We'll need to capture the i then map along 1..(i-1) then do another thing.

;; (map              (lambda(i) (map <??> (until (- i 1))))                    (until n)    )
;; We map    'going through 1..(i-1) and doing something there'        to the list 1..n
;; What is this 'second thing' ?
;; We need to then capture the j then make a (i j) pair to it.
;;
;; So the <??> placeholder in the last expression should be something like
;; (lambda(j) (list i j))

(define (ordered-pairs n)
  (map (lambda(i) (map (lambda(j) (list i j)) (until (- i 1)))) (until n)))

(define (flat-pairs n) (accumulate append '() (ordered-pairs n)))

(define (prime-sum pair)
  (prime? (+ (car pair) (cadr pair))))

(filter prime-sum (flat-pairs 6))

;; OUTPUT ==> ((2 1) (3 2) (4 1) (4 3) (5 2) (6 1) (6 5))

(define (res n) (map (lambda(pair)
                       (list
                        (car pair)
                        (cadr pair)
                        (+ (car pair) (cadr pair))))
                     (filter prime-sum (flat-pairs n))))

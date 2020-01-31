(define (has-cycles? arg-list)
  (define encountered '())
  (define (traverse list-item)
    (if (or (not (pair? list-item)) (null? list-item))
      #f
      (let ((element-encountered?
              (memq list-item encountered)))
        (cond ((not element-encountered?)
               (begin (set! encountered (cons list-item encountered))
                      (or (traverse (car list-item))
                          (traverse (cdr list-item)))))
              (element-encountered? list-item)))))
  (traverse arg-list))

(define (cycle-haver arg-list)
  (display "The list ")
  (display arg-list)
  (if (has-cycles? arg-list)
    (display " DOES have a cycle\n")
    (display " DOES NOT have a cycle\n")))

(define t1 (list 'a 'b))
(define t2 (list t1 t1))
(define he-list (list 1 2 3))
(define the-list (list 1 2 3))
(set-car! (cddr he-list) (cdr he-list))
(set-cdr! (cddr the-list) the-list)
(cycle-haver t2)
(cycle-haver the-list)
(cycle-haver he-list)
(cycle-haver (list (list 2 3 4) (list 3 42 5) (cons 3 4)))
;Seems to work ...

; Result of execution :


;;; note: source file /home/zenandroid/gitRepos/scheming/3_third/18-CycleDetection.scm
;;; newer than compiled /home/zenandroid/.cache/guile/ccache/2.2-LE-8-3.A/home/zenandroid/gitRepos/scheming/3_third/18-CycleDetection.scm.go
; The list ((a b) (a b)) DOES have a cycle
; The list (1 2 3 . #-2#) DOES have a cycle
; The list (1 2 #-1#) DOES have a cycle
; The list ((2 3 4) (3 42 5) (3 . 4)) DOES NOT have a cycle

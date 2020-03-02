# 2020-03-01 22:18 :: zenAndroid :: Well well well ...

; Ok, at first I couldn't guess what the issue would be
; Hindisight is 20 20, but I should've
; So I decided to try doing it on my own
; And even then I didn't stop too much to think about it 
Mostly because I was excited at seeing the metacircular evaluator working ...

;;;   ;;; M-Eval input:
;;;   (define (map f l)
;;;     (if (null? l) '()
;;;       (cons (f (car l)) (map f (cdr l)))))
;;;   
;;;   ;;; M-Eval value:
;;;   ok
;;;   
;;;   ;;; M-Eval input:
;;;   (define (inc x)
;;;   (+ x 1))
;;;   
;;;   ;;; M-Eval value:
;;;   ok
;;;   
;;;   ;;; M-Eval input:
;;;   inc
;;;   
;;;   ;;; M-Eval value:
;;;   (compound-procedure (x) ((+ x 1)) <procedure-env>)
;;;   
;;;   ;;; M-Eval input:
;;;   map
;;;   
;;;   ;;; M-Eval value:
;;;   (compound-procedure (f l) ((if (null? l) (quote ()) (cons (f (car l)) (map f (cdr l))))) <procedure-env>)
;;;   
;;;   ;;; M-Eval input:
;;;   (map inc '(1 2 3 4))
;;;   
;;;   ;;; M-Eval value:
;;;   (2 3 4 5)


;;; Ok, so this version works, that's neat, now let us try the other version; iE borrowing the underlying Lisp's map

;;;    ;;; M-Eval input:
;;;    (define incTwo (lambda (x) (+ x 2)))
;;;    
;;;    ;;; M-Eval value:
;;;    ok
;;;    
;;;    ;;; M-Eval input:
;;;    incTwo
;;;    
;;;    ;;; M-Eval value:
;;;    (compound-procedure (x) ((+ x 2)) <procedure-env>)
;;;    
;;;    ;;; M-Eval input:
;;;    (map incTwo '(1 2 3))
;;;    Backtrace:
;;;               4 (primitive-load "/home/zenandroid/gitRepos/scheming/4_fourth/The-Actual-Meta-Eval.scm")
;;;    In ice-9/eval.scm:
;;;        619:8  3 (_ #(#(#<directory (guile-user) 7f1d78164140>)))
;;;       293:34  2 (_ #(#(#(#<directory (guile-user) 7f1d78164140>)) (map incTwo (quote (1 2 3)))))
;;;    In ice-9/boot-9.scm:
;;;       222:17  1 (map1 (1 2 3))
;;;    In unknown file:
;;;               0 (_ 1)
;;;    
;;;    ERROR: Wrong type to apply: (procedure (x) ((+ x 2)) (((incTwo false
;;;    true car cdr cons null? map +) #-6# #f #t (primitive #<procedure car
;;;    (_)>) (primitive #<procedure cdr (_)>) (primitive #<procedure cons (_
;;;    _)>) (primitive #<procedure null? (_)>) (primitive #<procedure map (f l)
;;;    | (f l1 l2) | (f l1 . rest)>) (primitive #<procedure + (#:optional _ _ .
;;;    _)>))))


;;; Personally at this point I was still too hot minded to properly think about
;;; the topic, so I checked the solution online and then I understood, looking
;;; back as i said I should've realized something was up just seeing that error
;;; message : Wrong type to apply: <...>, because i believe that comes from
;;; 'Scheme's' universe, not the interpreted scheme's version of apply, and
;;; that tells me the problem: the map primitive of the original scheme is
;;; implemented using its own version of apply, so when we feed it the
;;; procedure from 'our' scheme, it chokes and dies.


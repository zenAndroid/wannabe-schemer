; 2020-03-06 17:36 :: zenAndroid :: Combinate

((lambda (n)
   ((lambda (fact) (fact fact n))
    (lambda (ft k)
      (if (= k 1)
          1
          (* k (ft ft (- k 1)))))))
 10)

((lambda (n)
   ((lambda (fact) (fact fact 0 1 n))
    (lambda (ft a b c)
      (if (= c 0)
          b
          (ft ft b (+ a b) (- c 1))))))
 1022)

(define (f x)
  ((lambda (evenr oddr)
     (evenr evenr oddr x))
   (lambda (ev? od? n)
     (if (= n 0)
         #t
         (od? ev? od? (- n 1))))
   (lambda (ev? od? n)
     (if (= n 0)
         #f
         (ev? ev? od? (- n 1))))))

; Very cool, I kinda never expected this ... which is weird I know, but true nonetheless ..

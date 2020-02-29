; 2020-02-27 21:03 :: zenAndroid :: ... I am ... yikes at this point I am
; officially even worse than Dragon God ...

; (let* <bindings> <body>)


(define (let*->nested-lets exp)
  ; 2020-02-28 18:50 :: zenAndroid ::I don't even remember clearly my thought process at the time, jopefully my notes are clear enough :sweat:
  (define (iter bindings)
    (if (null? bindings)
      (let*-body exp)
      (make-let (first-binding bindings)
                (iter (rest-bindings)))))
  (iter (binding exp)))

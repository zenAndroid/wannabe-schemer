; 2020-02-22 23:07 :: zenAndroid ::  Nice, I came up with a solution, it seems
; to make sense, I hope it is the correct one.

(load "73-RC-circuit.scm")

(define zero-crossings
  (zen-stream-map 
    sign-change-detector
    sense-data
    (stream-cons (stream-first sense-data) sense-data)))

; Some people in the scheme wiki went with (stream-cons 0 sense-data) as the expression
; I think (stream-cons (stream-first sense-data) sense-data) makes more sense
; AND is compliant with the book since it'll sign-change-detector will output 0
; with that.

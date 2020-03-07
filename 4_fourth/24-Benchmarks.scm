; # 2020-03-07 11:56 :: zenAndroid :: Let me tell you a weird story
; 
; 
; So, when doing this I made changes to the REPL prompt that made it so that
; each time you ran an expression it'll tell you the time it took to evaluate
; it.
; 
; And than I defined fibonacci function in the naive way
; 
; and ran (fib 25) on the naive and analyzed version five times (not much but
; still gave me an idea)
; 
; Naive         | Analyzed 
;               | 
; 1- 35 seconds | 1- 21 seconds 
; 2- 32 seconds | 2- 20 seconds
; 3- 33 seconds | 3- 20 seconds
; 4- 33 seconds | 4- 20 seconds
; 5- 33 seconds | 5- 21 seconds
; 
; 
; So yeah, thats a slight improvement I suppose.
; 
; But the weird thing is, when I define fibonacci fucntion, TLDR the naive
; version runs faster (?????????????????????) I do not understand why, in other
; solutions online everything seems to run as expected, but for me its not ?
; maybe I made a mistake in the implementation (altho where I have no idea), or
; maybe the underlying implementation in gnu guile is weird ????
; 
; I doubt it, probably what is happening is that I made some wring assumption
; somewhere and I cant see it ...

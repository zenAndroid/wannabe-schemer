; 2020-03-07 18:31 :: zenAndroid :: Yeah, finally, really looking forward for lazy evaluation ...

; It is one of the exercises that I understood only by tracing through an example.
; 
; TLDR: The text version's output provides a function that's "ready to go" and
; that doesn't need to to perfoem else but the apply the analyzed procedures.
; 
; Meanwhile  all of what Alyssa's code does is analyze the individual pieces of
; the sequences and THEN call execute-seauence on the sequence  that consists
; of the INDIVIDUAL procedure in the seauence, it still needs to perform
; unnecessary work on execution time, whereas the original sequence analyzer
; does not.
; 
; 
; Another way to state this is to say that the version in the text analyzes bot
; the indidual parts and then the WHOLE.  Alyssa on the other hand does NOT
; analyze the entire sequence.

; Alyssa version is slightly better than the naive version, because at least
; the individual exoression are analyzed, but its not as optimal as analyzing
; the entire sequence.

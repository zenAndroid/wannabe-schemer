; 2020-02-19 20:25 :: zenAndroid ::  heh, is this going to require a fold ?

(load "54-FactorialsAsStreams.scm")

; I guess i'll start my attempt

; stream              stream-andmap       stream-empty?       stream-for-each     stream-ref          stream/c           
; stream*             stream-append       stream-filter       stream-length       stream-rest         stream?            
; stream->list        stream-cons         stream-first        stream-map          stream-tail        
; stream-add-between  stream-count        stream-fold         stream-ormap        stream-take        

(define (fold-stream stream procedure initial-value)
  (cond ((stream-empty? stream) initial-value)
        (else
          (fold-stream (stream-rest stream) procedure (procedure (stream-first stream) initial-value)))))


; TFW I'm starting to doubt I'll even use this ...

;; Yep, aint even gunna use this, now I just feel stupid.

(define (partial-sums s)
  (stream-cons (stream-first s) (add-streams (stream-rest s) (partial-sums s))))

; Yep, that was it, that was the ENTIRE SOLUTION , GODDAMNIT
; I need to get used to this tyoe of thinking ...


; Btw, I looked at a solution partially (HAH) but when I realized it could be
; solved using this approach, thankfully I retracted back to struggle with it
; on my own, I'm kinda sad that I had to do that, but at the same time, if I
; didnt, I would've wasted a lot of time ¯\_(ツ)_/¯

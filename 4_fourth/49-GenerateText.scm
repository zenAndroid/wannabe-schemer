; 2020-03-25 21:07 :: zenAndroid :: Nice stuff ...


; Exercise 4.49: Alyssa P. Hacker is more interested in generating interesting
; sentences than in parsing them. She reasons that by simply changing the
; procedure parse-word so that it ignores the “input sentence” and instead
; always succeeds and generates an appropriate word, we can use the programs we
; had built for parsing to do generation instead. Implement Alyssa’s idea, and
; show the first half-dozen or so sentences generated.258 

(parse '(the cat eats with the amazing class))

(load "00-AmbEval.scm")

(driver-loop)

(define (require p) (if (not p) (amb)))
(define (nth-elmt n a-list)
  (cond ((null? a-list) '())
        ((= n 0) (car a-list))
        (else (nth-elmt (- n 1) (cdr a-list)))))
(define (random-elmt word-list)
  (let ((index (random (length word-list))))
    (nth-elmt index word-list)))

(define nouns '(noun student professor detective idiot wizard fool man girl boy cat class sicp zenAndroid))

(define verbs '(verb studies lectures eats sleeps struggles dances reads writes pets cultivates))

(define articles '(article the a))

(define prepositions '(preposition for to in by with))

(define adjectives '(adjective evil heroic hungry blue amazing astonishing))

;; (define (parse-word word-list)
;;   (require (not (null? *unparsed*)))
;;   (set! *unparsed* (cdr *unparsed*))
;;   (list (car word-list) (random-elmt (cdr word-list))))
;; This version is better imo
;; It 'truly' generates stuff

(define (lamb a-list)
  (cond ((null? a-list) (amb))
        (else (amb (car a-list) (lamb (cdr a-list))))))

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) (cdr word-list)))
  (set! *unparsed* (cdr *unparsed*))
  (list (car word-list) (lamb (cdr word-list))))

(define *unparsed* '())
(define (parse input)
  (set! *unparsed* input)
  (let ((sent (parse-sentence)))
    (require (null? *unparsed*))
    sent))

(define (parse-prepositional-phrase)
  (list 'prep-phrase
        (parse-word prepositions)
        (parse-noun-phrase)))

(define (parse-sentence)
  (list 'sentence
         (parse-noun-phrase)
         (parse-verb-phrase)))

(define (parse-verb-phrase)
  (define (maybe-extend verb-phrase)
    (amb
     verb-phrase
     (maybe-extend
      (list 'verb-phrase
            verb-phrase
            (parse-prepositional-phrase)))))
  (maybe-extend (parse-word verbs)))

(define (parse-simple-noun-phrase)
  (amb (list 'simple-noun-phrase
             (parse-word articles)
             (parse-word nouns))
       (list 'simple-noun-phrase
             (parse-word articles)
             (parse-word adjectives)
             (parse-word nouns))))

(define (parse-noun-phrase)
  (define (maybe-extend noun-phrase)
    (amb
     noun-phrase
     (maybe-extend
      (list 'noun-phrase
            noun-phrase
            (parse-prepositional-phrase)))))
  (maybe-extend (parse-simple-noun-phrase)))

; These are generated by the version that chooses by random

; a   zenAndroid lectures
; the professor  eats
; the student   lectures
; a   student   eats
; a   professor  lectures
; the class     studies
; a   sicp      lectures
; the student   studies
; a   sicp      sleeps
; a   sicp      lectures
; a   zenAndroid lectures
; the professor  eats
; the cat       eats
; a   sicp      lectures
; the sicp      lectures
; the zenAndroid sleeps
; a   sicp      studies
; the student   lectures
; a   professor  lectures
; the class     lectures
; the student   sleeps
; a   zenAndroid sleeps
; the student   lectures
; the class     studies
; a   student   studies
; the student   sleeps
; the sicp      eats
; the student   sleeps
; a   student   eats
; a   cat       sleeps
; the sicp      lectures
; the student   sleeps
; a   class     lectures
; the class     eats
; a   sicp      studies
; a   cat       eats



; These types of things are genrated by th version that purely uses amb, probably the one the book wanted.
; the student studies for the evil student
; the student studies for the evil professor
; the student studies for the evil detective
; the student studies for the evil idiot

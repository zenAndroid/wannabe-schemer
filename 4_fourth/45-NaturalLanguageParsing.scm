; 2020-03-24 22:26 :: zenAndroid :: I've been extremely slow lately ... and I
; don't like it.

(load "00-AmbEval.scm")

(driver-loop)

(define (require p)
  (if (not p)
    (amb)))

(define nouns 
  '(noun student professor cat class))

(define verbs 
  '(verb studies lectures eats sleeps))

(define articles '(article the a))


; At the lowest level, parsing boils down to repeatedly checking that the next
; unparsed word is a member of the list of words for the required part of
; speech. To implement this, we maintain a global variable *unparsed*, which is
; the input that has not yet been parsed. Each time we check a word, we require
; that *unparsed* must be non-empty and that it should begin with a word from
; the designated list. If so, we remove that word from *unparsed* and return
; the word together with its part of speech (which is found at the head of the
; list):255

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) 
                 (cdr word-list)))
  (let ((found-word (car *unparsed*)))
    (set! *unparsed* (cdr *unparsed*))
    (list (car word-list) found-word)))

; To start the parsing, all we need to do is set *unparsed* to be the entire
; input, try to parse a sentence, and check that nothing is left over:

(define *unparsed* '())
(define (parse input)
  (set! *unparsed* input)
  (let ((sent (parse-sentence)))
    (require (null? *unparsed*))
    sent))

(define prepositions
  '(prep for to in by with))

; and define a prepositional phrase (e.g., “for the cat”) to be a preposition
; followed by a noun phrase:

(define (parse-prepositional-phrase)
  (list 'prep-phrase
        (parse-word prepositions)
        (parse-noun-phrase)))

; Now we can define a sentence to be a noun phrase followed by a verb phrase,
; where a verb phrase can be either a verb or a verb phrase extended by a
; prepositional phrase:256

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

; While we’re at it, we can also elaborate the definition of noun phrases to
; permit such things as “a cat in the class.” What we used to call a noun
; phrase, we’ll now call a simple noun phrase, and a noun phrase will now be
; either a simple noun phrase or a noun phrase extended by a prepositional
; phrase:

(define (parse-simple-noun-phrase)
  (list 'simple-noun-phrase
        (parse-word articles)
        (parse-word nouns)))

(define (parse-noun-phrase)
  (define (maybe-extend noun-phrase)
    (amb
     noun-phrase
     (maybe-extend
      (list 'noun-phrase
            noun-phrase
            (parse-prepositional-phrase)))))
  (maybe-extend (parse-simple-noun-phrase)))

;; ;; ;; ;;; Amb-Eval input:
;; ;; ;; (parse '(the student with the cat sleeps in the class))
;; ;; ;; 
;; ;; ;; ;;; Starting a new problem 
;; ;; ;; ;;; Amb-Eval value:
;; ;; ;; (sentence 
;; ;; ;;   (noun-phrase 
;; ;; ;;     (simple-noun-phrase 
;; ;; ;;       (article the) (noun student)) 
;; ;; ;;     (prep-phrase 
;; ;; ;;       (prep with) 
;; ;; ;;       (simple-noun-phrase 
;; ;; ;;         (article the) (noun cat)))) 
;; ;; ;;   (verb-phrase 
;; ;; ;;     (verb sleeps) 
;; ;; ;;     (prep-phrase 
;; ;; ;;       (prep in) 
;; ;; ;;       (simple-noun-phrase 
;; ;; ;;         (article the) (noun class)))))


;; Yey !

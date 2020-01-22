#! /usr/bin/racket -f

;; Alright, i'll be delving into the rational package now

;; 2020-01-22 12:52 :: zenAndroid 

(include "91-DivideYerTerms.scm")

(define p1 (make-poly
             'x
             (list
               (list 2 1)
               (list 0 1))))

(define p2 (make-poly
             'x
             (list
               (list 3 1)
               (list 0 1))))

(define rf (make-rat p2 p1))

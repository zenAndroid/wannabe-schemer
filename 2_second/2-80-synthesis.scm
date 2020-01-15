(require racket/include)

(require racket/trace)

(include "2-80-basicDefinitions.scm")

(include "2-80-sch-num.scm")

(include "2-80-rat.scm")

(include "2-80-rect.scm")

(include "2-80-polar.scm")

(include "2-80-complex.scm")


; installing the packages
(define MAIN-TABLE (install-rectangular-package '()))
(define MAIN-TABLE (install-scheme-number-package MAIN-TABLE))
(define MAIN-TABLE (install-rational-package MAIN-TABLE))
(define MAIN-TABLE (install-polar-package MAIN-TABLE))
(define MAIN-TABLE (install-complex-package MAIN-TABLE))


; as per exercice 2.77


(define MAIN-TABLE (put MAIN-TABLE 'magnitude '(complex) magnitude))
(define MAIN-TABLE (put MAIN-TABLE 'real-part '(complex) real-part))
(define MAIN-TABLE (put MAIN-TABLE 'angle '(complex) angle))
(define MAIN-TABLE (put MAIN-TABLE 'imag-part '(complex) imag-part))

; per exercice 2.79 and 2.80

(define MAIN-TABLE (put MAIN-TABLE 'equ? '(complex complex)
                        (lambda(x y)
                          (and (= (real-part x) (real-part y))
                               (= (imag-part x) (imag-part y))))))

(define MAIN-TABLE (put MAIN-TABLE 'equ? '(scheme-number scheme-number) =))

(define MAIN-TABLE (put MAIN-TABLE 'equ? '(rational rational)
                        (lambda(x y)
                          (= (* (numer x) (denom y))
                             (* (denom x) (numer y))))))

(define MAIN-TABLE (put MAIN-TABLE '=zero? '(scheme-number)
                        (lambda(x) (= 0 x))))

(define MAIN-TABLE (put MAIN-TABLE '=zero? '(complex)
                        (lambda(z) (and
                            (= (real-part z) 0 (imag-part z))))))

(define MAIN-TABLE (put MAIN-TABLE '=zero? '(rational)
                        (lambda(rat) (= (numer rat) 0))))

(define (equ? x y) (apply-generic 'equ? x y))
(define (=zero? x) (apply-generic '=zero? x))

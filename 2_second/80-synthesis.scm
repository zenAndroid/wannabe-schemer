(require racket/include)

(require racket/trace)

(include "80-basicDefinitions.scm")

(include "80-sch-num.scm")

(include "80-rat.scm")

(include "80-rect.scm")

(include "80-polar.scm")

(include "80-complex.scm")


; installing the packages
(define MAIN-TABLE (install-rectangular-package '()))
(define MAIN-TABLE (install-scheme-number-package MAIN-TABLE))
(define MAIN-TABLE (install-rational-package MAIN-TABLE))
(define MAIN-TABLE (install-polar-package MAIN-TABLE))
(define MAIN-TABLE (install-complex-package MAIN-TABLE))


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


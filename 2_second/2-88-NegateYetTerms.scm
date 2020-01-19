(require racket/trace)
(require racket/include)

(include "2-87-PolyZero.scm")

(define zero-pol (make-poly 'y zero-list))

(displayln pol)

(displayln (add pol poly-example))

(displayln zero-pol)

(=zero? zero-pol)

(displayln (add rqt (negate rqt)))

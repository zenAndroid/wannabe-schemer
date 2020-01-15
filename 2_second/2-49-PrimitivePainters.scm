(require sicp-pict) 

(define (make-vect x-coor y-coor)
  (cons x-coor y-coor))

(define (xcor-vect vect)
  (car vect))

(define (ycor-vect vect)
  (cdr vect))

(define (add-vect v1 v2)
  (make-vect
    (+ (xcor-vect v1) (xcor-vect v2))
    (+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2)
  (make-vect
    (- (xcor-vect v1) (xcor-vect v2))
    (- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect s v)
  (make-vect (* s (xcor-vect v)) (* s (ycor-vect v))))

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
      (origin-frame frame)
      (add-vect 
        (scale-vect (xcor-vect v)
                    (edge1-frame frame))
        (scale-vect (ycor-vect v)
                    (edge2-frame frame))))))

(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
      (lambda (segment)
        (draw-line
          ((frame-coord-map frame) 
           (start-segment segment))
          ((frame-coord-map frame) 
           (end-segment segment))))
      segment-list)))

(define make-segment cons)
(define start-segment car)
(define end-segment cdr)

(define outline
 (let ((bl (make-vect 0 0))
       (br (make-vect 0 1))
       (tl (make-vect 1 0))
       (tr (make-vect 1 1)))
  (segments->painter 
   (list (make-segment tl tr)
         (make-segment tl bl)
         (make-segment tr br)
         (make-segment br bl)))))


(define X-drawer
 (let ((bl (make-vect 0 0))
       (br (make-vect 0 1))
       (tl (make-vect 1 0))
       (tr (make-vect 1 1)))
  (segments->painter 
   (list (make-segment tl br)
         (make-segment bl tr)))))

; B = Bottom
; L = Left
; R = Right
; T = Top


(define crazy-diamond
 (let ((lp (make-vect 0.5 0))
       (tp (make-vect 1 0.5))
       (rp (make-vect 0.5 1))
       (bp (make-vect 0 0.5)))
  (segments->painter 
   (list (make-segment lp tp)
         (make-segment tp rp)
         (make-segment rp bp)
         (make-segment bp lp)))))

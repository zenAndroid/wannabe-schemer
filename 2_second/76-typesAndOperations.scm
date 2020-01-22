#lang scheme

; Three strategies,
;
; 1- Generic operation with explicit dispatch
; 2- Data-directed approach
; 3- Message passing style
;
; the exercise is asking to know what changes would be necessary under
; these styles
;
; Which organization would be most appropriate for a system in which new
; types must often be added?  Which would be most appropriate for a
; system in which new operations must often be added?
;
;
; For 1), the changes that must be made:
;
; 1-1 ) if there was a new way of representing complex numbers, we
; would have to add:
; - Add a check for this new type of the datum and deal with the
; specific cases individually
; 1-2 ) if there was a new operation to perfoem on complex numbers:
; - Create a new function that represents the operation and
; that also controls for all the posssible types and 
;
;
;
;
;
; 2-1) New type, Data directed approach:
; - Add new column to the table, and install a new package for the new
; type that includes all the implementations of the new operations
;
; 2-2) New operation, Data-directed approach:
; ;- Add a new line to the table and update each type's corresponding
; ;index with its respective implementation of the operation.
;
;
;
;
;
; 3-1) New type, Message passing style:
; - Add new function that dispatches depending on the operation
; IE add a new
; (define (newType op . args)
;     (define (dispatch op)
;       (cond ((eq? op 'operation-name)
;       foo-bar)
;       (...)))
;       dispatch)
;
; 3-2) New operation, Message passing style:
; - Add a new test for the operation-name in the body of the function of
; EVERY TYPE
; IE add a 
; (cond ((eq? op 'operation-name) foo-bar)
;       (...)))
; to every function body.

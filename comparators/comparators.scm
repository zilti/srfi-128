(declare
 (safe-globals)
 (specialize))

(module srfi-128 ()
  (import scheme)
  (cond-expand
   (chicken-6
    (import (scheme base))
    (import (scheme case-lambda))
    (import (chicken base))
    (import (chicken type))
    (import (chicken module))
    (import srfi-4)
    ;; FIXME: why is string-hash redefined?
    (import (except srfi-13 string-hash)))
   (chicken-5
    (import (chicken base))
    (import (chicken type))
    (import (chicken module))
    (import srfi-4)
    ;; FIXME: why is string-hash redefined?
    (import (except srfi-13 string-hash)))
   (else
    (import (only chicken use export include case-lambda error define-record-type
                  make-parameter parameterize : define-type))
    (use numbers)
    (use srfi-4)
    (use srfi-13)))

  (export comparator? comparator-ordered? comparator-hashable?)
  (export make-comparator
          make-pair-comparator make-list-comparator make-vector-comparator
          make-eq-comparator make-eqv-comparator make-equal-comparator)
  (export boolean-hash char-hash char-ci-hash
          string-hash string-ci-hash symbol-hash number-hash)
  (export make-default-comparator default-hash comparator-register-default!)
  (export comparator-test-type comparator-check-type comparator-hash)
  (export %salt% hash-bound hash-salt)
  (export =? <? >? <=? >=?)
  (export comparator-if<=>)
  (export comparator-type-test-predicate comparator-equality-predicate
          comparator-ordering-predicate comparator-hash-function)

  (define-type :comparator: (struct comparator))
  (define-type :type-test: (procedure (*) boolean))
  (define-type :comparison-test: (procedure (* *) boolean))
  (define-type :hash-code: fixnum)
  (define-type :hash-function: (procedure (*) :hash-code:))

  (cond-expand
    (chicken-6)
    (else
     (include "comparators/r7rs-shim.scm")))
  (include "comparators/comparators-impl.scm")
  (include "comparators/default.scm")

  ;; Chicken type declarations
  (: comparator? (* --> boolean : :comparator:))
  (: comparator-type-test-predicate (:comparator: --> :type-test:))
  (: comparator-equality-predicate (:comparator: --> :comparison-test:))
  (: comparator-ordering-predicate (:comparator: --> :comparison-test:))
  (: comparator-hash-function (:comparator: --> :hash-function:))
  (: comparator-ordered? (:comparator: --> boolean))
  (: comparator-hashable? (:comparator: --> boolean))
  (: make-comparator
   ((or true :type-test:)
    (or true :comparison-test:)
    (or false :comparison-test:)
    (or false :hash-function:)
    --> :comparator:))
  (: comparator-test-type (:comparator: * --> boolean))
  (: comparator-check-type (:comparator: * --> true))
  (: comparator-hash (:comparator: * --> :hash-code:))
  (: binary=? (:comparator: * * --> boolean))
  (: binary<? (:comparator: * * --> boolean))
  (: binary>? (:comparator: * * --> boolean))
  (: binary<=? (:comparator: * * --> boolean))
  (: binary>=? (:comparator: * * --> boolean))
  (: =? (:comparator: * * &rest * * --> boolean))
  (: <? (:comparator: * * &rest * * --> boolean))
  (: >? (:comparator: * * &rest * * --> boolean))
  (: <=? (:comparator: * * &rest * * --> boolean))
  (: >=? (:comparator: * * &rest * * --> boolean))
  (: boolean<? (boolean boolean --> boolean))
  (: boolean-hash (boolean --> :hash-code:))
  (: char-hash (char --> :hash-code:))
  (: char-ci-hash (char --> :hash-code:))
  (: number-hash (number --> :hash-code:))
  (: complex<? (number number --> boolean)) ;; FIXME
  (: string-ci-hash (string --> :hash-code:))
  (: symbol<? (symbol symbol --> boolean))
  (: symbol-hash (symbol --> :hash-code:))
  (: make-eq-comparator (--> :comparator:))
  (: make-eqv-comparator (--> :comparator:))
  (: make-equal-comparator (--> :comparator:))
  (: limit :hash-code:)
  (: make-pair-comparator (:comparator: :comparator: --> :comparator:))
  (: make-pair-type-test (:comparator: :comparator: --> :type-test:))
  (: make-pair=? (:comparator: :comparator: --> :comparison-test:))
  (: make-pair<? (:comparator: :comparator: --> :comparison-test:))
  (: make-hash (:comparator: :comparator: --> :hash-function:))
  (: make-list-comparator (:comparator: :type-test: :type-test: (procedure (*) *)  (procedure (*) *) --> :comparator:))
  (: make-vector-comparator (:comparator: :type-test: (procedure (*) fixnum) (procedure (* fixnum) *) --> :comparator:))
  (: string-hash (string --> :hash-code:))
  (: comparator-register-default! (:comparator: -> . *))
  (: default-hash (* --> :hash-code:))
  (: make-default-comparator (--> :comparator:))
)

;; aoc2015day07.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;

;;; --- Day 7: Some Assembly Required ---

;;; This year, Santa brought little Bobby Tables a set of wires and
;;; bitwise logic gates! Unfortunately, little Bobby is a little under
;;; the recommended age range, and he needs help assembling the
;;; circuit.

;;; Each wire has an identifier (some lowercase letters) and can carry
;;; a 16-bit signal (a number from 0 to 65535). A signal is provided
;;; to each wire by a gate, another wire, or some specific value. Each
;;; wire can only get a signal from one source, but can provide its
;;; signal to multiple destinations. A gate provides no signal until
;;; all of its inputs have a signal.

;;; The included instructions booklet describes how to connect the
;;; parts together: x AND y -> z means to connect wires x and y to an
;;; AND gate, and then connect its output to wire z.

;;; For example:

;;; 123 -> x means that the signal 123 is provided to wire x.
;;;
;;; x AND y -> z means that the bitwise AND of wire x and wire y is provided to wire z.

;;; p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and then provided to wire q.

;;; NOT e -> f means that the bitwise complement of the value from wire e is provided to wire f.

;;; Other possible gates include OR (bitwise OR) and RSHIFT
;;; (right-shift). If, for some reason, you'd like to emulate the
;;; circuit instead, almost all programming languages (for example, C,
;;; JavaScript, or Python) provide operators for these gates.

;;; For example, here is a simple circuit:

;;; 123 -> x
;;; 456 -> y
;;; x AND y -> d
;;; x OR y -> e
;;; x LSHIFT 2 -> f
;;; y RSHIFT 2 -> g
;;; NOT x -> h
;;; NOT y -> i
;;; After it is run, these are the signals on the wires:
;;;
;;; d: 72
;;; e: 507
;;; f: 492
;;; g: 114
;;; h: 65412
;;; i: 65079
;;; x: 123
;;; y: 456
;;;
;;; In little Bobby's kit's instructions booklet (provided as your puzzle input), what signal is ultimately provided to wire a?

(module aoc2015day07
    (aoc2015day07::part1
     aoc2015day07::part2)

  (import scheme
          matchable
          aoc-utils)

  (define wiring1 '((a b :rshift 1) (b c :or d) (c 5) (d :not e) (e 16)))
  (define wiring2 '((a b) (b 5)))
  (define wiring3 '((a 1)))

  (define (evaluate-wire symbol wire-table)
    (match-let loop ([(s . v) (assq symbol wire-table)]
                     [full '()])
      (cond
       [(number? (car v)) (loop (wire-table full))])
      full))

  (define (aoc2015day07::part1)
    0)

  (define (aoc2015day07::part2)
    0)


  (define (rember* a l)
    (cond [(null? l)
           (begin (print "list is null, returning ()")
                  (quote ()))]
          [(atom? (car l))
           (begin (print "(car l) is an atom: " (car l))
                  (cond [(eq? (car l) a)
                         (begin (print "... and it's equal to " a ", so recurring with (cdr l): " (cdr l))
                                (rember* a (cdr l)))]
                        [else
                         (begin (print "... not " a ", so cons'ing it to recursion with (cdr l): " (cdr l))
                                (cons (car l) (rember* a (cdr l))))]))]
          [else
           (begin (print "" (car l) " is not an atom, so cons'ing the recursion of [(rember* a (car l))], (car l): "
                         (car l) " to [(rember* a (cdr l))], (cdr l): " (cdr l))
                  (cons (rember* a (car l)) (rember* a (cdr l))))]))

  )

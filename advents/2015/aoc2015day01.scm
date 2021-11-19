;; aoc2015day01.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;

;;;```
;;; --- Day 1: Not Quite Lisp ---
;;; Santa is trying to deliver presents in a large apartment building, but
;;; he can't find the right floor - the directions he got are a little
;;; confusing. He starts on the ground floor (floor 0) and then follows
;;; the instructions one character at a time.
;;;
;;; An opening parenthesis, (, means he should go up one floor, and a
;;; closing parenthesis, ), means he should go down one floor.
;;;
;;; The apartment building is very tall, and the basement is very deep; he
;;; will never find the top or bottom floors.
;;;
;;; For example:
;;;
;;; (()) and ()() both result in floor 0.
;;; ((( and (()(()( both result in floor 3.
;;; ))((((( also results in floor 3.
;;; ()) and ))( both result in floor -1 (the first basement level).
;;; ))) and )())()) both result in floor -3.
;;; To what floor do the instructions take Santa?
;;;```
;;;```
;;;
;;; --- Part Two ---
;;;
;;; Now, given the same instructions, find the position of the first
;;; character that causes him to enter the basement (floor -1). The
;;; first character in the instructions has position 1, the second
;;; character has position 2, and so on.
;;;
;;; For example:
;;;   1. ) causes him to enter the basement at character position 1.
;;;   2. ()()) causes him to enter the basement at character position 5.
;;;
;;; What is the position of the character that causes Santa to first
;;; enter the basement?
;;;```
(module aoc2015day01
    (aoc2015day01::part1
     aoc2015day01::part2)

  (import scheme (chicken base)
          srfi-1
          aoc-utils)

  (define (aoc2015day01::part1)
    (floor-level (string->list (first (aoc-lines 2015 1)))))

  (define (aoc2015day01::part2)
    (floor-level-matched (floor-levels (string->list (first (aoc-lines 2015 1)))) -1))

  (define (floor-level moves)
    (fold
     (lambda (element count)
       (cond
        [(equal? #\) element) (- count 1)]
        [(equal? #\( element) (+ count 1)]
        [else count]))
     0
     moves))

  (define (floor-levels moves)
    (let loop ([moves moves] [levels '(0)] [current-level 0])
      (cond
       [(null? moves) (reverse levels)]
       [(equal? #\) (car moves)) (loop (cdr moves) (cons (sub1 current-level) levels) (sub1 current-level))]
       [(equal? #\( (car moves)) (loop (cdr moves) (cons (add1 current-level) levels) (add1 current-level))]
       [else (loop (cdr moves) levels current-level)])))

  ;;; return which element index of list matches the given floor number.
  ;;; automatically gives 1 based index because the 0th element is floor 0 before
  ;;; any instructions begin.
  (define (floor-level-matched levels floor)
    (list-index (lambda (l) (eq? floor l)) levels))
  )

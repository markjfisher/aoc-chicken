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

  (import scheme format
          (streams utils)
          srfi-1 srfi-41
          aoc-files)

  (define (aoc2015day01::part1)
    (floor-level (aoc-resource-stream 2015 1)))

  (define (aoc2015day01::part2)
    (floor-level-matched (floor-levels (aoc-resource-stream 2015 1)) -1))

  ;; turn into a list and take the last, slowest at 10-16ms
  (define (floor-level-slowest stream)
    (last (stream->list (floor-levels stream))))

  ;; drop everything but the last item in the stream, faster but still 11ms instead of 5
  (define (floor-level-slow stream)
    (let* ([levels (floor-levels stream)]
           [c (stream-length levels)]
           [substream (stream-drop (- c 1) levels)])
      (stream-car substream)))

  ;; fastest is just doing the fold, ~5ms
  (define (floor-level stream)
    (stream-fold
     (lambda (count element)
       (cond
        [(equal? #\) element) (- count 1)]
        [(equal? #\( element) (+ count 1)]
        [else count]))
     0
     stream))

  ;;; return a stream of current floor level being visited converted from
  ;;; the incoming stream of instructions
  (define (floor-levels stream)
    (stream-scan
     (lambda (count element)
       (cond
        [(equal? #\) element) (- count 1)]
        [(equal? #\( element) (+ count 1)]
        [else count]))
     0
     stream))

  ;;; return which element index of stream matches the given floor number.
  ;;; automatically gives 1 based index because the 0th element is floor 0 before
  ;;; any instructions begin.
  (define (floor-level-matched stream floor)
    (stream-find eq? floor stream))
  )

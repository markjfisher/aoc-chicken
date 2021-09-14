;; aoc2015day06.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;


;;; --- Day 6: Probably a Fire Hazard ---
;;;
;;; Because your neighbors keep defeating you in the holiday house
;;; decorating contest year after year, you've decided to deploy one
;;; million lights in a 1000x1000 grid.
;;;
;;; Furthermore, because you've been especially nice this year, Santa
;;; has mailed you instructions on how to display the ideal lighting
;;; configuration.
;;;
;;; Lights in your grid are numbered from 0 to 999 in each direction;
;;; the lights at each corner are at 0,0, 0,999, 999,999, and
;;; 999,0. The instructions include whether to turn on, turn off, or
;;; toggle various inclusive ranges given as coordinate pairs. Each
;;; coordinate pair represents opposite corners of a rectangle,
;;; inclusive; a coordinate pair like 0,0 through 2,2 therefore refers
;;; to 9 lights in a 3x3 square. The lights all start turned off.
;;;
;;; To defeat your neighbors this year, all you have to do is set up
;;; your lights by doing the instructions Santa sent you in order.
;;;
;;; For example:
;;;
;;; - turn on 0,0 through 999,999 would turn on (or leave on) every
;;; light.
;;;
;;; - toggle 0,0 through 999,0 would toggle the first line of 1000
;;; lights, turning off the ones that were on, and turning on the ones
;;; that were off.
;;;
;;; - turn off 499,499 through 500,500 would turn off (or leave off)
;;; the middle four lights.
;;;
;;; After following the instructions, how many lights are lit?

;;; --- Part Two ---
;;;
;;; You just finish implementing your winning light pattern when you
;;; realize you mistranslated Santa's message from Ancient Nordic
;;; Elvish.
;;;
;;; The light grid you bought actually has individual brightness
;;; controls; each light can have a brightness of zero or more. The
;;; lights all start at zero.
;;;
;;; The phrase turn on actually means that you should increase the
;;; brightness of those lights by 1.
;;;
;;; The phrase turn off actually means that you should decrease the
;;; brightness of those lights by 1, to a minimum of zero.
;;;
;;; The phrase toggle actually means that you should increase the
;;; brightness of those lights by 2.
;;;
;;; What is the total brightness of all lights combined after
;;; following Santa's instructions?
;;;
;;; For example:
;;;
;;; turn on 0,0 through 0,0 would increase the total brightness by 1.
;;;
;;; toggle 0,0 through 999,999 would increase the total brightness by 2000000.

(module aoc2015day06
    (aoc2015day06::part1
     aoc2015day06::part2)

  (import scheme format
          (streams utils) (chicken base) (chicken fixnum)
          srfi-1 srfi-13 srfi-41 srfi-113 srfi-128 srfi-179
          list-comprehensions matchable regex-case
          aoc-utils)

  (define (aoc2015day06::part1)
    (let ([lights (array-copy (make-array (make-interval '#(1000 1000)) (constantly 0)))])
      (stream-for-each (lambda (line)
                         (and (not (string-null? line))
                              (match-let ([(i lx ly ux uy) (convert-line-to-instruction line)])
                                (array-blit lights i lx ly ux uy))))
                       (aoc-resource-stream-lines 2015 6))
      (array-reduce + lights)))

  (define (aoc2015day06::part2x) 0)

  (define (aoc2015day06::part2)
    (let ([lights (array-copy (make-array (make-interval '#(1000 1000)) (constantly 0)))])
      (stream-for-each (lambda (line)
                         (and (not (string-null? line))
                              (match-let ([(i lx ly ux uy) (convert-line-to-instruction line)])
                                (array-blit-2 lights i lx ly ux uy))))
                       (aoc-resource-stream-lines 2015 6))
      (array-reduce + lights)))


  (define line-regex "(turn on|turn off|toggle) ([0-9]+),([0-9]+) through ([0-9]+),([0-9]+)")

  ;;; convert a line of the format: "turn on 887,9 through 959,629"
  ;;; into an instruction of format: (:on 887 9 959 629)
  (define (convert-line-to-instruction line)
    ;;(print "line: " line)
    (match-let* ([(i a b c d)
                  (regex-case line
                    [line-regex (all i a b c d)
                                (list i (string->number a) (string->number b) (string->number c) (string->number d))])]
                 [instruction
                  (cond [(string=? "turn on" i) ':on]
                        [(string=? "turn off" i) ':off]
                        [else ':toggle])])
      (list instruction a b c d)))


  ;;; change the array a in the region of (lx,ly) to (ux,uy)
  ;;; instruction is:
  ;;;  ':on      - set value to 1 in region
  ;;;  ':off     - set value to 0 in region
  ;;;  ':toggle  - flip the value in region
  ;;; This works by creating a subarray of the array in the area specified, and mapping values to it based on instruction given
  (define (array-blit a instruction lx ly ux uy)
    (let ([subarray (array-extract a (make-interval (vector lx ly) (vector (fx+ 1 ux) (fx+ 1 uy))))])
      (array-assign!
       subarray
       (array-map
        (lambda (x)
          (cond [(eq? ':on instruction) 1]
                [(eq? ':off instruction) 0]
                [else (fx- 1 x)]))
        subarray))))

  ;;; part 2 version of translating instructions to actions on the array
  (define (array-blit-2 a instruction lx ly ux uy)
    (let ([subarray (array-extract a (make-interval (vector lx ly) (vector (fx+ 1 ux) (fx+ 1 uy))))])
      (array-assign!
       subarray
       (array-map
        (lambda (x)
          (cond [(eq? ':on instruction) (fx+ x 1)]
                [(eq? ':off instruction) (if (fx> x 0) (fx- x 1) 0)]
                [else (fx+ 2 x)]))
        subarray))))

  )

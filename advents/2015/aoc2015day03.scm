;; aoc2015day03.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;

;;; --- Day 3: Perfectly Spherical Houses in a Vacuum ---
;;;
;;; Santa is delivering presents to an infinite two-dimensional grid of houses.
;;;
;;; He begins by delivering a present to the house at his starting
;;; location, and then an elf at the North Pole calls him via radio
;;; and tells him where to move next. Moves are always exactly one
;;; house to the north (^), south (v), east (>), or west (<). After
;;; each move, he delivers another present to the house at his new
;;; location.
;;;
;;; However, the elf back at the north pole has had a little too much
;;; eggnog, and so his directions are a little off, and Santa ends up
;;; visiting some houses more than once. How many houses receive at
;;; least one present?
;;;
;;; For example:
;;;
;;; > delivers presents to 2 houses: one at the starting location, and
;;; one to the east.
;;;
;;; ^>v< delivers presents to 4 houses in a square, including twice to
;;; the house at his starting/ending location.
;;;
;;; ^v^v^v^v^v delivers a bunch of presents to some very lucky children
;;; at only 2 houses.
;;;

(module aoc2015day03
    (aoc2015day03::part1
     aoc2015day03::part2)

  (import scheme format
          (chicken base) (chicken string) (chicken sort)
          (streams utils) (streams derived)
          srfi-1 srfi-13 srfi-41 srfi-113 srfi-128
          matchable
          aoc-files)

  (define (aoc2015day03::part1)
    (let ([location-set (stream-to-location-set (direction-to-location-stream (aoc-resource-stream 2015 3)))])
      (set-size location-set)))

  (define (aoc2015day03::part2)
    0)

  (define (stream-to-location-set stream)
    (stream-fold
     (lambda (s l) (set-adjoin s l))
     (set (make-default-comparator) '(0 0))
     stream))

  (define (loc-west l)
    (match-let ([(x y) l])
      (list (- x 1) y)))

  (define (loc-east l)
    (match-let ([(x y) l])
      (list (+ x 1) y)))

  (define (loc-north l)
    (match-let ([(x y) l])
      (list x (+ y 1))))

  (define (loc-south l)
    (match-let ([(x y) l])
      (list x (- y 1))))

  ;;; convert the incoming stream of character directions (^ < > v)
  (define (direction-to-location-stream stream)
    (stream-scan
     (lambda (l element)
       (cond
        [(equal? #\< element) (loc-west l)]
        [(equal? #\> element) (loc-east l)]
        [(equal? #\^ element) (loc-north l)]
        [(equal? #\v element) (loc-south l)]
        [else l]))
     '(0 0)
     stream))
  )

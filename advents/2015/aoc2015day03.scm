;; aoc2015day03.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;

;;; ```
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
;;; --- Part Two ---
;;;
;;; The next year, to speed up the process, Santa creates a robot
;;; version of himself, Robo-Santa, to deliver presents with him.
;;;
;;; Santa and Robo-Santa start at the same location (delivering two
;;; presents to the same starting house), then take turns moving based
;;; on instructions from the elf, who is eggnoggedly reading from the
;;; same script as the previous year.
;;;
;;; This year, how many houses receive at least one present?
;;; ```
(module aoc2015day03
    (aoc2015day03::part1
     aoc2015day03::part2)

  (import scheme format
          (chicken base) (chicken string) (chicken sort)
          srfi-1 srfi-13 srfi-113 srfi-128
          matchable
          aoc-utils)

  ;; we need to use the same comparator for both sets.
  (define my-comparator (make-default-comparator))

  (define (aoc2015day03::part1)
    (set-size (follow-dirs (string->list (first (aoc-lines 2015 3))))))

  (define (aoc2015day03::part2)
    (set-size (follow-dirs-2 (string->list (first (aoc-lines 2015 3))))))

  ;; a map of direction instruction to offset in x,y coordinates. use assq to lookup entries.
  (define dir-to-offset-map '((#\< -1 0) (#\> 1 0) (#\^ 0 1) (#\v 0 -1)))

  ;; look up the direction "d" in the map, and return the offset values
  ;; (dir-to-offset #\<) ;; (-1 0)
  (define (dir-to-offset d)
    (cdr (assq d dir-to-offset-map)))

  ;; return the set of houses visited by a set of directions starting at 0,0
  (define (follow-dirs dirs)
    (let loop ([ds dirs] [houses (set my-comparator '(0 0))] [locx 0] [locy 0])
      (cond [(null? ds) houses]
            [else
             (match-let* ([(xo yo) (dir-to-offset (car ds))]
                          [newx (+ xo locx)]
                          [newy (+ yo locy)])
               (loop (cdr ds) (set-adjoin! houses (list newx newy)) newx newy))])))

  ;; track whose turn it is to move (santa, robot), and move them appropriately.
  ;; This is faster than splitting directions into 2 lists and creating 2 sets of houses then merging them, as we don't
  ;; have to split, and the final merge is quite expensive.
  (define (follow-dirs-2 dirs)
    (let loop ([ds dirs] [houses (set my-comparator '(0 0))] [sx 0] [sy 0] [rx 0] [ry 0] [turn 0])
      (cond [(null? ds) houses]
            [else
             (match-let* ([(xo yo) (dir-to-offset (car ds))]
                          [newsx (if (= 0 turn) (+ xo sx) sx)]
                          [newsy (if (= 0 turn) (+ yo sy) sy)]
                          [newrx (if (= 1 turn) (+ xo rx) rx)]
                          [newry (if (= 1 turn) (+ yo ry) ry)])
               (loop (cdr ds) (set-adjoin! houses (if (= 0 turn) (list newsx newsy) (list newrx newry))) newsx newsy newrx newry (- 1 turn)))])))

  )

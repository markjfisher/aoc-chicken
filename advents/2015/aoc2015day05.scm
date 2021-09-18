;; aoc2015day04.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;


;;; --- Day 5: Doesn't He Have Intern-Elves For This? ---
;;;
;;; Santa needs help figuring out which strings in his text file are naughty or nice.
;;;
;;; A nice string is one with all of the following properties:
;;;
;;; - It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
;;; - It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
;;; - It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
;;;
;;; For example:
;;;
;;; - ugknbfddgicrmopn is nice because it has at least three vowels
;;;   (u...i...o...), a double letter (...dd...), and none of the disallowed substrings.
;;; - aaa is nice because it has at least three vowels and a double letter, even though
;;;   the letters used by different rules overlap.
;;; - jchzalrnumimnmhp is naughty because it has no double letter.
;;; - haegwjzuvuyypxyu is naughty because it contains the string xy.
;;; - dvszwmarrgswjxmb is naughty because it contains only one vowel.
;;;
;;; How many strings are nice?

;;; --- Part Two ---
;;;
;;; Realizing the error of his ways, Santa has switched to a better
;;; model of determining whether a string is naughty or nice. None of
;;; the old rules apply, as they are all clearly ridiculous.

;;; Now, a nice string is one with all of the following properties:

;;; - It contains a pair of any two letters that appears at least twice
;;;   in the string without overlapping, like xyxy (xy) or aabcdefgaa
;;;   (aa), but not like aaa (aa, but it overlaps).
;;;
;;; - It contains at least one letter which repeats with exactly one
;;;   letter between them, like xyx, abcdefeghi (efe), or even aaa.
;;;
;;; For example:
;;;
;;; qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice
;;; (qj) and a letter that repeats with exactly one letter between
;;; them (zxz).
;;;
;;; xxyxx is nice because it has a pair that appears twice and a
;;; letter that repeats with one between, even though the letters used
;;; by each rule overlap.
;;;
;;; uurcxstgmygtbstg is naughty because it has a pair (tg) but no
;;; repeat with a single letter between them.
;;;
;;; ieodomkazucvgmuy is naughty because it has a repeating letter with
;;; one between (odo), but no pair that appears twice.
;;;
;;; How many strings are nice under these new rules?

(module aoc2015day05
    (aoc2015day05::part1
     aoc2015day05::part2)

  (import scheme format
          (chicken base) (chicken string)
          srfi-1 srfi-13
          aoc-utils
          )

  (define banned-p1 (list "ab" "cd" "pq" "xy"))

  (define (aoc2015day05::part1)
    (fold (lambda (word accum)
            (if (and (has-at-least-three-vowels? word)
                     (has-double-letter? word)
                     (not (contains-banned-sequence? word banned-p1)))
                (add1 accum)
                accum))
          0
          (aoc-lines 2015 5)))

  (define (aoc2015day05::part2)
    (fold (lambda (word accum)
            (if (string-null? word)
                accum
                (if (and (contains-duplicate-pair? word)
                         (contains-repeat-char-with-one-between? word))
                    (add1 accum)
                    accum)))
          0
          (aoc-lines 2015 5)))

  ;;; old school little-schemer style functions
  (define (has-at-least-three-vowels? s)
    (let loop ([str (string->list s)]
               [n 0])
      (cond [(= 3 n) #t]
            [(null? str) #f]
            [(or (eq? (car str) #\a)
                 (eq? (car str) #\e)
                 (eq? (car str) #\i)
                 (eq? (car str) #\o)
                 (eq? (car str) #\u))
             (loop (cdr str) (add1 n))]
            [else (loop (cdr str) n)])))

  (define (has-double-letter? s)
    (let loop ([str (string->list s)]
               [last-char #f])
      (cond [(null? str) #f]
            [(eq? (car str) last-char) #t]
            [else (loop (cdr str) (car str))])))

  (define (contains-banned-sequence? str banned)
    (any (lambda (s) (string-contains str s)) banned))

  (define (contains-duplicate-pair? s)
    (let loop ([str (string-drop s 2)] [pair (string-take s 2)])
      (cond [(< (string-length str) 2) #f]
            [(string-contains str pair) #t]
            [else (loop (string-drop str 1) (conc (string-drop pair 1) (string-take str 1)))])))

  (define (contains-repeat-char-with-one-between? s)
    (let loop ([str (string-drop s 1)] [char (string-take s 1)])
      (cond [(< (string-length str) 2) #f]
            [(equal? (string-take (string-drop str 1) 1) char) #t]
            [else (loop (string-drop str 1) (string-take str 1))])))

  )

;; advent2015.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;

(import scheme
        (chicken base) (chicken platform) (chicken time)
        format matchable
        srfi-1
        aoc2015day01
        )

(define (advent2015::run)
  (match-let ([format-string "~6a: ~33a ~33a ~9a ~9a ~9a\n"]
              [(td1p1 rd1p1) (time-op aoc2015day01::part1)]
              [(td1p2 rd1p2) (time-op aoc2015day01::part2)]
        )
    (begin (format #t format-string "Day" "Part 1" "Part 2" "Time" "P1" "P2")
           (format #t format-string "01" rd1p1 rd1p2 (+ td1p1 td1p2) td1p1 td1p2)
           )))

(define (time-op f)
  (let ([start (current-process-milliseconds)]
        [result (f)]
        [end (current-process-milliseconds)])
    (list (- end start) result)))

(display (advent2015::run))

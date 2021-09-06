;; advent2015.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;

(import scheme
        (chicken base) (chicken platform) (chicken time)
        format matchable
        srfi-1
        aoc2015day01
        aoc2015day02
        aoc2015day03
        aoc2015day04
        )

(define (advent2015::run)
  (match-let ([format-string "~6a:  ~33a ~33a ~9a ~9a ~9a\n"]
              [(td1p1 rd1p1) (time-op aoc2015day01::part1)]
              [(td1p2 rd1p2) (time-op aoc2015day01::part2)]
              [(td2p1 rd2p1) (time-op aoc2015day02::part1)]
              [(td2p2 rd2p2) (time-op aoc2015day02::part2)]
              [(td3p1 rd3p1) (time-op aoc2015day03::part1)]
              [(td3p2 rd3p2) (time-op aoc2015day03::part2)]
              [(td4p1 rd4p1) (time-op aoc2015day04::part1)]
              [(td4p2 rd4p2) (time-op aoc2015day04::part2)]
        )
    (begin (format #t format-string "Day" "Part 1" "Part 2" "Time" "P1" "P2")
           (format #t format-string "01" rd1p1 rd1p2 (+ td1p1 td1p2) td1p1 td1p2)
           (format #t format-string "02" rd2p1 rd2p2 (+ td2p1 td2p2) td2p1 td2p2)
           (format #t format-string "03" rd3p1 rd3p2 (+ td3p1 td3p2) td3p1 td3p2)
           (format #t format-string "04" rd4p1 rd4p2 (+ td4p1 td4p2) td4p1 td4p2)
           )))

(define (time-op f)
  (let ([start (current-process-milliseconds)]
        [result (f)]
        [end (current-process-milliseconds)])
    (list (- end start) result)))

(display (advent2015::run))

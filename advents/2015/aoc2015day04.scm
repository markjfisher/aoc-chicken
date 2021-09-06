;; aoc2015day04.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;

(module aoc2015day04
    (aoc2015day04::part1
     aoc2015day04::part2)

  (import scheme format
          (chicken base) (chicken string) (chicken sort)
          (only (chicken random) pseudo-random-integer)
          (streams utils) (streams derived)
          srfi-1 srfi-13 srfi-18 srfi-41 srfi-113 srfi-128
          matchable
          gochan simple-md5 miscmacros
          )

  (define secret "bgvyzdsv")

  (define (aoc2015day04::part1)
    (find-hash "00000" 254570))

  (define (aoc2015day04::part2)
    (find-hash "000000" 1038730))

  (define (info . args) (apply print (cons (current-thread) (cons " " args))))

  (define (hash-tester match listen-chan reply-chan found-chan)
    (let loop ()
      (gochan-select
       ((listen-chan -> num)
        (if (substring=? (string->md5sum (conc secret num)) match 0 0 (string-length match))
            (gochan-send found-chan num))
        (gochan-send reply-chan num)
        (loop)))))

  (define (find-hash match start-guess)
    (let ([worker-chan (gochan 200)]
          [result-chan (gochan 200)]
          [found-chan (gochan 0)]
          [block-size 200]
          [result 0])
      (repeat block-size (go (hash-tester match worker-chan result-chan found-chan)))

      (let loop ([num start-guess]
                 [running #t])
        (if running
            (begin (repeat* block-size (gochan-send worker-chan (+ num it)))
                   (let block ([count 0])
                     (if (and running (< count block-size))
                         (gochan-select
                          ([result-chan -> msg]
                           (block (add1 count)))
                          ([found-chan -> msg]
                           (loop msg #f)))
                         (loop (+ block-size num) running))))
            (set! result num))
        (gochan-close worker-chan)
        (gochan-close result-chan)
        (thread-sleep! (/ 100 1000)))
      result))

  )

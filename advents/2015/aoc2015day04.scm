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
          matchable gochan simple-md5 miscmacros md5 message-digest-byte-vector simple-loops
          )

  (define secret "bgvyzdsv")
  (define prim (md5-primitive))

  (define (aoc2015day04::part1)
    ;; (find-hash "00000" 254570)
    (find-hash "00000" 0)
    ;; (direct-hashing "00000" 5)
    )

  (define (aoc2015day04::part2)
    ;; (find-hash "000000" 1038730)
    ;; (find-hash "000000" 0)
    (direct-hashing "000000" 6)
    )

  ;; this is SO much faster than the gochan version!
  (define (direct-hashing match length)
    (let ([n 0]
          [prim (md5-primitive)])
      (do-until (substring=? (message-digest-string prim (conc secret n)) match 0 0 length)
                (set! n (add1 n)))
      n)
    )

  (define (info . args) (apply print (cons (current-thread) (cons " " args))))

  (define (hash-tester match listen-chan reply-chan found-chan)
    (let ([strlen (string-length match)])
      (let loop ()
        (gochan-select
         ((listen-chan -> num)
          (if (substring=? (message-digest-string prim (conc secret num)) match 0 0 strlen)
              (gochan-send found-chan num))
          (gochan-send reply-chan num)
          (loop))))))

  (define (find-hash match start-guess)
    (let* ([block-size 50000]
           [worker-chan (gochan block-size)]
           [result-chan (gochan block-size)]
           [found-chan (gochan 0)]
           [result 0])
      (repeat 8 (go (hash-tester match worker-chan result-chan found-chan)))

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

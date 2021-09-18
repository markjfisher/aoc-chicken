;; aoc2015day04.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;

(module aoc2015day04
    (aoc2015day04::part1
     aoc2015day04::part2)

  (import scheme format
          (chicken base) (chicken string) (chicken sort)
          srfi-1 srfi-4 srfi-13 srfi-18 srfi-113 srfi-128 srfi-151
          matchable miscmacros message-digest-basic simple-loops md5
          )

  (define secret "bgvyzdsv")

  (define (aoc2015day04::part1)
    (hash-test-byte-loop five-leading-zeros? 0))

  (define (aoc2015day04::part2)
    (hash-test-byte-loop six-leading-zeros? 254575)) ;; slightly cheating, but it must be at least as big as answer to part1

  ;; using simple string checks.
  ;; this is SO much faster than the gochan version!

  (define (hash-test-str match length)
    (let ([n 0]
          [prim (md5-primitive)])
      (do-until (substring=? (message-digest-string prim (conc secret n)) match 0 0 length)
                (set! n (add1 n)))
      n))

  ;; Using byte vectors for efficiency
  (define (five-leading-zeros? u8v)
    (and (zero? (u8vector-ref u8v 0))
         (zero? (u8vector-ref u8v 1))
         (zero? (bitwise-and (u8vector-ref u8v 2) 240))))

  (define (six-leading-zeros? u8v)
    (and (zero? (u8vector-ref u8v 0))
         (zero? (u8vector-ref u8v 1))
         (zero? (u8vector-ref u8v 2))))

  ;; even quicker by using constant buffer, and testing bytes directly
  (define (hash-test-byte zero-test start)
    (let ([n start]
          [prim (md5-primitive)]
          [buffer (make-u8vector 16 0)])
      (do-until (zero-test (message-digest-string! prim (conc secret n) buffer))
                (set! n (add1 n)))
      n))

  ;; roughly same as using do-until, but using little-schema type looping, has 1 extra zero-test than needed
  ;; first run was faster than above, but running multiple times averaged same.
  (define (hash-test-byte-loop zero-test start)
    (let loop ([n start] [prim (md5-primitive)] [buffer (make-u8vector 16 255)])
      (cond [(zero-test buffer) (sub1 n)]
            [else (loop (add1 n) prim (message-digest-string! prim (conc secret n) buffer))])))

  )

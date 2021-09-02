;; aoc2015day02.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;

(module aoc2015day02
    (aoc2015day02::part1
     aoc2015day02::part2)

  (import scheme format
          (chicken base) (chicken string) (chicken sort)
          (streams utils) (streams derived)
          srfi-1 srfi-13 srfi-41
          matchable
          aoc-files)

  (define (aoc2015day02::part1)
    (stream-fold (lambda (s x) (+ s x))
                 0
                 (surface-area-stream (aoc-resource-stream-lines 2015 2))))

  (define (aoc2015day02::part2)
    1)

  ;; from a stream of values like 2x3x4, extract the dimensions to l,w,h and then
  ;; create a stream of values that represent all the surface areas ADDED for a given l x w x h
  ;; which are 2*l*w, 2*w*h, 2*h*l, (min l,w,h) * (2nd-min l,w,h)
  (define (surface-area-stream stream)
    (stream-map (lambda (lwh)
                  (if (string-null? lwh)
                      0
                      (match-let* ([(l w h) (map string->number (string-split lwh "x"))]
                                   [(a b) (take (sort (list l w h) <) 2)])
                        (+ (* 2 l w) (* 2 w h) (* 2 h l) (* a b)))))
                stream))

  )

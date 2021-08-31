;; aoc-files.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;

;; -----------------------------------------
;;; # AOC File & Stream Handling Module
;; -----------------------------------------

(module aoc-files
    (aoc-resource-stream)

  (import scheme)
  (import (chicken base))
  (import srfi-41) ;; streams

  ;; ----------------------------------------------------
  ;;; ## aoc-resource-stream
  ;; ----------------------------------------------------
  ;;; return a stream for given YEAR DAY values from resource dir
  (define (aoc-resource-stream year day)
    (print "foo"))

  ) ;; end of aoc-files module

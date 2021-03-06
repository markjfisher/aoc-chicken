;; utils.scm
;; -*- mode: Scheme; tab-width: 2; -*- ;;

(module aoc-utils
    (aoc-resource-stream
     aoc-resource-stream-lines
     aoc-lines)

  (import scheme
          (chicken base) (chicken format) (chicken io)
          (streams utils) (streams derived)
          srfi-41 (streams utils))

  ;; ----------------------------------------------------
  ;;; ## aoc-resource-stream
  ;; ----------------------------------------------------
  ;;; return a stream of chars for given YEAR DAY resource file
  ;;; ```scheme
  ;;; ; get the resource for 2015 day 1
  ;;; (let ((fs (aoc-resource-stream 2015 1)))
  ;;;   ...)
  ;;; <lazy stream = (#\a #\b #\c ... from resource file)>
  ;;; ```
  (define (aoc-resource-stream year day)
    (file->stream (sprintf "~a/resources/day~a.txt" year day)))


  ;;; return a stream of lines for given YEAR DAY resource file
  (define (aoc-resource-stream-lines year day)
    (stream-map (lambda (s)
                  (list->string (stream->list s)))
                (lines (aoc-resource-stream year day))))

  (define (breakon a)
    (stream-lambda (x xss)
                   (if (equal? a x)
                       (stream-append (stream (stream)) xss)
                       (stream-append
                        (stream (stream-append
                                 (stream x) (stream-car xss)))
                        (stream-cdr xss)))))

  (define-stream (lines strm)
    (stream-fold-right
     (breakon #\newline)
     (stream (stream))
     strm))

  (define (aoc-lines year day)
    (let* ([fh (open-input-file (sprintf "~a/resources/day~a.txt" year day))]
           [line (read-line fh)]
           [lines '()])
      (let loop ([fh fh] [line line] [lines lines])
        (cond [(eof-object? line) (reverse lines)]
              [else (loop fh (read-line fh) (cons line lines))]))))

  )

;; -*- mode: Scheme; tab-width: 2; -*- ;;

(import (test))
(import srfi-41)

(test-begin "2015 day01 tests")
(test "(()) is 0"      0 (floor-level (list->stream (string->list "(())"))))
(test "()() is 0"      0 (floor-level (list->stream (string->list "()()"))))
(test "((( is 3"       3 (floor-level (list->stream (string->list "((("))))
(test "(()(()( is 3"   3 (floor-level (list->stream (string->list "(()(()("))))
(test "))((((( is 3"   3 (floor-level (list->stream (string->list "))((((("))))
(test "()) is -1"     -1 (floor-level (list->stream (string->list "())"))))
(test "))( is -1"     -1 (floor-level (list->stream (string->list "))("))))
(test "))) is -3"     -3 (floor-level (list->stream (string->list ")))"))))
(test ")())()) is -3" -3 (floor-level (list->stream (string->list ")())())"))))
(test-end)

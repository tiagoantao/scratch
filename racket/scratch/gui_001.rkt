#lang racket
(require racket/gui/base)

(define frame (new frame% [label "Example"]))
(send frame show #t)

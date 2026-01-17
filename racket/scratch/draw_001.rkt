#lang racket

(require racket/draw)

(define target (make-bitmap 300 300))
(define dc (new bitmap-dc% [bitmap target]))
(send dc set-pen "yellow" 1 'solid)
(send dc draw-rectangle
      0 100
      300 100)
(send dc draw-line
      0 0
      300 300)
(send dc draw-line
      0 300
      300 0)
(send target save-file "box.png" 'png)

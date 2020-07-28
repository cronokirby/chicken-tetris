(import (prefix sdl2 "sdl2:"))
(import (chicken time))

;; General gameplay constants

;; How wide each cell is in pixels
(define CELL-WIDTH 30)
;; How high each cell is in pixels
(define CELL-HEIGHT 30)
;; How many cells the grid is wide
(define GRID-WIDTH 10)
;; How many cells the grid is tall
(define GRID-HEIGHT 20)
;; How wide the window is in pixels
(define WINDOW-WIDTH (* CELL-WIDTH GRID-WIDTH))
;; How tall the window is in pixels
(define WINDOW-HEIGHT (* CELL-HEIGHT GRID-HEIGHT))
;; How many milliseconds are in a frame
(define MS-PER-FRAME (floor (/ 1000 60)))

;; Representing a grid

;; Represents an element of the grid
;; Right now we just store the color of that element, with no other information
(define-record cell color)

(define-record grid w h elements)

;; Create an empty grid
(define (grid-new w h)
  (let* ((size (* w h))
         (elements (make-vector size #f)))
    (make-grid w h elements)))

(define (_grid-i grid x y)
  (+ x (* y (grid-w grid))))

;; Access an element of the grid at a certain position
(define (grid-at grid x y)
    (vector-ref (grid-elements grid) (_grid-i grid x y)))

(define (_grid-set! grid x y obj)
  (vector-set! (grid-elements grid) (_grid-i grid x y) obj))

;; Fill a specific cell of the grid with a certain color
(define (grid-set! grid x y color)
  (_grid-set! grid x y (make-cell color)))

;; Clear a specific cell of the grid
(define (grid-unset! grid x y)
  (_grid-set! grid x y #f))

;; Draw a single cell on a surface
(define (draw-cell! surface x y el)
  (let* ((draw-x (* x CELL-WIDTH))
         (draw-y (* y CELL-HEIGHT))
         (rect (sdl2:make-rect draw-x draw-y CELL-WIDTH CELL-HEIGHT))
         (color (cell-color el)))
    (sdl2:fill-rect! surface rect color)))

;; Draw a complete grid onto a surface
(define (draw-grid! surface grid)
  ;; The nested loops are a bit ugly, but likely efficient
  (do ((y 0 (+ y 1)))
      ((>= y (grid-h grid)))
    (do ((x 0 (+ x 1)))
        ((>= x (grid-w grid)))
      (let ((el? (grid-at grid x y)))
        (when el? (draw-cell! surface x y el?))))))

;; Colors

;; Aliasing this is useful
(define rgb sdl2:make-color)

;; This section defines the logic to render the game view

(define (fill-color! surface color)
  (sdl2:fill-rect! surface #f color))

;; Render the current state of the game to a window
;; Right now there's no state, so we just draw a blue screen on the window
(define (render! state window)
  (let ((surface (sdl2:window-surface window)))
    (fill-color! surface (rgb 0 0 0))
    (draw-grid! surface state)
    (sdl2:update-window-surface! window)))

;; Right now there's nothing interesting to do with the updates
(define (update state) state)

;; Wait the right amount of time based on the time at the start of the loop iteration
(define (wait-time then now)
  (let ((delta (- (+ then MS-PER-FRAME) now)))
    (if (< delta 0) 0 (floor delta))))

;; Start running the game in a loop until the user quits
(define (main)
  ;; Initialize all of the SDL2 stuff
  ;; We need to initialize the video subsystem, since we want a window
  ;; to draw pretty pictures onto.
  (sdl2:set-main-ready!)
  (sdl2:init! '(video))
  (define window (sdl2:create-window! "Hello, World!" 0 0 WINDOW-WIDTH WINDOW-HEIGHT))

  (define state (grid-new GRID-WIDTH GRID-HEIGHT))
  (grid-set! state 0 0 (rgb 125 0 0))
  (grid-set! state 1 1 (rgb 0 255 0))
  (grid-set! state 0 2 (rgb 255 0 0))
  (define then (current-milliseconds))

  ;; Our game loop, which keeps spinning until the user quits, about which SDL2
  ;; will inform us.
  (let loop ()
    (unless (sdl2:quit-requested?)
      (set! state (update state))
      (render! state window)
      (let ((now (current-milliseconds)))
        (sdl2:delay! (wait-time then now))
        (set! then now))
      (loop))))

(main)

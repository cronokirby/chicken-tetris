(import (prefix sdl2 "sdl2:"))
(import (chicken time))

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
    (sdl2:fill-rect! surface (sdl2:make-rect 100 state 100 200) (rgb 255 0 255))
    (sdl2:update-window-surface! window)))

(define (update state)
  (remainder (+ state 1) 255))

(define MS-PER-FRAME 16.6)

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
  (define window (sdl2:create-window! "Hello, World!" 0 0 600 400))

  (define state 0)
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

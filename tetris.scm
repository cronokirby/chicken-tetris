(import (prefix sdl2 "sdl2:"))

;; Colors
(define color-blue (sdl2:make-color 0 0 255))


;; This section defines the logic to render the game view

;; Render the current state of the game to a window
;; Right now there's no state, so we just draw a blue screen on the window
(define (render! window)
  (sdl2:fill-rect!
    (sdl2:window-surface window)
    #f
    color-blue)
  (sdl2:update-window-surface! window))


;; Start running the game in a loop until the user quits
(define (main)
  ;; Initialize all of the SDL2 stuff
  ;; We need to initialize the video subsystem, since we want a window
  ;; to draw pretty pictures onto.
  (sdl2:set-main-ready!)
  (sdl2:init! '(video))
  (define window (sdl2:create-window! "Hello, World!" 0 0 600 400))

  ;; Our game loop, which keeps spinning until the user quits, about which SDL2
  ;; will inform us.
  (let loop ()
    (unless (sdl2:quit-requested?)
      (render! window)
      (loop))))

(main)

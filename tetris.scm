(import (prefix sdl2 "sdl2:"))

(sdl2:set-main-ready!)
(sdl2:init! '(video))
(define window (sdl2:create-window! "Hello, World!" 0 0 600 400))
(sdl2:fill-rect!
  (sdl2:window-surface window)
  #f
  (sdl2:make-color 0 128 255))
(sdl2:update-window-surface! window)
(define loop (lambda ()
  (print "Hello?")
  (sdl2:delay! 300)
  (unless 
    (sdl2:quit-requested?)
    (loop))
))
(loop)

(in-package :sdl2)

(defun get-window-surface (window)
  (sdl2-ffi.functions:sdl-get-window-surface window))

(defun blit-surface (src srcrect dst dstrect)
  (sdl2-ffi.functions:sdl-upper-blit src srcrect
                                     dst dstrect))

(defun blit-surface-scaled (src srcrect dst dstrect)
  (sdl2-ffi.functions:sdl-upper-blit-scaled src srcrect
                                            dst dstrect))

(defun fill-rect (surface x y w h r g b a)
  (sdl2-ffi.functions:sdl-fill-rect
   surface
   (sdl2:make-rect x y w h)
   (sdl2-ffi.functions:sdl-map-rgba
    (sdl2-ffi.accessors:sdl-surface.format surface)
    r g b a)))

(defun surface-rect (surface)
  (sdl2:make-rect
   0 0
   (sdl2-ffi.accessors:sdl-surface.w surface)
   (sdl2-ffi.accessors:sdl-surface.h surface)))

(defun draw-sprite (surface sprite x y)
  (let ((w (sdl2-ffi.accessors:sdl-surface.w sprite))
        (h (sdl2-ffi.accessors:sdl-surface.h sprite)))
    (sdl2:blit-surface sprite
                       (sdl2:surface-rect sprite)
                       surface
                       (sdl2:make-rect x y w h))))

(export 'fill-rect)
(export 'get-window-surface)
(export 'blit-surface)
(export 'blit-surface-scaled)
(export 'surface-rect)
(export 'draw-sprite)

(in-package :aark)

(defmacro with-state-storage ((storage-hash &rest entries) &body body)
  (let* ((storage-hash-var (gensym))
         (entries-list (loop for e in entries
                          collect `(,e (gethash ',e ,storage-hash-var)))))
    `(let* ((,storage-hash-var (gethash ',storage-hash *storage*))
            ,@entries-list)
       ,@body)))

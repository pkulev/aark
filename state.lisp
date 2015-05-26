(in-package :aark)

(defclass state ()
  ((name     :initform (error "Name must be set")
             :initarg :name)
   (renderer :initform (error "Renderer must be set")
             :initarg :renderer)))

(defgeneric init (state))
(defgeneric process-input (state direction keysym))
(defgeneric update (state))
(defgeneric draw (state))
(defgeneric cleanup (state))

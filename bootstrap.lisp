;;;; Creates executable for linux and windows.
;;; usage: sbcl --load bootstrap.lisp
;;; emacs: M-! sbcl --load bootstrap.lisp

(in-package :cl-user)

(ql:quickload :aark)


(defun rootify (path)
  "Make PATH absolute."
  (merge-pathnames path (asdf:system-source-directory :aark)))

(cond
  ((uiop/os:os-windows-p)
   (setf build-dir (rootify #P"build/windows/")
         vendored-dir (rootify #P"vendored/windows/")
         executable-name "aark.exe"))
  (:else
   (setf build-dir (rootify #P"build/linux/")
         vendored-dir nil
         executable-name "aark")))

(setf executable-path (merge-pathnames build-dir executable-name))

;; TODO: implement safe checker for validating path
(uiop/filesystem:delete-directory-tree build-dir
                                       :validate t
                                       :if-does-not-exist :ignore)

(ensure-directories-exist build-dir)

(defun copy-dir (from to)
  (when (wild-pathname-p from)
    (error "Wildcarding is not supported."))
  (loop with path = (truename from)
       for l in (delete-if (lambda (x) (eql :absolute (first (pathname-directory (make-pathname :defaults x))))))))

(if vendored-dir)
;; Copy vendored/windows/* build-dir
;; (if #+windows t (blablabla) (blablablavlabalbalbalbalb))
;; Copy data build-dir

;; TODO: select :gui type by argument --release
(save-lisp-and-die executable-path
                   :executable t
                   :compression t
                   :toplevel #'(lambda () (aark:main :core-is-root t))
                   :application-type :console)



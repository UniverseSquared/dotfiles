;; FIXME: split this into multiple modules probably and move other stuff to (nx cmd ...)
(define-module (nx common)
  #:use-module (ice-9 ftw)
  #:export (remove-prefix remove-suffix system-profiles))

(define (remove-prefix prefix s)
  (if (string-prefix? prefix s)
      (substring s (string-length prefix))
      s))

(define (remove-suffix suffix s)
  (if (string-suffix? suffix s)
      (substring s 0 (- (string-length s) (string-length suffix)))
      s))

(define (system-profiles)
  (let ((system-link? (lambda (name) (and (string-prefix? "system-" name)
                                          (string-suffix? "-link" name))))
        (path->generation
         (lambda (path)
           (string->number (remove-suffix "-link" (remove-prefix "system-" path))))))
    (map path->generation (scandir "/nix/var/nix/profiles" system-link?))))

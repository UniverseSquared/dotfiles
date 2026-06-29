;; FIXME: split this into multiple modules probably and move other stuff to (nx cmd ...)
(define-module (nx common)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 textual-ports))

(define-public (read-text-file path)
  (let* ((file (open-file path "r"))
         (content (get-string-all file)))
    (close-port file)
    content))

(define-public (remove-prefix prefix s)
  (if (string-prefix? prefix s)
      (substring s (string-length prefix))
      s))

(define-public (remove-suffix suffix s)
  (if (string-suffix? suffix s)
      (substring s 0 (- (string-length s) (string-length suffix)))
      s))

(define-public (remove-whitespace s)
  (string-filter (negate char-whitespace?) s))

(define-module (nx boot)
  #:use-module (ice-9 getopt-long)
  #:use-module ((nx nix) #:prefix nix/)
  #:export (cmd))

(define option-spec '((help (single-char #\h) (value #f))))

(define help-message "\
usage: nx boot

rebuild the system and make it the boot default

  -h, --help  display this help message
")

(define (cmd args)
  (let ((options (getopt-long args option-spec)))
    (if (option-ref options 'help #f)
        (display help-message)
        (nix/rebuild-system #:verb 'boot))))

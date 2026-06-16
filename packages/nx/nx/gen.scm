(define-module (nx gen)
  #:use-module (ice-9 getopt-long)
  #:use-module (ice-9 textual-ports)
  #:use-module (nx common)
  #:export (cmd))

(define option-spec '((help (single-char #\h) (value #f))))

(define switch-option-spec
  '((help           (single-char #\h) (value #f))
    (specialisation (single-char #\s) (value #t))))

(define help-message "\
usage: nx gen                                         list the system generations
       nx gen switch [--specialisation <name>] <gen>  switch to the specified generation

  -h, --help                   display this help message
  -s, --specialisation <name>  name of the specialisation to activate
")

(define (read-text-file path)
  (let* ((file (open-file path "r"))
         (content (get-string-all file)))
    (close-port file)
    content))

(define (generation-info gen)
  (let* ((generation-path (readlink (format #f "/nix/var/nix/profiles/system-~a-link" gen)))
         (stats (stat generation-path)))
    `((number . ,gen)
      (build-date . ,(stat:ctime stats))
      (nixos-version . ,(read-text-file (format #f "~a/nixos-version" generation-path))))))

(define (switch-to-generation gen specialisation)
  (let ((switch-to-configuration
         (format #f "/nix/var/nix/profiles/system-~a-link~a/bin/switch-to-configuration" gen
                 (if specialisation
                     (string-append "/specialisation/" specialisation)
                     ""))))
    (system* "sudo" switch-to-configuration "switch")
    (system* "sudo" "nix-env" "--profile" "/nix/var/nix/profiles/system" "--switch-generation"
             (number->string gen))))

(define (subcmd-switch args)
  (let* ((options (getopt-long args switch-option-spec))
         (generation (string->number (car (option-ref options '() #f)))))
    (if (option-ref options 'help #f)
        (display help-message)
        (switch-to-generation generation (option-ref options 'specialisation #f)))))

(define (current-generation)
  (string->number
   (remove-suffix "-link" (remove-prefix "system-" (readlink "/nix/var/nix/profiles/system")))))

(define (current-generation? gen)
  (= (current-generation) gen))

(define (list-generations)
  (for-each (lambda (generation)
              (format #t "~a~a\x1b[m  ~a  ~a\n"
                      (if (current-generation? (assoc-ref generation 'number))
                          "\x1b[32m"
                          "")
                      (assoc-ref generation 'number)
                      (strftime "%Y-%m-%d %H:%M:%S"
                                (localtime (assoc-ref generation 'build-date)))
                      (assoc-ref generation 'nixos-version)))
            (sort (map generation-info (system-profiles))
                  (lambda (x y)
                    (> (assoc-ref x 'number)
                       (assoc-ref y 'number))))))

(define (subcmd-list args)
  (let ((options (getopt-long args option-spec)))
    (if (option-ref options 'help #f)
        (display help-message)
        (list-generations))))

(define (cmd args)
  (if (null? (cdr args))
      (subcmd-list args)
      (cond ((string=? (cadr args) "switch") (subcmd-switch (cdr args)))
            (else (subcmd-list args)))))

(define-module (nx nix)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 optargs)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (nx common))

(define-public flake-path (make-parameter "/home/dawson/dotfiles"))

(define (exec cmd . args)
  "Spawn and wait for the termination of a process, returning `#f' on a failed exit, or its standard output as
a string otherwise."
  (let* ((input-output (pipe))
         (pid (spawn cmd (cons cmd args) #:output (cdr input-output)))
         (exit-status (cdr (waitpid pid))))
    (close-port (cdr input-output))
    (if (zero? (status:exit-val exit-status))
        (get-string-all (car input-output))
        #f)))

(define-public (system-generations)
  (let ((system-link? (lambda (name) (and (string-prefix? "system-" name)
                                          (string-suffix? "-link" name))))
        (path->generation
         (lambda (path)
           (string->number (remove-suffix "-link" (remove-prefix "system-" path))))))
    (map path->generation (scandir "/nix/var/nix/profiles" system-link?))))

(define-public (generation-info gen)
  (let* ((generation-path (readlink (format #f "/nix/var/nix/profiles/system-~a-link" gen)))
         (stats (stat generation-path)))
    `((number . ,gen)
      (build-date . ,(stat:ctime stats))
      (nixos-version . ,(read-text-file (format #f "~a/nixos-version" generation-path))))))

(define*-public (switch-to-generation generation #:key verb specialisation)
  "Switch to GENERATION, given either as the store path of a built system toplevel or a generation number of
the system profile, according to VERB, which is `switch', `boot', or `test'."
  (let* ((generation-path (if (string? generation)
                              generation
                              (format #f "/nix/var/nix/profiles/system-~a-link" generation)))
         (switch-to-configuration
          (format #f "~a~a/bin/switch-to-configuration"
                  generation-path
                  (if specialisation
                      (format #f "/specialisation/~a" specialisation)
                      ""))))
    ;; FIXME: i don't think we have to call `nix-env --switch-generation ...` here but i'm not 100% sure
    (system* "sudo" switch-to-configuration (symbol->string (or verb 'switch)))))

(define-public (build installable)
  "Build a derivation and produce the resulting store path."
  (let ((store-path (exec "nom" "build" "--no-link" "--print-out-paths" installable)))
    (if store-path
        (remove-whitespace store-path)
        #f)))

(define*-public (rebuild-system #:key verb specialisation)
  "Build the system configuration and switch to it according to VERB."
  (let ((generation-store-path (build (string-append (flake-path)
                                                     "#nixosConfigurations."
                                                     (gethostname)
                                                     ".config.system.build.toplevel"))))
    (if generation-store-path
        ;; set the built toplevel as the newest system generation
        (begin
          (system* "sudo" "nix-env" "--profile" "/nix/var/nix/profiles/system" "--set" generation-store-path)
          (switch-to-generation generation-store-path #:verb verb #:specialisation specialisation))
        #f)))

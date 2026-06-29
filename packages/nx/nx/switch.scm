(define-module (nx switch)
  #:use-module (ice-9 getopt-long)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (nx common)
  #:use-module ((nx nix) #:prefix nix/)
  #:export (cmd))

(define option-spec
  '((help           (single-char #\h) (value #f))
    (deck                             (value #t))
    (specialisation (single-char #\s) (value #t))))

(define help-message "\
usage: nx switch [--deck <ip address>]

rebuild and activate a system

  -h, --help                   display this help message
      --deck <ip address>      deploy waso to the system at the specified address
  -s, --specialisation <name>  name of the specialisation to activate
")

;; TODO: test this
(define (deploy-to-deck deck-address)
  (let* ((generation-store-path
          (nix/build (string-append (nix/flake-path) "#homeConfigurations.deck@waso.activationPackage"))))
    ;; `remote-program=...` is a workaround for https://github.com/NixOS/nix/issues/1078
    (system* "nix" "copy" "--verbose" "--to"
             "ssh://deck@#{deck_ip}?remote-program=/home/deck/.nix-profile/bin/nix-store"
             generation-store-path)

    ;; `source .bash_profile` is a workaround for the same issue as above
    (system* "ssh" (string-append "deck@" deck-address) "--"
             (string-append "source .bash_profile; " generation-store-path "/activate"))))

(define (diff-latest-system-profiles)
  (let* ((profiles (system-profiles))
         (previous-generation (list-ref profiles (- (length profiles) 2)))
         (previous-generation-path (format #f "/nix/var/nix/profiles/system-~a-link" previous-generation)))
    ;; TODO: implement our own diffing
    (system* "nvd" "diff" previous-generation-path "/run/current-system")))

(define (switch options)
  (nix/rebuild-system #:specialisation (option-ref options 'specialisation #f)))

(define (cmd args)
  (let* ((options (getopt-long args option-spec))
         (deck-address (option-ref options 'deck #f)))
    (cond ((option-ref options 'help #f) (display help-message))
          (deck-address (deploy-to-deck deck-address))
          (else (switch options)))))

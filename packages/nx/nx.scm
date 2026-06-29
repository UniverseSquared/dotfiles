#!/usr/bin/env guile
!#

(define-module (nx)
  #:use-module ((nx boot) #:prefix boot/)
  #:use-module ((nx gen) #:prefix gen/)
  #:use-module ((nx new) #:prefix new/)
  #:use-module ((nx shell) #:prefix shell/)
  #:use-module ((nx switch) #:prefix switch/))

(define help-message "\
usage: nx <subcommand>

  boot    rebuild the system and make it the boot default
  gen     list the system generations
  new     create a new project from a template
  shell   spawn a shell with a set of packages available
  switch  build and activate a system
")

(define (dispatch-cmd subcommand args)
  (cond ((equal? subcommand "boot") (boot/cmd args))
        ((equal? subcommand "gen") (gen/cmd args))
        ((equal? subcommand "new") (new/cmd args))
        ((equal? subcommand "shell") (shell/cmd args))
        ((equal? subcommand "switch") (switch/cmd args))
        (else (display help-message))))

(let ((subcommand-and-args (cdr (command-line))))
  (if (null? subcommand-and-args)
      (display help-message)
      (dispatch-cmd (car subcommand-and-args) subcommand-and-args)))

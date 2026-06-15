(define-module (nx shell)
  #:use-module (ice-9 getopt-long)
  #:export (cmd))

(define option-spec
  '((help (single-char #\h) (value #f))
    (fhs                    (value #f))))

(define help-message "\
usage: nx shell [--fhs] package...

spawn a shell with a set of packages available

  -h, --help  display this help message
      --fhs   create an fhs env instead of a regular shell
")

(define (parenthise s)
  (string-append "(" s ")"))

(define fhs-shell-expr-template "\
  let pkgs = import <nixpkgs> {}; in
  (pkgs.buildFHSEnv {
    name = \"fhs-shell\";
    runScript = \"zsh\";
    targetPkgs = pkgs: with pkgs; [ ~a ];
  }).env")

(define (spawn-shell-in-fhs-env packages)
  (system* "nix" "develop" "--impure" "--expr"
           (format #f fhs-shell-expr-template (map parenthise packages))))

(define shell-expr-template
  "let pkgs = import <nixpkgs> {}; in with pkgs; [ ~a ]")

(define (spawn-shell packages)
  (system* "nix" "shell" "--impure" "--expr"
           (format #f shell-expr-template (map parenthise packages))))

(define (cmd args)
  (let* ((options (getopt-long args option-spec))
         (packages (option-ref options '() #f)))
    (cond ((option-ref options 'help #f) (display help-message))
          ((option-ref options 'fhs #f) (spawn-shell-in-fhs-env packages))
          (else (spawn-shell packages)))))

(define-module (nx new)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 getopt-long)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 textual-ports)
  #:use-module (json)
  #:use-module (nx common)
  #:export (cmd))

(define option-spec '((help (single-char #\h) (value #f))))

(define help-message "\
usage: nx new <template> <project name>

create a new project from a template

  -h, --help  display this help message
")

;; FIXME: dedup with switch.scm
(define (remove-whitespace s)
  (string-filter (negate char-whitespace?) s))

;; FIXME: i think this can be made nicer with json->scm, which accepts a port (but nix-eval-pipe is a pipe)
(define (project-templates)
  (let* ((nix-eval-pipe (open-pipe* OPEN_READ "nix" "eval" "--json" "dotfiles#templates"))
         (templates (json-string->scm (remove-whitespace (get-string-all nix-eval-pipe)))))
    ;; (display templates)
    ;; (newline)
    ;; (display (assoc-ref (assoc-ref templates "rust") "path"))
    ;; (newline)
    (close-port nix-eval-pipe)
    templates))

(define (substitute-templates contents project-name)
  (regexp-substitute/global #f "%%[a-z-]+%%" contents
                            'pre
                            (lambda (match)
                              (if (string=? (match:substring match) "%%project-name%%")
                                  project-name
                                  (match:substring match)))
                            'post))

(define (directory? path)
  (let ((st (stat path #f)))
    (if st
        (eq? (stat:type st) 'directory)
        ;; the path doesn't exist, so it is not a directory
        #f)))

(define (make-directory-and-parents path)
  (let ((parent (dirname path)))
    (unless (directory? parent)
      (make-directory-and-parents parent))
    (mkdir path)))

(define (create-project-from-template template-name project-name)
  (let* ((templates (project-templates))
         (template-path (assoc-ref (assoc-ref templates template-name) "path"))
         (project-path (string-append (getcwd) "/" project-name)))
    (ftw template-path (lambda (filename statinfo flag)
                         (let ((destination-path (substitute-templates
                                                  (string-append project-path
                                                                 "/"
                                                                 (remove-prefix template-path filename))
                                                  project-name)))
                         (if (directory? filename)
                             (mkdir destination-path)
                             (let ((substituted-content (substitute-templates
                                                         (with-input-from-file filename
                                                           (lambda ()
                                                             (get-string-all (current-input-port))))
                                                         project-name)))
                               (with-output-to-file destination-path
                                 (lambda ()
                                   (put-string (current-output-port) substituted-content))))))
                         #t))))

(define (cmd args)
  (let* ((options (getopt-long args option-spec))
         (positional-arguments (option-ref options '() #f)))
    (if (or (option-ref options 'help #f)
            (< (length positional-arguments) 2))
        (display help-message)
        (create-project-from-template (list-ref positional-arguments 0)
                                      (list-ref positional-arguments 1)))))

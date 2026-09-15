#lang racket

(struct rule (target deps cmd) #:transparent) ; λ build rule structure

;; λ rule parser
(define (parse-rule expr)
  (match expr
    [`(target ,name #:deps ,deps #:cmd ,cmd)
     (rule name deps cmd)]
    [`(target ,name #:cmd ,cmd)
     (rule name '() cmd)]
    [_ (error "[SAKE] Syntax error in rule:" expr)]))

;; λ load and open sakefile for parse
(define (load-sakefile filepath)
  (define port (open-input-file filepath))
  (define (loop accum)
    (define expr (read port))
    (if (eof-object? expr)
        (begin
          (close-input-port port)
          (reverse accum))
        (loop (cons (parse-rule expr) accum))))
  (loop '()))

;; λ check files for modified
(define (needs-rebuild? target-file deps)
  (cond
    [(not (file-exists? target-file)) #t]
    [else
     (define target-mtime (file-or-directory-modify-seconds target-file))
     (ormap (λ (dep)
              (and (file-exists? dep)
                   (> (file-or-directory-modify-seconds dep) target-mtime)))
            deps)]))

(define (build-rule r)
  (define target (rule-target r))
  (define deps   (rule-deps r))
  (define cmd    (rule-cmd r))

;; λ rebuild one or more files if modified and first build 
  (if (needs-rebuild? target deps)
      (let ([_ (printf "[SAKE] Building target: ~a...\n" target)]
            [success? (system cmd)])
        (unless success?
          (error "[SAKE] Command failed:" cmd)))
      (printf "[SAKE] Target '~a' is up to date.\n" target)))

;; λ entry point
(define (main)
  (define args (vector->list (current-command-line-arguments)))
  (define rules (load-sakefile "sakefile.scm"))
  
  (when (null? rules)
    (error "[SAKE] sakefile.scm empty or has no rules"))
  
  (define target-name
    (if (null? args)
       (rule-target (car rules))
       (car args)))
  
  (define target-rule 
    (findf (λ (r) (equal? (rule-target r) target-name)) rules))

  (if target-rule
      (build-rule target-rule)
      (error "[SAKE] Unknown target:" target-name)))

(main)
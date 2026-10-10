(sakevar cc "gcc")
(sakevar cflags "-O2 -Wall -I. -I.. -I../lib -DHAVE_CONFIG_H -DLOCALEDIR=\\\"/usr/local/share/locale\\\" -DSYSCONFDIR=\\\"/etc\\\"")
(sakevar ldflags "-lncursesw -lmagic")

(define nano-sources
  '("browser" "chars" "color" "cut" "files" "global"
    "help" "history" "move" "nano" "prompt" "rcfile"
    "search" "text" "utils" "winio"))

(define nano-objects
  (map (lambda (name) (format #f "~a.o" name)) nano-sources))

(target "all"
        #:deps '("nano")
        #:cmd "")

(target "revision.h"
        #:deps '()
        #:cmd "echo '#define REVISION \"git-build\"' | cmp -s - revision.h || echo '#define REVISION \"git-build\"' > revision.h")

(target "../lib/libgnu.a"
        #:deps '()
        #:cmd "make -C ../lib")

(for-each
  (lambda (name)
    (let ((c-file (format #f "~a.c" name))
          (o-file (format #f "~a.o" name)))
      (target o-file
              #:deps (list c-file "revision.h" "../config.h" "../lib/libgnu.a")
              #:cmd (format #f "~a ~a -c ~a -o ~a" cc cflags c-file o-file))))
  nano-sources)

(target "nano"
        #:deps (cons "../lib/libgnu.a" nano-objects)
        #:cmd (format #f "~a -o nano ~a ../lib/libgnu.a ~a"
                      cc
                      (string-join nano-objects " ")
                      ldflags))

(target "install-symlink"
        #:deps '("nano")
        #:cmd "ln -sf nano rnano")

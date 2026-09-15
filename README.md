#**S**cheme m**ake**
minimalistic build system writen in Racket
using S-expressions as build rules and parsing via (read)

##sakefile.scm example
```scheme
(target "sake" #:deps ("sake.rkt") #:cmd "raco exe -o sake sake.rkt")
```

##Dependies
 - Racket
 - (Optionaly) DrRacket

##Ways to build > sake
 1. Using DrRacket built-in interpreter 
 2. By command `raco exe -o sake sake.rkt`

Also you can build with command, `touch sake.rkt` and rebuild using `./sake`

(target "sake" #:deps ("sake.rkt") #:cmd "raco exe -o sake sake.rkt")
(target "install" #:deps ("sake") #:cmd "sudo cp sake /bin/")

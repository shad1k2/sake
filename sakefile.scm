(target "all" #:deps ("install") #:cmd "echo 'sake built and installed'")
(target "sake" #:deps ("sake.rkt") #:cmd "raco exe -o sake sake.rkt")
(target "install" #:deps ("sake") #:cmd "sudo cp sake /bin/")

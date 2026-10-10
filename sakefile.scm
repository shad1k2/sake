(target "all" #:deps '("install") #:cmd "echo 'Sake built and installed'")
(target "install" #:deps '("sake.scm") #:cmd "sudo cp sake.scm /usr/bin/sake && sudo chmod +x /usr/bin/sake")

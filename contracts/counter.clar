(define-constant participants
  (list 
    "Vladimir Novachki aka Vlad, Stornest"
    "Simon Semaan aka planet9, ardkon.com"
    "Roland Naddour aka TMDR11"
    "Ibrahim Shedid strong, bypa-ss.com"
    "Mario Nassef, tandasmart.com"
  ))




(map say-name participants)





(define-private (say-name (name (string-ascii 256))) 
  (print name))

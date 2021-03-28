;; Simple voting contract
;; a variable that holds the votes
(define-data-var vote-count uint u0)
;; a function that takes a voter's name
;; increments that vote count
;; and prints that voter's name

(define-constant ERROR-UNAUTHORIZED 401)
(define-map votes-for-legislations {legislation: uint} {votes: uint})
(define-map vote-registry {voter: principal, legislation: uint} {did-vote: bool})

(define-public (vote (name (string-ascii 256)) (legislation-id uint)) 
  (let (
    (current-votes (var-get vote-count))
    (new-vote-count (+ current-votes u1))
    (voter-registration (map-get? vote-registry {voter: tx-sender, legislation: legislation-id}))
    (did-vote (is-some voter-registration))
    (number-of-votes (default-to u0
      (get votes 
        (map-get? votes-for-legislations {legislation: legislation-id}))))
  )
    (if did-vote 
      (err ERROR-UNAUTHORIZED)
      (begin
        (var-set vote-count new-vote-count)
        (map-insert vote-registry 
          {voter: tx-sender, legislation: legislation-id} 
          {did-vote: true})
        (map-set votes-for-legislations
          {legislation: legislation-id} 
          {votes: (+ u1 number-of-votes)})
        (ok (print name))
      ))))

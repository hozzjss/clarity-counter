;; Simple voting contract
;; a variable that holds the votes
(define-data-var vote-count uint u0)
;; a function that takes a voter's name
;; increments that vote count
;; and prints that voter's name
(define-constant SimonsAddress 'SP3GWX3NE58KXHESRYE4DYQ1S31PQJTCRXB3PE9SB)

(define-constant ERROR-UNAUTHORIZED u401)
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
        (print name)
        ;; 0.00001
        ;;
        (stx-transfer? u100 tx-sender SimonsAddress)
      ))))


(define-map validation-service-providers
  {id: principal}
  {active: bool, name: (string-ascii 256)}
)

(map-insert validation-service-providers 
  {id: 'SP3GWX3NE58KXHESRYE4DYQ1S31PQJTCRXB3PE9SB} {active: true, name: "CIB"})

;; consider the validation map

(define-map validations {id: uint} {hash: (buff 256)})

(define-private (is-a-validator) 
  (is-some (map-get? validation-service-providers {id: tx-sender})))

(define-public (add-hash (id uint) (hash (buff 256)))
  (begin 
    (asserts! (is-a-validator) 
      (err ERROR-UNAUTHORIZED))
    (map-insert validations {id: id} {hash: hash})
    (ok true)
  ))
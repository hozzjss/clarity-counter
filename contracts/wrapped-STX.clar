;; (impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-10-ft-standard.ft-trait)

(define-constant contract (as-contract tx-sender))
(define-fungible-token wrapped-stx)

(define-public (wrap (amount uint)) 
  (let (
    (balance (stx-get-balance tx-sender))
    ) 
    (asserts! (>= balance amount) (err u400))
    (asserts! 
      (is-ok (stx-transfer? amount tx-sender contract))
    (err u500))
    (asserts! 
      (is-ok (ft-mint? wrapped-stx amount tx-sender))
    (err u500))
    (ok true)
  ))

(define-public (unwrap (amount uint))
  (let (
    (balance (ft-get-balance wrapped-stx tx-sender))
    (redeemer tx-sender)
    ) 
    (asserts! (>= balance amount) (err u400))
    (asserts! 
      (is-ok (as-contract (stx-transfer? amount tx-sender redeemer)))
    (err u500))
    (asserts! 
      (is-ok (ft-burn? wrapped-stx amount tx-sender))
    (err u500))
    (ok true)
  ))


;; the human readable name of the token
(define-read-only (get-name) 
  (ok "Wrapped-STX"))
;; the ticker symbol, or empty if none PASS
(define-read-only (get-symbol) 
  (ok "WSTX"))

;; 10000000 the number of decimals used, e.g. 6 would mean 1_000_000 represents 1 token
(define-read-only (get-decimals) (ok u6))

;; the balance of the passed principal
(define-read-only (get-balance-of (sender principal)) 
  (ok (ft-get-balance wrapped-stx sender)))

;; the current total supply (which does not need to be a constant)

(define-read-only (get-total-supply) 
  (ok (ft-get-supply wrapped-stx)))

;; an optional URI that represents metadata of this token
(define-read-only (get-token-uri) (ok none))

(define-public (transfer (amount uint) (sender principal) (recipient principal)) 
  (begin 
    (asserts! (is-eq tx-sender sender) (err u401))
    (ft-transfer? wrapped-stx amount sender recipient)
  ))

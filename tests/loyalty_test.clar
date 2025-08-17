(use-trait loyalty-trait
  '((issue-points (principal uint) (response uint))
    (redeem-points (uint) (response uint))
    (get-balance (principal) (response uint))
    (get-total-supply () (response uint))))

(impl-trait .loyalty)

(define-constant alice 'SP2C2PYZ0X6FQ6Z8FQ6Z8FQ6Z8FQ6Z8FQ6Z8FQ6Z8)
(define-constant bob 'SP3C2PYZ0X6FQ6Z8FQ6Z8FQ6Z8FQ6Z8FQ6Z8FQ6Z8)

;; Test issuing points
(define-public (test-issue-points)
  (begin
    (asserts! (is-eq (contract-call? .loyalty issue-points alice u100) (ok u100)) "Issue points failed")
    (asserts! (is-eq (contract-call? .loyalty get-balance alice) (ok u100)) "Balance incorrect after issue")
    (asserts! (is-eq (contract-call? .loyalty get-total-supply) (ok u100)) "Total supply incorrect after issue")
  )
)

;; Test redeeming points
(define-public (test-redeem-points)
  (begin
    (contract-call? .loyalty issue-points bob u50)
    (asserts! (is-eq (contract-call? .loyalty redeem-points u30) (ok u30)) "Redeem points failed")
    (asserts! (is-eq (contract-call? .loyalty get-balance bob) (ok u20)) "Balance incorrect after redeem")
    (asserts! (is-eq (contract-call? .loyalty get-total-supply) (ok u70)) "Total supply incorrect after redeem")
  )
)

;; Test insufficient points
(define-public (test-insufficient-points)
  (begin
    (asserts! (is-eq (contract-call? .loyalty redeem-points u100) (err "Insufficient points")) "Should fail for insufficient points")
  )
)

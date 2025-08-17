
(define-data-var total-supply uint u0)
(define-map balances {user: principal} {balance: uint})

(define-constant TOKEN_NAME "Loyalty Points")
(define-constant TOKEN_SYMBOL "LOYAL")

;; Issue loyalty points to a user
(define-public (issue-points (recipient principal) (amount uint))
	(begin
		(let ((current (default-to u0 (get balance (map-get? balances {user: recipient})))))
			(map-set balances {user: recipient} {balance: (+ current amount)})
			(var-set total-supply (+ (var-get total-supply) amount))
			(ok amount)
		)
	)
)

;; Redeem loyalty points for services or benefits
(define-public (redeem-points (amount uint))
	(let ((sender tx-sender))
		(let ((current (default-to u0 (get balance (map-get? balances {user: sender})))))
			(if (>= current amount)
				(begin
					(map-set balances {user: sender} {balance: (- current amount)})
					(var-set total-supply (- (var-get total-supply) amount))
					(ok amount)
				)
				(err "Insufficient points")
			)
		)
	)
)

;; Get balance of a user
(define-public (get-balance (user principal))
	(ok (default-to u0 (get balance (map-get? balances {user: user}))))
)

;; Get total supply of loyalty points
(define-public (get-total-supply)
	(ok (var-get total-supply))
)

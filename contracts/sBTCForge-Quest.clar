;; sBTCForge-Quest Gaming Platform Smart Contract
;; Handles in-game asset ownership and trading functionality


;; Constants
(define-constant platform-admin tx-sender)
(define-constant err-admin-only (err u100))
(define-constant err-resource-not-found (err u101))
(define-constant err-permission-denied (err u102))
(define-constant err-invalid-parameters (err u103))
(define-constant err-pricing-error (err u104))
(define-constant max-character-level u100)
(define-constant max-character-experience u10000)
(define-constant max-item-metadata-length u256)
(define-constant max-batch-operation-size u10)


;;;;;;; Data Variables ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-data-var total-item-count uint u0)



;;;;; Read-only Functions;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Get item details
(define-read-only (get-item-details (item-id uint))
    (if (<= item-id (var-get total-item-count))
        (map-get? game-items { item-id: item-id })
        none))

;; Get marketplace listing details
(define-read-only (get-marketplace-listing (item-id uint))
    (map-get? marketplace-item-listings { item-id: item-id }))

;; Get character progression
(define-read-only (get-character-progression (character principal))
    (map-get? character-progression { character: character }))

;; Get total items created
(define-read-only (get-total-items)
    (var-get total-item-count))



;; Map definitions
(define-map game-items 
    { item-id: uint }
    { owner: principal, item-uri: (string-utf8 256), can-trade: bool })


(define-map item-market-values
    { item-id: uint }
    { price: uint })


(define-map character-progression
    { character: principal }
    { experience: uint, level: uint })


(define-map marketplace-item-listings
    { item-id: uint }
    { seller: principal, price: uint, listing-timestamp: uint })


;;;;;; Private Functions ;;;;;;

;; Validate game item exists and return item data
(define-private (validate-and-fetch-item (item-id uint))
    (let ((item (map-get? game-items { item-id: item-id })))
        (asserts! (and 
                (is-some item)
                (<= item-id (var-get total-item-count)))
            err-resource-not-found)
        (ok (unwrap-panic item))))


;; Validate item metadata URI length
(define-private (is-valid-item-uri (uri (string-utf8 256)))
    (let ((uri-length (len uri)))
        (and 
            (> uri-length u0)
            (<= uri-length max-item-metadata-length))))

;; Helper function for batch item creation
(define-private (create-single-item 
    (uri (string-utf8 256))
    (can-trade bool))
    (let 
        ((item-id (+ (var-get total-item-count) u1)))
        (asserts! (is-valid-item-uri uri) err-invalid-parameters)
        (map-set game-items
            { item-id: item-id }
            { owner: platform-admin,
              item-uri: uri,
              can-trade: can-trade })
        (var-set total-item-count item-id)
        (ok item-id)))

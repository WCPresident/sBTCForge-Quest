# sBTCForge-Quest Smart Contract

The **sBTCForge-Quest Smart Contract** powers a decentralized gaming platform on the Stacks blockchain, handling core gameplay asset management — including minting, ownership, trading, and progression systems.

---

##  Overview

**sBTCForge-Quest** is designed for blockchain-based role-playing games where characters can own, trade, and progress with digital assets. This contract enables:

* Creation and management of in-game items (weapons, armor, artifacts, etc.)
* Ownership transfers and marketplace listing
* Secure, STX-based purchasing
* Player progression (experience and level tracking)

---

##  Features

* 🔒 **Admin-controlled Item Minting**
* 🔁 **Batch & Single Item Transfers**
* 🏪 **On-chain Marketplace with STX payments**
* 📈 **Character Progression Tracking**
* 🧾 **Detailed Asset Querying**

---

## ⚙️ Smart Contract Structure

### Constants

* `platform-admin`: Set as the deployer (`tx-sender`) at contract deploy time
* Max values:

  * `max-character-level`: 100
  * `max-character-experience`: 10,000
  * `max-item-metadata-length`: 256 chars
  * `max-batch-operation-size`: 10 items
* Error codes: `err-admin-only`, `err-resource-not-found`, etc.

### Maps

* `game-items`: Stores item ownership, URI, and tradability
* `item-market-values`: \[Reserved for future use]
* `character-progression`: Tracks experience and level of characters
* `marketplace-item-listings`: Stores listings of items for sale
* `total-item-count`: Tracks total number of items minted

---

## 🚀 Functions

### 🔧 Admin Functions

#### `create-item(item-uri, can-trade)`

Create a single game item with metadata URI and tradable flag.

#### `batch-create-items(item-uris, tradable-flags)`

Create multiple items in one transaction.

---

### 🔁 Item Transfers

#### `transfer-item(item-id, recipient)`

Transfer ownership of a single tradable item.

#### `batch-transfer-items(item-ids, recipients)`

Transfer multiple items to corresponding recipients in a single call.

---

### 🏪 Marketplace

#### `list-item-for-sale(item-id, price)`

List an owned item for sale at a specific STX price.

#### `purchase-item(item-id)`

Purchase a listed item using STX tokens.

#### `delist-item(item-id)`

Remove an item from the marketplace listing (only the seller can delist).

---

### 📈 Character Progression

#### `update-character-progression(experience, level)`

Allows users to update their own character progression (up to max values).

---

### 👁 Read-Only Functions

#### `get-item-details(item-id)`

Returns metadata about an item if it exists.

#### `get-marketplace-listing(item-id)`

Returns the current marketplace listing of an item.

#### `get-character-progression(character)`

Returns experience and level of a given player.

#### `get-total-items()`

Returns total number of items minted so far.

---

## 📦 Example Usage

### Creating Items (Admin Only)

```lisp
(contract-call? .realm-quest create-item "ipfs://my-asset-uri" true)
```

### Transferring Items

```lisp
(contract-call? .realm-quest transfer-item u1 'ST2...RECIPIENT)
```

### Listing and Purchasing

```lisp
(contract-call? .realm-quest list-item-for-sale u1 u1000000)
(contract-call? .realm-quest purchase-item u1)
```

### Character Progression

```lisp
(contract-call? .realm-quest update-character-progression u5000 u10)
```

---

## ✅ Security Considerations

* Only the platform admin can mint items
* Users can only transfer items they own
* Tradeable flag ensures non-transferable assets are enforced
* Marketplace purchase uses native `stx-transfer?` to securely pay the seller

---

## 📚 Future Enhancements

* Royalty support for item resales
* Enhanced in-game item attributes (damage, rarity, etc.)
* NFT standards integration (SIP-009 or SIP-010)
* Item burning or recycling mechanics

---

## 🧪 Testing & Deployment

Use [Clarinet](https://docs.hiro.so/clarinet) for local development and testing.

```bash
clarinet test
clarinet console
```

Deploy to mainnet/testnet using Stacks CLI or a deployment tool like Clarinet or Boom.

---

## 📄 License

MIT License ©️ 2025 sBTCForge-Quest Developers

---

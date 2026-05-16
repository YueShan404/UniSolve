# 🧠 UniSolve

### *Zero-Knowledge Anonymous Q&A Marketplace on Monad Blockchain*

[![Monad](https://img.shields.io/badge/Built%20on-Monad-00FF88)](https://monad.xyz)
[![Hackathon](https://img.shields.io/badge/Monad%20Blitz-KL%202026-blue)](https://lu.ma/monad-blitz-kl)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

---

## 🎯 The Problem

**Every student has been stuck on a bug with no one to help.**

- You post in WhatsApp groups → **nobody replies**
- You ask on Discord → **ignored or trolled**
- You're too embarrassed to ask → **"it's a stupid question"**

**Result:** Hours wasted. Assignment late. Confidence crushed.

**Worse:** Even when someone helps, how do you pay them? Bank transfer? E-wallet? Too much friction for a small reward.

---

## 💡 The Solution: UniSolve

**Anonymous, escrow-protected, pay-per-unlock Q&A marketplace on Monad blockchain.**

| Feature | How It Works |
|---------|---------------|
| 🔒 **Anonymous Posting** | Ask without revealing your identity. No shame, no judgment. |
| 💰 **Set Your Own Bounty** | Askers decide the reward (0.5 to 100 MON). Solvers set their price. |
| ⚡ **Instant Payout** | Purchase an answer → solver gets paid in 1 second. |
| 🔐 **Preview + Unlock** | See 20% preview free. Pay to unlock the full answer. |
| 🏆 **Pick the Best** | Compare multiple previews, buy only the best answer. |
| ⏰ **Auto-Refund** | No good answer? Get your full bounty back. |

---

## 🔐 The Secret Sauce: Preview + Pay-Per-Unlock

**The #1 fear in bounty systems:** *"What if multiple people answer and the asker only wants to pay one?"*

**What if the asker doesn't want to pay at all?**

**UniSolve solves this with encrypted answers + free previews:**
┌─────────────────────────────────────────────────────────────────┐
│ UniSolve Answer Flow │
├─────────────────────────────────────────────────────────────────┤
│ │
│ 👩‍💻 Solver writes answer │
│ │ │
│ ▼ │
│ ✂️ Split answer into two parts: │
│ - 20% PREVIEW (free, proves you know the answer) │
│ - 80% FULL (encrypted, pay to unlock) │
│ │ │
│ ▼ │
│ 📤 Upload to Monad blockchain │
│ │ │
│ ▼ │
│ 👨‍🎓 Asker sees ALL previews from ALL solvers: │
│ │
│ "Solver A: 'Your bug is caused by variable type...'" │
│ "Solver B: 'The loop condition should be i<10...'" │
│ │ │
│ ├──────────────────────────────────────────────┐ │
│ │ │ │
│ ▼ ▼ │
│ 💰 Pick the best preview 🙅 Skip │
│ Pay to unlock full answer │ │
│ │ │ │
│ ▼ ▼ │
│ 🔓 Get complete solution Get refund │
│ │ (if no buy) │
│ ▼ │ │
│ ✅ Solver gets paid │ │
│ │
└─────────────────────────────────────────────────────────────────┘

**Why this works:**

| Role | What They Get | Risk |
|------|---------------|------|
| **Asker** | Compare multiple answers, pay only for the best | Zero - refund if no good answer |
| **Solver** | Paid when answer is purchased | Low - only wrote 20% preview if not chosen |
| **Cheater** | Try to steal answers | Impossible - full answer is encrypted |

---

## 💰 How Pricing Works

| Who | What They Set | Example |
|-----|---------------|---------|
| **Asker** | Bounty (total reward pool) | "I'll pay 5 MON for this SQL question" |
| **Solver** | Price (must be ≤ bounty) | "I'll solve it for 3 MON" |
| **Market** | Askers compare previews, buy the best value | Cheaper or better preview wins |

**Typical bounties by difficulty:**

| Difficulty | Typical Bounty (MON) |
|------------|----------------------|
| Simple Bug (syntax, typo) | 0.5 - 1 MON |
| Medium Problem (logic, SQL) | 2 - 5 MON |
| Complex Issue (algorithm) | 5 - 10 MON |
| Full Project Help | 10 - 50 MON |

---

## ⚡ Why Monad?

| Feature | Why UniSolve Needs It |
|---------|----------------------|
| **10,000+ TPS** | Handle thousands of students asking questions simultaneously |
| **1-second finality** | "I paid. Where's my answer?" → 1 second. No waiting. |
| **Near-zero gas** | A 1 MON bounty on Ethereum costs 2 MON in gas. On Monad? <0.01 MON. **Micro-bounties become viable.** |
| **EVM-compatible** | Deploy existing Solidity code. No new language to learn. |

> **Traditional blockchains make micro-transactions impossible. Monad makes them profitable.**

---

## 🏗️ Technical Architecture

### Smart Contract (`UniSolve.sol`)

```solidity
// Core functions
function createQuestion(string title, string preview, uint bounty, uint duration) external payable
function submitAnswer(uint questionId, string preview, string encryptedFull, string proof, uint price) external
function purchaseAnswer(uint questionId, uint answerId) external payable
function selectWinner(uint questionId, uint answerId) external
function refundTimeout(uint questionId) external

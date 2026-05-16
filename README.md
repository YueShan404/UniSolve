# 📚 StudyBounty

### *Decentralized Study互助平台 on Monad Blockchain*

[![Monad](https://img.shields.io/badge/Built%20on-Monad-00FF88)](https://monad.xyz)
[![Hackathon](https://img.shields.io/badge/Monad%20Blitz-KL%202026-blue)](https://lu.ma/monad-blitz-kl)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

---

## 🎯 The Problem

**Students waste hours stuck on problems. No one answers in group chats. No incentive to help.**

- ❌ Ask in WhatsApp group → no one replies
- ❌ Ask friends → they might not know
- ❌ Traditional Q&A platforms → no guarantee of quality

**Worst of all: Answerers fear not getting paid. Askers fear paying for bad answers.**

---

## 💡 The Solution: StudyBounty

A decentralized study互助平台 with **preview-first, pay-to-unlock** mechanism.

### How It Works
┌─────────────────────────────────────────────────────────────┐
│ StudyBounty Flow │
├─────────────────────────────────────────────────────────────┤
│ │
│ 1. Asker posts question + deposits bounty to smart contract│
│ ↓ │
│ 2. Answerers submit PREVIEW (first 100 chars) │
│ ↓ │
│ 3. Asker reads previews → chooses best one │
│ ↓ │
│ 4. Asker clicks UNLOCK → auto-pay to answerer │
│ ↓ │
│ 5. Full answer revealed. Remaining bounty refunded. │
│ │
└─────────────────────────────────────────────────────────────┘



### Why This Works

| Problem | StudyBounty Solution |
|---------|----------------------|
| Answerers fear no payment | ✅ Bounty locked in smart contract escrow |
| Askers fear bad answers | ✅ Preview first, pay only if satisfied |
| No incentive to help | ✅ Earn MON tokens + reputation points |
| No quality guarantee | ✅ Reputation system rewards good answerers |

---

## 🔧 Why Monad?

| Feature | Why It Matters for StudyBounty |
|---------|-------------------------------|
| **10,000+ TPS** | Handle hundreds of students unlocking answers simultaneously during exam season |
| **< $0.01 Gas** | Micro-payments (0.1 MON unlocks) become feasible. Ethereum would cost $5+ per tx |
| **1 sec finality** | Instant unlock experience - no waiting 15 minutes |
| **EVM compatible** | Use Solidity + MetaMask. No new language to learn |

> **Traditional blockchains like Ethereum are too slow and expensive for micro-payments. Monad makes StudyBounty possible.**

---

## 📦 Smart Contract

### Core Functions

```solidity
// Ask a question with bounty
function askQuestion(
    string memory _title,
    string memory _content,
    uint256 _deadlineHours
) external payable returns (uint256);

// Submit answer with preview
function submitAnswer(
    uint256 _questionId,
    string memory _preview,
    string memory _fullContentHash,
    uint256 _price
) external;

// Unlock full answer (auto-pay)
function unlockAnswer(
    uint256 _questionId,
    uint256 _answerIndex
) external;

// Close question and refund remaining bounty
function closeQuestion(uint256 _questionId) external;

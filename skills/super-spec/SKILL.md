---
name: super-spec
description: "Research-driven, delivery-ready specification engine that generates BRD + SRS + UX Blueprint + PBIs from minimal input. Use this skill whenever the user mentions 'super spec', 'full spec', 'complete spec', 'BRD', 'SRS', 'product requirements', 'system requirements', 'PBI', 'product backlog', 'backlog items', 'spec everything', 'turn this idea into a spec', 'requirements package', 'delivery-ready spec', or gives a brief product description and expects comprehensive requirements output. Also triggers on 'สเปคเต็ม', 'สร้าง BRD', 'สร้าง SRS', 'ทำ PBI', 'เขียน requirement', 'แปลงไอเดียเป็น spec', 'วิเคราะห์ระบบ', 'ออกแบบระบบเต็มรูปแบบ'. This is Sage's most powerful skill — it turns even a 2-word input like 'digital wallet' into a complete requirements package that PM, UX, Dev, and QA can start working from immediately. Use this over basic spec-kit when the user needs comprehensive, multi-role deliverables."
---

# Super Spec Engine

> **"From a napkin sketch to a delivery-ready package. One prompt. Every role covered."**

This is Sage's ultimate skill — a research-driven specification engine that generates a complete requirements package from minimal input. It produces artifacts that are simultaneously **PM-ready, UX-ready, Dev-ready, QA-ready, and API-ready**.

## What Makes This Different from spec-kit

| Aspect | spec-kit | super-spec |
|--------|----------|------------|
| Input | Detailed requirements from user | Even 2 words (e.g., "digital wallet") |
| Research | None — works from what you give | Web research for domain, competitors, regulations |
| Output | SPEC.md with requirements + tasks | 9-section package: Context → Research → System Analysis → BRD → SRS → UX Blueprint → PBIs → Role Summary → Open Questions |
| UX coverage | Minimal | Full Figma-ready blueprint with screens, states, components |
| PBI quality | Task breakdown | INVEST-compliant, QA-ready, Dev-ready, Figma-mapped |
| Target | Developer implementing features | Entire team: PM, UX, Dev, QA, Compliance |

## When to Use

- **New product from scratch** — user has an idea, needs the full package
- **Feature expansion** — existing product needs a major new module specced out
- **Stakeholder alignment** — need a document that PM, Dev, UX, and QA can all read
- **RFP/Proposal support** — need professional requirements documentation fast
- **Domain you're unfamiliar with** — research-driven approach fills knowledge gaps

## Process

### Phase 0: Parse the Brief

From whatever the user provides (even just "digital wallet"), extract or infer:

| Field | Source | Example |
|-------|--------|---------|
| `product_keyword` | Provided or inferred | "digital wallet" |
| `domain` | Inferred from keyword | Fintech, payments |
| `target_users` | Inferred or asked | Consumers 18-45, merchants |
| `primary_goals` | Inferred or asked | P2P payments, bill pay, loyalty |
| `market_region` | Inferred from user locale | Thailand / SEA |
| `product_stage` | Asked or inferred | MVP / Growth / Enterprise |
| `tech_constraints` | Asked or inferred | Mobile-first, React Native, Firebase |
| `regulatory_focus` | Inferred from domain + region | PDPA, BOT regulations, PCI-DSS |
| `research_depth` | Based on domain complexity | Normal / Deep / Skip |
| `language` | Mirror user's language | Thai body text, English framework terms |

**Rules:**
- If `product_keyword`, `domain`, `target_users`, or `primary_goals` is missing → infer reasonable defaults, mark as `[ASSUMED]`, keep generic enough to be reusable
- Mirror user's language for body text, but keep framework terms (BRD, SRS, PBI, INVEST) in English
- If web research is unavailable → skip research section, note it explicitly

### Phase 1: Research & Feature Landscape

Form concrete research questions before searching:
- What are the must-have features for [product] in [market]?
- Who are the main competitors and what do they offer?
- What UX patterns are standard in this domain?
- What regulations apply in [region]?
- What are common failure modes and risks?

**Output — Feature Landscape:**

```markdown
## Feature Landscape

### Must-Have (MVP)
| Feature | Reason | Competitor Reference |
|---------|--------|---------------------|
| User registration + KYC | Regulatory requirement (BOT) | All major wallets |
| P2P transfer | Core value proposition | PromptPay, TrueMoney |
| Transaction history | User expectation, compliance | Universal |
| PIN/Biometric auth | Security baseline | Universal |

### Nice-to-Have (v1.1+)
| Feature | Reason | Risk if Skipped |
|---------|--------|----------------|
| Bill payment | Revenue expansion | Lower daily usage |
| QR code payments | Merchant adoption | Limited offline use |
| Spending analytics | Engagement + retention | Users go elsewhere for insights |

### Experimental (v2+)
| Feature | Potential | Risk |
|---------|-----------|------|
| AI spending advisor | Differentiation | Over-engineering for MVP |
| Crypto integration | Market trend | Regulatory uncertainty |

### Not Recommended
| Feature | Why Not |
|---------|---------|
| Social feed | Off-brand, privacy concern, no clear ROI |
| Built-in marketplace | Scope explosion, better as integration |
```

### Phase 2: Super System Analysis

```markdown
## Super System Analysis

### Stakeholders & Roles
| Stakeholder | Role | Needs |
|------------|------|-------|
| End User (Consumer) | Primary user | Send/receive money, pay bills, track spending |
| Merchant | Payment acceptor | Receive payments, view settlements |
| Compliance Officer | Regulatory | KYC verification, transaction monitoring |
| System Admin | Operations | User management, system health, dispute resolution |
| Product Owner | Strategy | Analytics, feature usage, conversion data |

### Key User Journeys
1. **Registration & KYC** — Download → Register → Verify ID → Set PIN → Ready
2. **P2P Transfer** — Open app → Select recipient → Enter amount → Confirm → Receipt
3. **Bill Payment** — Select biller → Enter reference → Confirm → Receipt
4. **Merchant Payment** — Scan QR → Confirm amount → PIN/Bio → Receipt
5. **Dispute Resolution** — View transaction → Report issue → Track status → Resolution

### System Context (Verbal Diagram)
The wallet system sits between the user's mobile device and multiple external systems:
- **Payment Gateway** — processes actual fund movements
- **KYC Provider** — identity verification (e.g., NDID, manual review)
- **Bank APIs** — top-up from bank accounts, withdrawals
- **Biller Aggregator** — bill payment routing
- **Notification Service** — push, SMS, email
- **Fraud Detection** — real-time transaction scoring
- **Analytics Platform** — usage tracking, business intelligence

### Major Components
1. **Mobile App** (React Native / Flutter) — UI layer
2. **API Gateway** — auth, rate limiting, routing
3. **Auth Service** — registration, login, PIN, biometrics, 2FA
4. **Wallet Service** — balance, transfers, transaction log
5. **Payment Service** — external payment routing
6. **KYC Service** — identity verification workflow
7. **Notification Service** — multi-channel delivery
8. **Admin Portal** — back-office operations

### Main Data Entities
- User (profile, KYC status, wallet)
- Wallet (balance, currency, status)
- Transaction (type, amount, from, to, status, timestamp)
- KYC Record (document type, verification status, expiry)
- Notification (type, channel, status, sent_at)

### Non-Functional Requirements
| Category | Requirement | Target |
|----------|-------------|--------|
| Performance | API response time | p95 < 500ms |
| Availability | System uptime | 99.9% |
| Security | Data encryption | AES-256 at rest, TLS 1.3 in transit |
| Scalability | Concurrent users | 100K initial, scale to 1M |
| Compliance | Data retention | Per BOT/PDPA requirements |
| Localization | Languages | Thai (primary), English |
```

### Phase 3: BRD (Business Requirements Document)

```markdown
## BRD — Business Requirements

### Problem Statement
[Target users] in [market] lack a [reliable/affordable/convenient] way to [primary pain point].
Current solutions [competitor gaps]. This creates an opportunity for [product] to [value proposition].

### Business Goals & KPIs
| Goal | KPI | Target (6 months) |
|------|-----|-------------------|
| User acquisition | Monthly active users | 50,000 MAU |
| Transaction volume | Daily transactions | 10,000/day |
| Revenue | Transaction fees | <fee structure TBD> |
| Retention | D30 retention rate | > 40% |
| Compliance | KYC completion rate | > 80% within 24h |

### In-Scope
- User registration and KYC
- Wallet management (top-up, withdrawal)
- P2P transfers
- Transaction history and receipts
- PIN and biometric authentication
- Push notifications
- Admin portal (basic)

### Out-of-Scope (for this phase)
- Merchant onboarding portal
- Credit/lending features
- Cryptocurrency
- International remittance
- Physical card issuance

### Business Requirements (Grouped)
**BR-AUTH: Authentication & Identity**
- BR-AUTH-01: Users must complete KYC before transacting
- BR-AUTH-02: PIN required for all financial transactions
- BR-AUTH-03: Biometric login as optional convenience

**BR-WALLET: Wallet Operations**
- BR-WAL-01: Users can top up from linked bank accounts
- BR-WAL-02: Users can transfer to other wallet users
- BR-WAL-03: Users can view real-time balance
- BR-WAL-04: All transactions generate receipts

**BR-COMP: Compliance**
- BR-COMP-01: System must comply with BOT e-money regulations
- BR-COMP-02: Transaction data retained per PDPA requirements
- BR-COMP-03: Suspicious transaction monitoring and reporting

### Business Risks & Assumptions
| # | Type | Description | Mitigation |
|---|------|-------------|-----------|
| R1 | Risk | Regulatory changes may require feature modification | Modular architecture, compliance buffer |
| R2 | Risk | Low KYC completion rate blocks activation | Streamlined UX, progressive KYC |
| A1 | Assumption | Bank API integration available | Confirm with partner banks |
| A2 | Assumption | Users have smartphones with internet | Target urban demographics first |
```

### Phase 4: SRS (Software Requirements Specification)

```markdown
## SRS — Functional Requirements

### Module: AUTH
| ID | Requirement | Input | Output | Precondition | Postcondition |
|----|------------|-------|--------|-------------|---------------|
| FR-AUTH-01 | Register with phone number | phone, OTP | user account created | phone not registered | account in PENDING_KYC state |
| FR-AUTH-02 | Complete KYC | ID photo, selfie | KYC status updated | account exists | status → VERIFIED or REJECTED |
| FR-AUTH-03 | Set transaction PIN | 6-digit PIN | PIN stored (hashed) | KYC verified | PIN active |
| FR-AUTH-04 | Login with biometric | fingerprint/face | session token | biometric enrolled | user authenticated |

### Module: WALLET
| ID | Requirement | Input | Output | Precondition | Postcondition |
|----|------------|-------|--------|-------------|---------------|
| FR-WAL-01 | Check balance | user_id | balance amount | authenticated | — |
| FR-WAL-02 | Top up from bank | amount, bank_account | balance increased | KYC verified, bank linked | transaction recorded |
| FR-WAL-03 | P2P transfer | recipient, amount, PIN | both balances updated | sufficient balance, valid PIN | transaction recorded, notifications sent |
| FR-WAL-04 | View transaction history | user_id, filters | paginated list | authenticated | — |

### Validation Rules
- PIN: exactly 6 digits, no sequential (123456), no repeated (111111)
- Transfer amount: min 1 THB, max 50,000 THB per transaction, daily limit 200,000 THB
- Phone: Thai mobile format (+66XXXXXXXXX)
- KYC documents: JPEG/PNG, max 10MB, readable quality

### API Outline
| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | /auth/register | Phone + OTP registration |
| POST | /auth/verify-otp | OTP verification |
| POST | /auth/kyc | Submit KYC documents |
| POST | /auth/pin | Set/change PIN |
| GET | /wallet/balance | Get current balance |
| POST | /wallet/topup | Top up from bank |
| POST | /wallet/transfer | P2P transfer |
| GET | /wallet/transactions | Transaction history |

### Integration Requirements
| External System | Protocol | Purpose |
|----------------|----------|---------|
| Bank APIs | REST + OAuth2 | Top-up, withdrawal |
| KYC Provider | REST + webhook | Identity verification |
| SMS Gateway | REST | OTP delivery |
| Push Service | FCM/APNS | Notifications |
| Fraud Engine | Event stream | Real-time scoring |

### Cross-Cutting Concerns
- **Security**: JWT tokens (15min access, 7d refresh), rate limiting (5 OTP/hour), request signing
- **Logging**: Structured JSON, transaction audit trail, PII masking in logs
- **Monitoring**: Health checks, latency dashboards, error rate alerts, transaction anomaly detection
- **Localization**: Thai (default), English, date/currency formatting per locale
```

### Phase 5: Figma-Ready UX/UI Blueprint

```markdown
## UX/UI Blueprint

### Key Flows
1. Onboarding: Splash → Phone Input → OTP → KYC Upload → PIN Setup → Home
2. Transfer: Home → Send → Recipient → Amount → Confirm (PIN) → Success
3. Top-up: Home → Top-up → Bank Select → Amount → Confirm → Success
4. History: Home → Transactions → Filter → Detail → Receipt

### Screen Inventory
| Screen | States |
|--------|--------|
| Splash | Loading, Update Required |
| Phone Input | Empty, Typing, Validating, Error (invalid format), Error (already registered) |
| OTP Verification | Waiting, Typing, Verifying, Error (wrong OTP), Error (expired), Resend cooldown |
| KYC Upload | Empty, Camera active, Preview, Uploading, Success, Error (unreadable), Rejected |
| PIN Setup | Empty, Entering, Confirming, Mismatch error, Success |
| Home | Normal (with balance), Empty (no transactions), Loading, Error (network), KYC Pending banner |
| Send Money | Recipient search, Amount input, Confirm modal, Processing, Success + receipt, Error (insufficient), Error (network) |
| Transaction History | List view, Empty state, Loading skeleton, Filter panel, Pull-to-refresh |
| Transaction Detail | Normal, Dispute button, Disputed status |
| Settings | Profile, Security (PIN change, biometric toggle), Linked banks, Language, Logout |

### Core Components
- **Balance Card** — prominent balance display with hide toggle
- **Quick Actions** — Send, Top-up, Pay, History (icon grid)
- **Transaction Row** — icon + name + amount + time + status badge
- **PIN Pad** — custom numeric keyboard with biometric shortcut
- **Receipt Card** — shareable transaction receipt
- **Status Badge** — Success (green), Pending (amber), Failed (red)
- **Empty State** — illustration + message + CTA button
- **Skeleton Loader** — placeholder shimmer matching content layout

### Navigation Pattern
- Bottom tab bar: Home, Pay, History, Profile
- Modal sheets for confirmations and PIN entry
- Stack navigation within each tab
- No drawer menu (mobile wallet convention)

### UX Guidelines
- One primary action per screen
- Confirm before any financial action (amount → confirm → PIN → done)
- Show loading states for ALL async operations
- Error messages must be actionable: "Insufficient balance. Top up?" not "Error 402"
- Biometric prompt before PIN pad (convenience first)
- Receipt always auto-generated and shareable
```

### Phase 6: PBIs (Product Backlog Items)

Generate INVEST-compliant PBIs with multi-role readiness:

```markdown
## PBI Example

### PBI-001: User Registration with Phone Number
**Type:** User Story
**Epic:** Onboarding

**Story:** As a new user, I want to register with my phone number so that I can create a wallet account.

**Business Value:** Foundation for all other features — no registration = no users.

**Acceptance Criteria:**
1. Given a valid Thai phone number (+66XXXXXXXXX), when I submit, then I receive an OTP via SMS within 30 seconds
2. Given an already-registered phone, when I submit, then I see "This number is already registered. Login instead?" with a login link
3. Given an invalid phone format, when I submit, then I see inline validation "Please enter a valid Thai phone number"
4. Given OTP sent, when 60 seconds pass without verification, then the OTP expires and I can request a new one
5. Given correct OTP, when I verify, then my account is created with status PENDING_KYC

**QA Notes:**
- Positive: valid phone → OTP received → verify → account created
- Negative: invalid format, already registered, wrong OTP, expired OTP, network timeout
- Boundary: OTP at exactly 60s, phone with leading zero vs +66, max OTP retries (5)
- Data: test with real carrier numbers (AIS, DTAC, TRUE prefixes)

**DEV Notes:**
- Service: auth-service
- API: POST /auth/register, POST /auth/verify-otp
- DB: Create user record (status: PENDING_KYC), store OTP hash with TTL
- SMS: Integrate with SMS gateway (rate limit: 5 OTP/hour/phone)
- Error handling: SMS delivery failure → show "SMS not delivered, try again" with retry button
- Idempotency: same phone + same session → return existing OTP, don't create duplicate

**Figma Mapping:**
- Screens: Phone Input, OTP Verification
- States: Empty, Typing, Validating, Error (3 variants), Resend cooldown timer
- Components: Phone input field with +66 prefix, OTP 6-digit input, Countdown timer, Error toast

**Dependencies:** SMS Gateway integration (PBI-TECH-01)
**Risks:** SMS delivery delays in rural areas
**Assumptions:** User has active Thai mobile number
**Research Note:** PromptPay registration uses similar phone-first flow; industry standard in Thai fintech
```

### Phase 7: Role-Based Summary

```markdown
## What Each Role Can Start Doing Now

### PM / BA
- Review feature landscape and challenge priorities
- Validate business goals and KPIs with stakeholders
- Refine out-of-scope decisions
- Create Jira epics from the PBI groupings

### UX / Figma Designers
- Build Figma frames from the Screen Inventory
- Design all listed states (empty, loading, error, success)
- Create component library from Core Components list
- Prototype the 4 key flows

### Developers
- Set up project scaffolding (API gateway, auth service, wallet service)
- Implement PBIs in suggested priority order
- Use API outline for contract-first development
- Reference DEV notes in each PBI for service/data details

### QA
- Write test cases from acceptance criteria (already Given/When/Then)
- Use QA notes for edge cases and boundary testing
- Set up test data for Thai phone numbers, OTP scenarios
- Plan integration tests for bank API and KYC provider

### Compliance / Security
- Review regulatory requirements (BR-COMP-01 through 03)
- Validate KYC flow against BOT requirements
- Review data retention policy alignment with PDPA
- Assess fraud detection requirements
```

### Phase 8: Open Questions & Gaps

```markdown
## Open Questions & Gaps

| # | Question | Owner | Impact if Unresolved |
|---|---------|-------|---------------------|
| Q1 | Which KYC provider will be used? (NDID, manual, third-party) | PM + Compliance | Blocks KYC flow design |
| Q2 | Exact transaction fee structure? | Business | Affects transfer flow UX |
| Q3 | Which banks for initial top-up integration? | PM + Partnerships | Blocks top-up feature |
| Q4 | Daily/monthly transaction limits per user tier? | Compliance | Affects validation rules |
| Q5 | Dispute resolution SLA? | Operations | Affects dispute flow design |
| Q6 | Multi-currency support in v1? | PM | Affects data model complexity |

⚠️ **Compliance Notice:** This specification covers a regulated financial product.
All requirements marked BR-COMP-* must be reviewed by legal and compliance teams
before implementation. This document does not constitute legal or regulatory advice.
```

## Output Structure

When this skill is triggered, produce all 9 sections in order:

1. **Context Recap & Assumptions** — parsed brief + marked assumptions
2. **Research Insights & Feature Landscape** — must-have / nice-to-have / experimental / not-recommended
3. **Super System Analysis** — stakeholders, journeys, context, components, data, NFRs
4. **BRD** — problem, goals, KPIs, scope, grouped requirements, risks
5. **SRS** — functional requirements per module, validation, APIs, data model, integrations, cross-cutting
6. **UX/UI Blueprint** — flows, screens, states, components, navigation, guidelines (Figma-ready)
7. **PBIs** — INVEST-compliant, grouped by epic, each with: AC, QA notes, DEV notes, Figma mapping
8. **Role Summary** — what PM, UX, Dev, QA, Compliance can start doing immediately
9. **Open Questions** — what the real team must still decide

## Formatting Rules

- Mirror user's language for body text (Thai/English)
- Keep framework terms in English: BRD, SRS, PBI, INVEST, MVP, KPI, API
- Use requirement IDs: BR-XXX-NN (business), FR-XXX-NN (functional), NFR-XXX-NN (non-functional)
- Use PBI IDs: PBI-NNN for stories, PBI-TECH-NNN for tech enablers, PBI-UX-NNN for design tasks
- Tables for structured data, prose for narratives
- Mermaid sequence diagrams for complex flows when helpful

## Safety & Compliance Rules

- **Never invent** confidential data, exact contracts, internal numbers, or real customer details
- Use placeholders: `<fee structure TBD>`, `<provider name TBD>`, `<legal review required>`
- For regulated domains (finance, health, safety, privacy): stay high-level on compliance, add explicit review notices
- **Never provide** legal, medical, or investment advice
- Always include the compliance notice in the Open Questions section for regulated products

## Integration with AEGIS

- **Owned by:** 📐 Sage (primary), with input from 🖌️ Pixel (UX sections)
- **Feeds into:** ⚡ Bolt (DEV notes → implementation), 🛡️ Vigil (AC → test cases), 🔧 Forge (PBIs → sprint-tracker)
- **Enhanced by:** Research via web search (when available)
- **Chained from:** `project-navigator` recommends super-spec for new products
- **Chained to:** `code-standards` (after spec, before implementation)

This is the most comprehensive skill in AEGIS. One prompt → entire team can start working.

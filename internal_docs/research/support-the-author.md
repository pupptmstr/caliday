# "Support the author" button — idea

> Part of the project notes — the index is [internal_docs/README.md](../README.md).

## "Support the Author" Button — idea

IAP via StoreKit 2 (iOS) and Google Play Billing (Android).
Package: `in_app_purchase` (official Flutter).

Products (consumable):
- `tip_small` — ~99₽ / $0.99
- `tip_medium` — ~249₽ / $2.99
- `tip_large` — ~499₽ / $4.99

Placement: Settings → About.
To be tackled after the first real release.

### ⚠️ Tax / Legal Prerequisite (Germany)

Before implementing, the author must resolve the legal/tax setup for receiving income.
Key points for Germany (discussed 2026-03-23, not a substitute for professional advice):

- **Gewerbe registration** — file Gewerbeanmeldung at local Ordnungsamt (~€26).
  Finanzamt will send a tax questionnaire (Fragebogen zur steuerlichen Erfassung) → get Steuernummer.
- **Kleinunternehmerregelung** — if annual revenue < €25 000, no VAT obligations.
  Apple/Google already act as marketplace facilitators and remit EU VAT themselves.
- **Income tax (Einkommensteuer)** — profit (revenue − expenses) added to personal income.
  Tax-free up to ~€12 000/year (Grundfreibetrag), then progressive 14–45%.
  Filed annually via Einkommensteuererklärung (deadline: July 31 of following year).
- **Gewerbesteuer** — only applies above ~€24 500 profit/year; unlikely at launch.
- **Deductible expenses**: Apple/Google developer fees, hardware, courses, Steuerberater fees.
- **Recommendation**: consult a Steuerberater before publishing paid features.

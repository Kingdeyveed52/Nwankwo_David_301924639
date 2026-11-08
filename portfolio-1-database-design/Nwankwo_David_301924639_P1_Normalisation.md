# Bank / Fintech Platform — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| customer_id | account records (list) |
| --- | --- |
| 1 | [3] |
| 2 | [4] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| account.id | account.customer_id | account.account_number | customer.id | customer.full_name |
| --- | --- | --- | --- | --- |
| 3 | 1 | ACCT-1001 | 1 | Alex Rivera |
| 4 | 2 | ACCT-1002 | 2 | Sam Chen |

Key: id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## account_example

| account.id | account.customer_id | account.account_number | customer.id | customer.full_name |
| --- | --- | --- | --- | --- |
| 3 | 1 | ACCT-1001 | 1 | Alex Rivera |
| 4 | 2 | ACCT-1002 | 2 | Sam Chen |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| id | full_name | email | created_at |
| --- | --- | --- | --- |
| 1 | Alex Rivera | alex.rivera@example.test | 2026-01-10T09:00:00+00:00 |
| 2 | Sam Chen | sam.chen@example.test | 2026-01-11T10:30:00+00:00 |

## account

| id | customer_id | account_number | currency | balance | status | is_primary | opened_at |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3 | 1 | ACCT-1001 | USD | 750.25 | active | true | 2026-01-12T08:15:00+00:00 |
| 4 | 2 | ACCT-1002 | USD | 420 | active | true | 2026-01-13T11:45:00+00:00 |

## transfer

| id | source_account_id | destination_account_id | amount | currency | status | idempotency_key | created_at |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | 4 | 25.5 | USD | completed | idem-seed-001 | 2026-02-01T14:00:00+00:00 |
| 6 | 4 | 3 | 10 | USD | pending | idem-seed-002 | 2026-02-02T15:30:00+00:00 |

## Dependencies

- customer: (id) → full_name, email, created_at
- account: (id) → customer_id, account_number, currency, balance, status, is_primary, opened_at
- transfer: (id) → source_account_id, destination_account_id, amount, currency, status, idempotency_key, created_at

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.

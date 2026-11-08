# Bank / Fintech Platform — database design

My case study records customer, account, transfer.

## Users

- Customers reviewing account activity
- Operations staff reviewing transfers
- Students practicing relational design and transactions

## Main operations

- Open an account for a customer and record its currency and status.
- Transfer funds between eligible accounts in the same currency.
- Review outgoing transfers and summarize activity by account and month.
- Separate benchmark plan: generate 50,000 synthetic transfer records; compare a date-range filter before and after a B-tree index on transfer.created_at; record plan shape, rows examined, and measured duration without assuming an outcome.

## Entities

| Entity | Information stored |
| --- | --- |
| customer | A person or organization that owns one or more accounts. |
| account | A customer-owned account with a currency, status, and current balance. |
| transfer | A same-currency movement of funds between two accounts, recorded with a status and idempotency key. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## account

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| account_number | TEXT | Unique | Yes |
| currency | TEXT |  | Yes |
| balance | NUMERIC(18,2) |  | Yes |
| status | TEXT |  | Yes |
| is_primary | BOOLEAN |  | Yes |
| opened_at | TIMESTAMPTZ |  | Yes |
- customer_id → customer.id
- Unique key: (account_number).

## transfer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| source_account_id | BIGINT | FK | Yes |
| destination_account_id | BIGINT | FK | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| currency | TEXT |  | Yes |
| status | TEXT |  | Yes |
| idempotency_key | TEXT | Unique | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- source_account_id → account.id
- destination_account_id → account.id
- Unique key: (idempotency_key).

## Relationships and business rules

- Each customer email identifies at most one customer.
- Every account must reference an existing customer through customer_id.
- An account balance must be zero or greater.
- A customer may have at most one primary account; enforce with a partial unique constraint on customer_id for rows where is_primary is true.
- Every transfer must reference an existing source account through source_account_id.
- Every transfer must reference an existing destination account through destination_account_id.
- A transfer amount must be greater than zero.
- An idempotency key may identify at most one transfer, preventing duplicate processing for a retried request.

## Assumptions

- Use synthetic values only. Each entity has a single-column id primary key; IDs are UUIDs generated from one shared namespace and are globally unique across all three tables.
- For a simple normalization example, account is the root entity with a foreign key to customer. Customer name and email remain in customer rather than being repeated on account; the example follows only this one parent relationship.
- A transfer has one source and one destination account, both in the transfer's stated currency. The exercise assumes application validation occurs within the transaction.
- Account balance is a simplified current-balance value, while transfer records provide a basic activity history; this is not a full accounting ledger.


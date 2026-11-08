# Bank / Fintech Platform — ER diagram

```mermaid
erDiagram
    direction LR
    customer {
        bigint id PK
        text full_name
        text email UK
        timestamptz created_at
    }
    account {
        bigint id PK
        bigint customer_id FK
        text account_number UK
        text currency
        numeric balance
        text status
        boolean is_primary
        timestamptz opened_at
    }
    transfer {
        bigint id PK
        bigint source_account_id FK
        bigint destination_account_id FK
        numeric amount
        text currency
        text status
        text idempotency_key UK
        timestamptz created_at
    }
    customer ||--o{ account : "customer_id"
    account ||--o{ transfer : "source_account_id"
    account ||--o{ transfer : "destination_account_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Nwankwo_David_301924639_ERDiagram.png)

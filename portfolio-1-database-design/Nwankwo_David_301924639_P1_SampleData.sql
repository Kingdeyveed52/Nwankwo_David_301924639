-- Fictional sample records for Bank / Fintech Platform.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("id", "full_name", "email", "created_at") VALUES (1, 'Alex Rivera', 'alex.rivera@example.test', '2026-01-10T09:00:00Z');
INSERT INTO portfolio."customer" ("id", "full_name", "email", "created_at") VALUES (2, 'Sam Chen', 'sam.chen@example.test', '2026-01-11T10:30:00Z');
INSERT INTO portfolio."account" ("id", "customer_id", "account_number", "currency", "balance", "status", "is_primary", "opened_at") VALUES (3, 1, 'ACCT-1001', 'USD', 750.25, 'active', TRUE, '2026-01-12T08:15:00Z');
INSERT INTO portfolio."account" ("id", "customer_id", "account_number", "currency", "balance", "status", "is_primary", "opened_at") VALUES (4, 2, 'ACCT-1002', 'USD', 420, 'active', TRUE, '2026-01-13T11:45:00Z');
INSERT INTO portfolio."transfer" ("id", "source_account_id", "destination_account_id", "amount", "currency", "status", "idempotency_key", "created_at") VALUES (5, 3, 4, 25.5, 'USD', 'completed', 'idem-seed-001', '2026-02-01T14:00:00Z');
INSERT INTO portfolio."transfer" ("id", "source_account_id", "destination_account_id", "amount", "currency", "status", "idempotency_key", "created_at") VALUES (6, 4, 3, 10, 'USD', 'pending', 'idem-seed-002', '2026-02-02T15:30:00Z');
COMMIT;

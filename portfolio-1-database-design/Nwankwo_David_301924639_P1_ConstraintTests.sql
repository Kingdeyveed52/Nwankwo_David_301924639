-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("id", "full_name", "email", "created_at")
VALUES (1, 'Taylor Lee', 'taylor.lee@example.test', '2026-03-01T09:00:00Z');

-- 2. customer unique. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("id", "full_name", "email", "created_at")
VALUES (1001, 'Taylor Lee', 'alex.rivera@example.test', '2026-03-01T09:01:00Z');

-- 3. customer not null. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("id", "full_name", "email", "created_at")
VALUES (1002, NULL, 'null.name@example.test', '2026-03-01T09:02:00Z');

-- 4. account pk. Expected: pk_account, SQLSTATE 23505.
INSERT INTO portfolio."account" ("id", "customer_id", "account_number", "currency", "balance", "status", "is_primary", "opened_at")
VALUES (3, 1, 'ACCT-2001', 'USD', 50, 'active', FALSE, '2026-03-01T09:03:00Z');

-- 5. account unique. Expected: uq_account_0, SQLSTATE 23505.
INSERT INTO portfolio."account" ("id", "customer_id", "account_number", "currency", "balance", "status", "is_primary", "opened_at")
VALUES (1003, 1, 'ACCT-1001', 'USD', 50, 'active', FALSE, '2026-03-01T09:04:00Z');

-- 6. account fk. Expected: fk_account_0, SQLSTATE 23503.
INSERT INTO portfolio."account" ("id", "customer_id", "account_number", "currency", "balance", "status", "is_primary", "opened_at")
VALUES (1004, 9001, 'ACCT-2002', 'USD', 50, 'active', FALSE, '2026-03-01T09:05:00Z');

-- 7. account check. Expected: account_balance_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."account" ("id", "customer_id", "account_number", "currency", "balance", "status", "is_primary", "opened_at")
VALUES (1005, 1, 'ACCT-2003', 'USD', -1, 'active', FALSE, '2026-03-01T09:06:00Z');

-- 8. account partial unique. Expected: account_one_primary_per_customer, SQLSTATE 23505.
INSERT INTO portfolio."account" ("id", "customer_id", "account_number", "currency", "balance", "status", "is_primary", "opened_at")
VALUES (1006, 1, 'ACCT-2004', 'USD', 50, 'active', TRUE, '2026-03-01T09:07:00Z');

-- 9. transfer pk. Expected: pk_transfer, SQLSTATE 23505.
INSERT INTO portfolio."transfer" ("id", "source_account_id", "destination_account_id", "amount", "currency", "status", "idempotency_key", "created_at")
VALUES (5, 3, 4, 5, 'USD', 'completed', 'idem-test-pk', '2026-03-01T09:08:00Z');

-- 10. transfer unique. Expected: uq_transfer_0, SQLSTATE 23505.
INSERT INTO portfolio."transfer" ("id", "source_account_id", "destination_account_id", "amount", "currency", "status", "idempotency_key", "created_at")
VALUES (1007, 3, 4, 5, 'USD', 'completed', 'idem-seed-001', '2026-03-01T09:09:00Z');

-- 11. transfer source fk. Expected: fk_transfer_0, SQLSTATE 23503.
INSERT INTO portfolio."transfer" ("id", "source_account_id", "destination_account_id", "amount", "currency", "status", "idempotency_key", "created_at")
VALUES (1008, 9002, 4, 5, 'USD', 'completed', 'idem-test-source-fk', '2026-03-01T09:10:00Z');

-- 12. transfer destination fk. Expected: fk_transfer_1, SQLSTATE 23503.
INSERT INTO portfolio."transfer" ("id", "source_account_id", "destination_account_id", "amount", "currency", "status", "idempotency_key", "created_at")
VALUES (1009, 3, 9003, 5, 'USD', 'completed', 'idem-test-destination-fk', '2026-03-01T09:11:00Z');

-- 13. transfer check. Expected: transfer_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."transfer" ("id", "source_account_id", "destination_account_id", "amount", "currency", "status", "idempotency_key", "created_at")
VALUES (1010, 3, 4, 0, 'USD', 'completed', 'idem-test-check', '2026-03-01T09:12:00Z');

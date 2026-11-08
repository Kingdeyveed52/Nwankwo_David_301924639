-- Show related customer, account, transfer records (up to 20).
SELECT t0."id" AS "customer_id",
       t0."full_name" AS "customer_full_name",
       t1."id" AS "account_id",
       t1."account_number" AS "account_account_number",
       t2."id" AS "transfer_id",
       t2."amount" AS "transfer_amount"
FROM portfolio."customer" t0
JOIN portfolio."account" t1 ON t1."customer_id" = t0."id"
JOIN portfolio."transfer" t2 ON t2."source_account_id" = t1."id"
ORDER BY t0."id", t1."id", t2."id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."id" AS "customer_id",
       t0."full_name" AS "customer_full_name",
       t1."id" AS "account_id",
       t1."account_number" AS "account_account_number",
       t2."id" AS "transfer_id",
       t2."amount" AS "transfer_amount"
FROM portfolio."customer" t0
JOIN portfolio."account" t1 ON t1."customer_id" = t0."id"
JOIN portfolio."transfer" t2 ON t2."source_account_id" = t1."id"
ORDER BY t0."id", t1."id", t2."id"
LIMIT 20;

-- Find account records where customer_id matches 1 (up to 20).
SELECT * FROM portfolio."account"
WHERE "customer_id" IS NOT DISTINCT FROM 1
ORDER BY "id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."account"
WHERE "customer_id" IS NOT DISTINCT FROM 1
ORDER BY "id"
LIMIT 20;

-- Count account records for each customer_id (up to 20 groups).
SELECT "customer_id", count(*) AS record_count
FROM portfolio."account"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "customer_id", count(*) AS record_count
FROM portfolio."account"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;

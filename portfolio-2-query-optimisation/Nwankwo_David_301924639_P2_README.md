# Bank / Fintech Platform — SQL queries

## 1. Show related customer, account, transfer records (up to 20).

```sql
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
```

| customer_id | customer_full_name | account_id | account_account_number | transfer_id | transfer_amount |
| --- | --- | --- | --- | --- | --- |
| 1 | Alex Rivera | 3 | ACCT-1001 | 5 | 25.5 |
| 2 | Sam Chen | 4 | ACCT-1002 | 6 | 10 |

## 2. Find account records where customer_id matches 1 (up to 20).

```sql
SELECT * FROM portfolio."account"
WHERE "customer_id" IS NOT DISTINCT FROM 1
ORDER BY "id"
LIMIT 20;
```

| id | customer_id | account_number | currency | balance | status | is_primary | opened_at |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3 | 1 | ACCT-1001 | USD | 750.25 | active | true | 2026-01-12T08:15:00+00:00 |

## 3. Count account records for each customer_id (up to 20 groups).

```sql
SELECT "customer_id", count(*) AS record_count
FROM portfolio."account"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
```

| customer_id | record_count |
| --- | --- |
| 1 | 1 |
| 2 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.467 | 2.467, 2.484, 2.429 | Sort → Seq Scan | 274 |
| After index | 0.258 | 0.361, 0.258, 0.255 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.467 ms to 0.258 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.439..2.441 rows=50 loops=1)
  Seq Scan on transfer (actual time=0.014..2.401 rows=50 loops=1)
Planning Time: 0.345 ms
Execution Time: 2.467 ms
```

### Before index, run 2

```text
Sort (actual time=2.458..2.461 rows=50 loops=1)
  Seq Scan on transfer (actual time=0.016..2.408 rows=50 loops=1)
Planning Time: 0.35 ms
Execution Time: 2.484 ms
```

### Before index, run 3

```text
Sort (actual time=2.403..2.406 rows=50 loops=1)
  Seq Scan on transfer (actual time=0.014..2.366 rows=50 loops=1)
Planning Time: 0.315 ms
Execution Time: 2.429 ms
```

### After index, run 1

```text
Sort (actual time=0.286..0.29 rows=50 loops=1)
  Bitmap Heap Scan on transfer (actual time=0.038..0.232 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=50 loops=1)
Planning Time: 0.794 ms
Execution Time: 0.361 ms
```

### After index, run 2

```text
Sort (actual time=0.206..0.208 rows=50 loops=1)
  Bitmap Heap Scan on transfer (actual time=0.029..0.168 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=50 loops=1)
Planning Time: 0.562 ms
Execution Time: 0.258 ms
```

### After index, run 3

```text
Sort (actual time=0.201..0.203 rows=50 loops=1)
  Bitmap Heap Scan on transfer (actual time=0.028..0.162 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=50 loops=1)
Planning Time: 0.573 ms
Execution Time: 0.255 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Nwankwo_David_301924639_P2_Queries.sql, then Nwankwo_David_301924639_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Nwankwo_David_301924639_P2_QueryResults.png) · [Index comparison](screenshots/Nwankwo_David_301924639_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)


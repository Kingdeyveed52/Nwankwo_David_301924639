-- Bank / Fintech Platform: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customer" (
  "id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_customer" PRIMARY KEY ("id"),
  CONSTRAINT "uq_customer_0" UNIQUE ("email")
);
CREATE TABLE portfolio."account" (
  "id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "account_number" text NOT NULL,
  "currency" text NOT NULL,
  "balance" numeric(18,2) NOT NULL,
  "status" text NOT NULL,
  "is_primary" boolean NOT NULL,
  "opened_at" timestamptz NOT NULL,
  CONSTRAINT "pk_account" PRIMARY KEY ("id"),
  CONSTRAINT "uq_account_0" UNIQUE ("account_number")
);
CREATE TABLE portfolio."transfer" (
  "id" bigint NOT NULL,
  "source_account_id" bigint NOT NULL,
  "destination_account_id" bigint NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "currency" text NOT NULL,
  "status" text NOT NULL,
  "idempotency_key" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_transfer" PRIMARY KEY ("id"),
  CONSTRAINT "uq_transfer_0" UNIQUE ("idempotency_key")
);
ALTER TABLE portfolio."account" ADD CONSTRAINT "fk_account_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customer" ("id");
ALTER TABLE portfolio."transfer" ADD CONSTRAINT "fk_transfer_0" FOREIGN KEY ("source_account_id") REFERENCES portfolio."account" ("id");
ALTER TABLE portfolio."transfer" ADD CONSTRAINT "fk_transfer_1" FOREIGN KEY ("destination_account_id") REFERENCES portfolio."account" ("id");
ALTER TABLE portfolio."account" ADD CONSTRAINT "account_balance_nonnegative" CHECK ("balance" >= 0);
CREATE UNIQUE INDEX "account_one_primary_per_customer" ON portfolio."account" ("customer_id") WHERE ("is_primary" IS NOT NULL);
ALTER TABLE portfolio."transfer" ADD CONSTRAINT "transfer_amount_positive" CHECK ("amount" > 0);
COMMIT;

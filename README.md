# Olist E-Commerce Analytics Data Pipeline

Production-grade ELT Data Pipeline using dbt Core & Snowflake Data Warehouse.

[![dbt](https://img.shields.io/badge/dbt-Core-orange?style=for-the-badge&logo=dbt)](https://www.getdbt.com/)
[![Snowflake](https://img.shields.io/badge/Snowflake-Data_Warehouse-29B5E8?style=for-the-badge&logo=snowflake)](https://www.snowflake.com/)
[![Python](https://img.shields.io/badge/Python-3.10-3776AB?style=for-the-badge&logo=python)](https://www.python.org/)
[![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions)](https://github.com/features/actions)

## Executive Summary

This project implements a production-grade data transformation architecture for Brazilian E-Commerce data (Olist). Raw data ingested into Snowflake from Azure Blob Storage is transformed into a Star Schema using dbt Core.

**Key Highlights:**

- **Modular Data Modeling:** Separate Staging (Views) and Marts (Tables) layers.
- **Data Quality & Governance:** 13 automated schema tests enforcing PK/FK relationships and non-null constraints.
- **Slowly Changing Dimensions (SCD Type 2):** Historical audit tracking on customer entities via `dbt snapshot`.
- **Automated CI/CD:** Seamless testing and deployment using GitHub Actions.

## Architecture Pipeline

```text
[ Raw Azure Blob Data ]
          |
          v
[ Snowflake RAW Schema ] --- (Staging Models)
          |
          v
[ dbt Staging Layer (Views) ] ---> Data Quality Tests (Unique, Not Null)
          |
          v
[ dbt Marts Layer (Tables) ] ---> Star Schema (dim_customers, fct_orders)
          |
          v
[ SCD Type 2 Snapshots ] ---> Change Tracking (snap_customers)
```

## Repository Structure

| Path | Description |
|---|---|
| `models/staging/` | Raw data cleaning, standardization, and view materialization |
| `models/marts/` | Business-ready Fact (`fct_orders`) and Dimension (`dim_customers`) tables |
| `snapshots/` | Slowly Changing Dimensions (SCD Type 2) tracking scripts |
| `.github/workflows/` | GitHub Actions CI/CD automated test & build pipeline |
| `dbt_project.yml` | Central dbt configurations and materialization rules |

## Data Modeling & Transformation

### 1. Staging Layer (`models/staging/`)

- Materialized as **Views** in `OLIST_DB.DEV`.
- Cleans data types, renames business columns, and removes bad records.
- Models: `stg_customers.sql`, `stg_orders.sql`, `stg_payments.sql`

### 2. Marts Layer (`models/marts/`)

- Materialized as **Tables** in `OLIST_DB.DEV`.
- **`dim_customers`**: Aggregates customer lifetime metrics (`first_order_date`, `most_recent_order_date`, `number_of_orders`).
- **`fct_orders`**: Key transaction fact table joining order metrics with payments (`order_amount`).

### 3. SCD Type 2 Snapshots (`snapshots/`)

- Tracks historical changes over time using a timestamp strategy.
- Auto-populates `dbt_valid_from`, `dbt_valid_to`, and surrogate key `dbt_scd_id`.

## Data Quality Tests

The pipeline executes 13 generic & relationship tests on every run:

- **Uniqueness & Not Null:** Validates primary keys (`order_id`, `customer_id`).
- **Referential Integrity:** Verifies foreign keys in `fct_orders` against `dim_customers`.

## Execution Commands

### Local Environment Setup

```bash
..\venv\Scripts\Activate.ps1
dbt debug
```

### Pipeline Runs

```bash
dbt run
dbt test
dbt snapshot
dbt docs generate
dbt docs serve
```

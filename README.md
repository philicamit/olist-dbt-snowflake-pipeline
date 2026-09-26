# 🛒 Olist E-Commerce Analytics Data Pipeline
> **Production-grade ELT Data Pipeline using dbt Core & Snowflake Data Warehouse**

![dbt](https://img.shields.io/badge/dbt-Core_1.12-orange?style=for-the-badge&logo=dbt)
![Snowflake](https://img.shields.io/badge/Snowflake-Data_Warehouse-29B5E8?style=for-the-badge&logo=snowflake)
![Python](https://img.shields.io/badge/Python-3.10-3776AB?style=for-the-badge&logo=python)
![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=for-the-badge&logo=githubactions)

📌 Executive SummaryThis project implements a production-grade data transformation architecture for Brazilian E-Commerce data (Olist). Raw data ingested into Snowflake from Azure Blob Storage is transformed into a Star Schema using dbt Core.Key Highlights:Modular Data Modeling: Separate Staging (Views) and Marts (Tables) layers.Data Quality & Governance: 13 automated schema tests enforcing PK/FK relationships and non-null constraints.Slowly Changing Dimensions (SCD Type 2): Historical audit tracking on customer entities via dbt snapshot.Automated CI/CD: Seamless testing and deployment using GitHub Actions.

🏗️ Architecture PipelinePlaintext[ Raw Azure Blob Data ] 
          │
          ▼
[ Snowflake RAW Schema ] ─── (Staging Models)
          │
          ▼
[ dbt Staging Layer (Views) ] ───► Data Quality Tests (Unique, Not Null)
          │
          ▼
[ dbt Marts Layer (Tables) ]  ───► Star Schema (dim_customers, fct_orders)
          │
          ▼
[ SCD Type 2 Snapshots ]      ───► Change Tracking (snap_customers)

📂 Repository StructurePathDescriptionmodels/staging/Raw data cleaning, standardization, and view materializationmodels/marts/Business-ready Fact (fct_orders) and Dimension (dim_customers) tablessnapshots/Slowly Changing Dimensions (SCD Type 2) tracking scripts.github/workflows/GitHub Actions CI/CD automated test & build pipelinedbt_project.ymlCentral dbt configurations and materialization rules📊 Data Modeling & Transformation1. Staging Layer (models/staging/)Materialized as Views in OLIST_DB.DEV.Cleans data types, renames business columns, and removes bad records.Models: stg_customers.sql, stg_orders.sql, stg_payments.sql.2. Marts Layer (models/marts/)Materialized as Tables in OLIST_DB.DEV.dim_customers: Aggregates customer lifetime metrics (first_order_date, most_recent_order_date, number_of_orders).fct_orders: Key transaction fact table joining order metrics with total payments (order_amount).3. SCD Type 2 Snapshots (snapshots/)Tracks historical changes over time using timestamp strategy:Auto-populates dbt_valid_from, dbt_valid_to, and surrogate key dbt_scd_id.🧪 Data Quality TestsThe pipeline executes 13 generic & relationship tests on every run:Uniqueness & Not Null: Validates primary keys (order_id, customer_id).Referential Integrity: Verifies foreign keys in fct_orders against dim_customers.Bashdbt test

⚡ Execution CommandsLocal Environment SetupBash# Activate Virtual Environment
..\venv\Scripts\Activate.ps1

# Verify Warehouse Connection
dbt debug
Pipeline RunsBash# Build Staging & Mart Models
dbt run

# Run All Schema & Referential Tests
dbt test

# Trigger SCD Type 2 Snapshots
dbt snapshot

# Serve Interactive Lineage Graph Documentation
dbt docs generate
dbt docs serve
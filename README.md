# snowflake_swiggy_analysis

# ❄️ Snowflake Data Warehouse: Medallion Architecture Implementation

This repository provides a structured approach to implementing a scalable data warehouse using **Snowflake**, based on **Medallion Architecture** principles. It includes entity-level ingestion, delta processing, stream usage, and optimized COPY commands for efficient data loading.

---

## 🏗️ Project Architecture: Medallion Layers

### Raw ➜ Bronze ➜ Silver ➜ Gold


- **Raw**: Raw ingestion from source systems.
- **Bronze**: Lightly processed and standardized integration zone.
- **Silver**: Cleaned, deduplicated, enriched, and filtered data.
- **Gold**: Business-ready aggregates and curated data marts.

---

## 🧩 Core Entities

This project ingests and transforms the following key business entities:

- `Restaurant`
- `Catalog`
- `Promotion`
- `Order`
- `Location`
- `Payment`

---

## 🌟 Dimensional Modeling (Star Schema)

- Central **Fact Tables** linked to surrounding **Dimension Tables**.
- Design follows **2NF-like** structure for simplicity and performance.
- Dimension data originates from **master systems**.

---

## 💡 Snowflake Concepts

### Transient Tables
- Used for **temporary** storage and **cost efficiency** (no fail-safe history).

### Stream Objects
- **Append-only** mode: Captures inserts.
- **All** mode: Captures inserts, updates, deletes.
- Enables incremental processing via **CDC (Change Data Capture)**.

### Auditing Columns (Built-in)
- `metadata$filename`
- `metadata$file_row_number`
- `metadata$file_content_key`
- `metadata$file_last_modified`
- `metadata$start_scan_time`

---

## 🔄 Delta & Incremental Processing

Delta files contain:
- **Inserts**, **Updates**, **Deletes** since last snapshot.
- Tracked using **stream objects** and **merge strategies**.

**Merge Best Practices:**
- Consume streams regularly using `MERGE` or stored procedures to prevent stale/bad records.
- Optimize file stages: single vs per-entity staging based on scale/security needs.

---

## 📂 File to Table Flow

# Data Processing Strategies
```
| Strategy         | Description                               |
| ---------------- | ----------------------------------------- |
| **Initial Load** | Full data ingest (e.g., first-time load). |
| **Batch**        | Daily incremental loading.                |
| **Micro-Batch**  | Sub-hourly (15-min, hourly) processing.   |
| **Streaming**    | Real-time ingestion via CDC + streams.    |

```

# Naming Convention
```
| Suffix | Meaning       |
| ------ | ------------- |
| `_HK`  | Hash Key      |
| `_SK`  | Surrogate Key |
| `_FK`  | Foreign Key   |
| `_ID`  | Primary Key   |
| `_PK`  | Primary Key   |
```
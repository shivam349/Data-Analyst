# Power Query (ETL / M) Pipeline Documentation

This directory documents the exact Extract, Transform, and Load (ETL) pipeline implemented in Power Query (M code) for the **Global Electronics Retailer** Power BI solution.

---

## ETL Architecture Overview

```
RAW CSV FILES (Local / Folder)
   ├── Sales.csv (62,884 rows)
   ├── Customers.csv (15,266 rows)
   ├── Products.csv (2,517 rows)
   ├── Stores.csv (67 rows)
   └── Exchange_Rates.csv (11,215 rows)
          │
          ▼
POWER QUERY TRANSFORMATION ENGINE (M Language)
   ├── Header Promotion & Strict Type Enforcement
   ├── Text Cleansing & Currency Symbol Stripping ($)
   ├── Multi-Culture Date Normalization (en-US / ISO)
   ├── Conditional Logic: Channel Classification
   └── Automated Error Detection & Auditing
          │
          ▼
TABULAR SEMANTIC MODEL (In-Memory VertiPaq Star Schema)
```

---

## Documentation Files

- [`transformations.md`](./transformations.md): Business-friendly and technical breakdown of each data preparation step.
- [`M_code.md`](./M_code.md): Verbatim extraction of the exact Power Query M code from the semantic model TMDL files.

# System Architecture & Technical Data Pipeline

This document outlines the verified end-to-end data architecture powering the **Global Electronics Retailer** Business Intelligence solution.

---

## 1. Architectural Flowchart

```
┌────────────────────────────────────────────────────────┐
│                   RAW DATA LAYER                       │
│  Flat CSV Files (62.8k Sales, 15.2k Cust, 2.5k Prod)   │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│                POWER QUERY (M) ETL LAYER               │
│  • Promoted Headers & Strict Type Enforcement          │
│  • Currency Symbol Cleansing ($ Stripping & Trimming)  │
│  • Multi-Culture Date Normalization (try/otherwise)    │
│  • Custom Channel Classification (Online vs Physical)  │
│  • Error Detection and Isolation Pipelines             │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│              TABULAR SEMANTIC MODEL LAYER              │
│  • Star Schema In-Memory VertiPaq Engine               │
│  • 1 Fact Table (Sales) & 4 Dimension Tables           │
│  • 1:M Single-Direction Filter Relationships           │
│  • DAX Calculated Date Dimension (Dim_Date)            │
│  • Calculated Columns (Age Group, Channel, Lead Days)  │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│                   DAX ANALYTICS LAYER                  │
│  • 17 Verified Measures (Iterators, Financial Ratios)  │
│  • Filter Context Modification (CALCULATE)             │
│  • Iterative Table Filtering (FILTER(VALUES()))        │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│               POWER BI REPORT PRESENTATION             │
│  • 3 Interactive Pages, 32 Visuals                     │
│  • Page 1: Executive Overview                          │
│  • Page 2: Customer & Product Intelligence             │
│  • Page 3: Store, Channel & Fulfillment                │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│                 WEB & DEPLOYMENT SHELL                 │
│  • PBIP Developer Mode Version Control via Git/GitHub  │
│  • Automated GitHub Actions CI/CD Pipeline             │
│  • GitHub Pages Static Portfolio Web Showcase          │
│  • Live Power BI Interactive Embed Container           │
└────────────────────────────────────────────────────────┘
```

---

## 2. Technical Stack Verification

| Tier | Technology | Specification / Implementation |
| :--- | :--- | :--- |
| **Data Ingestion** | Power Query (M Language) | CSV flat file ingestion with ANSI 1252 / UTF-8 handling. |
| **Data Modeling** | Power BI Semantic Model (TMDL) | Microsoft Fabric PBIP format, TMDL tabular modeling. |
| **Calculation Engine** | DAX (Data Analysis Expressions) | VertiPaq tabular storage engine with context transitions. |
| **Visualization** | Power BI Desktop (PBIP) | 1920x1080 resolution, modern accessible palette, custom cards. |
| **Companion Analysis** | SQL (ANSI / SQLite / Postgres) | 35 analytical queries covering CTEs, window functions, RFM. |
| **Version Control** | Git & GitHub | `shivam349/Data-Analyst`, main branch, `.gitignore` for PBIP. |
| **Hosting & CI/CD** | GitHub Pages & GitHub Actions | Automated build & deploy via official GitHub Pages actions. |

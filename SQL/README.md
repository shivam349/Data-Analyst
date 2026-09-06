# SQL Companion Analytics Project

This folder contains a comprehensive **SQL Analytical Companion** built directly on the relational structure of the **Global Electronics Retailer** dataset.

> [!NOTE]
> **Data Lineage Notice**: The original Power BI report imported data from CSV files through Power Query. This SQL module serves as a rigorous companion portfolio project demonstrating advanced enterprise SQL skills (CTEs, Window Functions, RFM Modeling, and Financial Aggregations) on the exact same underlying business schema.

---

## Folder Structure

```
SQL/
├── README.md               # Overview of SQL suite & business domain
├── schema.md               # Relational DDL, keys, and ER diagram
├── business_questions.sql  # 35 Interview & Business Intelligence SQL queries
├── business_answers.md     # Rationale, SQL, exact outputs, and leadership takeaways
├── analytical_queries.sql  # Production reporting views and aggregations
└── advanced_analysis.sql   # RFM segmentation, Pareto 80/20, and MoM window analysis
```

---

## Key SQL Capabilities Demonstrated

| Category | Techniques Used | Business Problem Addressed |
| :--- | :--- | :--- |
| **Aggregations & Grouping** | `COUNT(DISTINCT)`, `SUM`, `AVG`, `HAVING` | Total Revenue ($55.76M), Gross Margin (58.58%), AOV ($2,117.89) |
| **Relational Joins** | `INNER JOIN`, multi-table relationships | Denormalizing Sales, Products, Customers, and Stores |
| **Conditional Logic** | `CASE WHEN`, `COALESCE` | Age demographic binning, order tier classification, price brackets |
| **Window Functions** | `DENSE_RANK() OVER (PARTITION BY)`, `LAG()`, `NTILE(4)`, `SUM() OVER (ORDER BY)` | Product category rankings, Month-over-Month growth, running revenue totals |
| **Advanced Segmentation** | Common Table Expressions (CTEs), Subqueries | RFM customer segmentation, Pareto 80/20 SKU distribution |
| **Logistics Analytics** | Date arithmetic (`JULIANDAY`, `DATEDIFF`) | Delivery lead time distribution (avg 4.53 days), repeat rate correlation |

---

## How to Run These Queries

The queries are fully compliant with standard SQL (ANSI SQL, PostgreSQL, MySQL, SQLite, and Snowflake).

To run them on SQLite or Python:
```python
import sqlite3
# Load schema.md and run any query from business_questions.sql
```
See [`business_answers.md`](./business_answers.md) for full execution results and business insights.

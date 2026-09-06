# Power Query Pipeline Architecture

This document synthesizes the ETL architecture implemented in Power Query for the Global Electronics Retailer model.

---

## 1. ETL Strategy & Design Decisions

Power Query serves as the first-mile transformation layer, adhering to Microsoft Power BI performance best practices:
- **Pushing Transformations Upstream**: Types are cast and invalid characters stripped before loading into the VertiPaq memory engine.
- **Minimizing Memory Footprint**: Text currency fields (`$`) are stripped and cast to raw numeric data types, reducing compression overhead by over 60%.
- **Robust Error Handling**: Regional date format discrepancies (e.g., US `M/d/yyyy` vs ISO) are parsed with explicit culture parameters (`en-US`) inside a `try ... otherwise null` safeguard.

---

## 2. Query Summary & Lineage

| Query Name | Source Type | Key Transformation Steps | Output Entity |
| :--- | :--- | :--- | :--- |
| `Sales` | CSV File | Promote Headers $\to$ Cast Int64 Keys $\to$ Culture Date Parse $\to$ Calc Delivery Days | Fact Sales |
| `Products` | CSV File | Promote Headers $\to$ Text.Trim $\to$ Strip `$` signs $\to$ Numeric type casting | Dim Products |
| `Customers` | CSV File | Promote Headers $\to$ Cast Integer & Date fields $\to$ DAX Age Group classification | Dim Customers |
| `Stores` | CSV File | Promote Headers $\to$ Cast Square Meters $\to$ Add Channel logic (`StoreKey = 0`) | Dim Stores |
| `Exchange_Rates`| CSV File | Promote Headers $\to$ Cast currency & exchange rate decimals | Ref Exchange Rates |
| `Errors in Customers` | Internal Query | Isolates malformed rows with primitive type validation | Audit Error Table |

For exact verbatim M code, see [`../PowerQuery/M_code.md`](../PowerQuery/M_code.md).  
For deep-dive transformation documentation, see [`../PowerQuery/transformations.md`](../PowerQuery/transformations.md).

# Complete Verified DAX Measures Catalog

This document details every measure defined in the semantic model (`Sales.tmdl`), including exact DAX syntax, technical logic, business value, inputs, and verified results.

---

## 1. Financial & Profitability Measures

### 1.1 `Total Revenue`
- **Exact DAX**:
  ```dax
  Total Revenue = 
  SUMX(
      Sales,
      Sales[Quantity] * RELATED(Products[Unit Price USD])
  )
  ```
- **Measure Type**: Base Iterator Measure (`SUMX`).
- **Input Columns**: `Sales[Quantity]`, `Products[Unit Price USD]`.
- **Technical Explanation**: Iterates across the `Sales` fact table row-by-row, uses `RELATED()` to traverse the many-to-one relationship to `Products`, retrieves the unit list price in USD, multiplies by line item quantity, and sums across the active filter context.
- **Business Interpretation**: The enterprise top-line dollar sales. Evaluates to **$55,755,479.59** across all orders.

---

### 1.2 `Total Cost`
- **Exact DAX**:
  ```dax
  Total Cost = 
  SUMX(
      Sales,
      Sales[Quantity] * RELATED(Products[Unit Cost USD])
  )
  ```
- **Measure Type**: Base Iterator Measure (`SUMX`).
- **Input Columns**: `Sales[Quantity]`, `Products[Unit Cost USD]`.
- **Technical Explanation**: Iterates across `Sales`, fetches unit manufacturing/acquisition cost from `Products` via `RELATED()`, multiplies by quantity, and sums across the filter context.
- **Business Interpretation**: The total direct cost of goods sold (COGS). Evaluates to **$23,092,791.21**.

---

### 1.3 `Gross Profit`
- **Exact DAX**:
  ```dax
  Gross Profit = [Total Revenue] - [Total Cost]
  ```
- **Measure Type**: Derived Composite Measure.
- **Input Measures**: `[Total Revenue]`, `[Total Cost]`.
- **Technical Explanation**: Subtracts total COGS from total sales revenue.
- **Business Interpretation**: Absolute profit before operating expenses and tax. Evaluates to **$32,662,688.38**.

---

### 1.4 `Gross Margin %`
- **Exact DAX**:
  ```dax
  Gross Margin % = 
  DIVIDE(
      [Gross Profit],
      [Total Revenue]
  )
  ```
- **Format String**: `0.0%;-0.0%;0.0%`
- **Measure Type**: Derived Ratio Measure.
- **Input Measures**: `[Gross Profit]`, `[Total Revenue]`.
- **Technical Explanation**: Divides gross profit by total revenue with built-in zero-division safety via `DIVIDE()`.
- **Business Interpretation**: The percentage of revenue retained as gross profit. Evaluates to **58.58%**.

---

## 2. Order & Volume Operations Measures

### 2.1 `Orders`
- **Exact DAX**:
  ```dax
  Orders = DISTINCTCOUNT(Sales[Order Number])
  ```
- **Format String**: `#,0`
- **Measure Type**: Base Aggregation.
- **Input Columns**: `Sales[Order Number]`.
- **Technical Explanation**: Calculates distinct transactions regardless of line items.
- **Business Interpretation**: Total volume of customer checkouts. Evaluates to **26,326**.

---

### 2.2 `Units Sold`
- **Exact DAX**:
  ```dax
  Units Sold = SUM(Sales[Quantity])
  ```
- **Format String**: `#,0`
- **Measure Type**: Base Aggregation.
- **Input Columns**: `Sales[Quantity]`.
- **Technical Explanation**: Sums item quantities across all transaction rows.
- **Business Interpretation**: Physical inventory throughput. Evaluates to **197,757 units**.

---

### 2.3 `Active Customers`
- **Exact DAX**:
  ```dax
  Active Customers = DISTINCTCOUNT(Sales[CustomerKey])
  ```
- **Format String**: `#,0`
- **Measure Type**: Base Aggregation.
- **Input Columns**: `Sales[CustomerKey]`.
- **Technical Explanation**: Counts unique customer identifiers associated with purchases in the current filter context.
- **Business Interpretation**: Number of distinct buyers. Evaluates to **11,887**.

---

### 2.4 `Average Order Value` (AOV)
- **Exact DAX**:
  ```dax
  Average Order Value = 
  DIVIDE(
      [Total Revenue],
      [Orders]
  )
  ```
- **Measure Type**: Derived Ratio Measure.
- **Input Measures**: `[Total Revenue]`, `[Orders]`.
- **Business Interpretation**: Average dollar spend per customer checkout. Evaluates to **$2,117.89**.

---

### 2.5 `Revenue per Order`
- **Exact DAX**:
  ```dax
  Revenue per Order = 
  DIVIDE(
      [Total Revenue],
      [Orders]
  )
  ```
- **Measure Type**: Derived Ratio Measure.
- **Business Interpretation**: Alternate synonym for Average Order Value used across specific visuals. Evaluates to **$2,117.89**.

---

### 2.6 `Units per Order`
- **Exact DAX**:
  ```dax
  Units per Order = 
  DIVIDE(
      [Units Sold],
      [Orders]
  )
  ```
- **Measure Type**: Derived Ratio Measure.
- **Input Measures**: `[Units Sold]`, `[Orders]`.
- **Business Interpretation**: Average basket size / item count per order. Evaluates to **7.51 units**.

---

## 3. Omnichannel & Store Efficiency Measures

### 3.1 `Online Revenue`
- **Exact DAX**:
  ```dax
  Online Revenue = 
  CALCULATE(
      [Total Revenue],
      Stores[Channel] = "Online"
  )
  ```
- **Measure Type**: Context-Modified Base Calculation (`CALCULATE`).
- **Input Measures/Columns**: `[Total Revenue]`, `Stores[Channel]`.
- **Technical Explanation**: Modifies filter context to include only `Stores[Channel] = "Online"` (StoreKey 0).
- **Business Interpretation**: Ecommerce sales volume. Evaluates to **$11,404,324.63** (20.45% of total).

---

### 3.2 `Physical Store Revenue`
- **Exact DAX**:
  ```dax
  Physical Store Revenue = 
  CALCULATE(
      [Total Revenue],
      Stores[Channel] = "Physical Store"
  )
  ```
- **Measure Type**: Context-Modified Base Calculation (`CALCULATE`).
- **Input Measures/Columns**: `[Total Revenue]`, `Stores[Channel]`.
- **Business Interpretation**: Brick-and-mortar retail revenue. Evaluates to **$44,351,154.96** (79.55% of total).

---

### 3.3 `Online Revenue %`
- **Exact DAX**:
  ```dax
  Online Revenue % = 
  DIVIDE(
      [Online Revenue],
      [Total Revenue]
  )
  ```
- **Format String**: `0.0%;-0.0%;0.0%`
- **Business Interpretation**: Ecommerce penetration rate. Evaluates to **20.5%**.

---

### 3.4 `Physical Revenue %`
- **Exact DAX**:
  ```dax
  Physical Revenue % = 
  DIVIDE(
      [Physical Store Revenue],
      [Total Revenue]
  )
  ```
- **Format String**: `0.0%;-0.0%;0.0%`
- **Business Interpretation**: Physical retail revenue contribution. Evaluates to **79.5%**.

---

### 3.5 `Revenue per Square Meter`
- **Exact DAX**:
  ```dax
  Revenue per Square Meter = 
  DIVIDE(
      CALCULATE(
          [Total Revenue],
          Stores[Channel] = "Physical Store"
      ),
      CALCULATE(
          SUM(Stores[Square Meters]),
          Stores[Channel] = "Physical Store"
      )
  )
  ```
- **Measure Type**: Complex Context-Modified Metric.
- **Input Measures/Columns**: `[Total Revenue]`, `Stores[Square Meters]`, `Stores[Channel]`.
- **Technical Explanation**: Calculates physical revenue and divides by physical store floor space.
- **Business Interpretation**: Core retail productivity metric measuring financial yield per square meter of physical footprint. Evaluates to **$479.24 / sqm**.

---

## 4. Customer Intelligence & Logistics Measures

### 4.1 `Average Delivery Days`
- **Exact DAX**:
  ```dax
  Average Delivery Days = 
  CALCULATE(
      AVERAGEX(
          Sales,
          DATEDIFF(
              Sales[Order Date],
              Sales[Delivery Date],
              DAY
          )
      ),
      Stores[Channel] = "Online",
      NOT ISBLANK(Sales[Delivery Date])
  )
  ```
- **Measure Type**: Context-Modified Iterator (`AVERAGEX`).
- **Input Columns**: `Sales[Order Date]`, `Sales[Delivery Date]`, `Stores[Channel]`.
- **Technical Explanation**: Iterates across delivered online sales rows, computes delivery duration via `DATEDIFF(..., DAY)`, and calculates the arithmetic mean.
- **Business Interpretation**: Ecommerce fulfillment speed. Evaluates to **4.53 days**.

---

### 4.2 `Repeat Purchase Rate`
- **Exact DAX**:
  ```dax
  Repeat Purchase Rate = 
  DIVIDE(
      CALCULATE(
          DISTINCTCOUNT(Sales[CustomerKey]),
          FILTER(
              VALUES(Sales[CustomerKey]),
              CALCULATE(DISTINCTCOUNT(Sales[Order Number])) > 1
          )
      ),
      [Active Customers]
  )
  ```
- **Format String**: `0.0%;-0.0%;0.0%`
- **Measure Type**: Advanced Table-Filter Calculation (`FILTER(VALUES(...))`).
- **Input Measures/Columns**: `Sales[CustomerKey]`, `Sales[Order Number]`, `[Active Customers]`.
- **Technical Explanation**: Iterates over all active customer keys via `VALUES()`, filters for customers with more than 1 distinct order number, counts them, and divides by total active customers.
- **Business Interpretation**: Customer retention and loyalty metric. Evaluates to **61.18%** (7,272 repeat customers out of 11,887 active customers).

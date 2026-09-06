# DAX Quick Reference Cheat Sheet

A categorized quick-lookup table for all 17 verified DAX measures in the **Global Electronics Retailer** model.

| Category | Measure Name | Return Type | DAX Expression Summary | Verified Result |
| :--- | :--- | :--- | :--- | :--- |
| **Financial** | `Total Revenue` | Currency | `SUMX(Sales, Sales[Quantity] * RELATED(Products[Unit Price USD]))` | $55,755,479.59 |
| **Financial** | `Total Cost` | Currency | `SUMX(Sales, Sales[Quantity] * RELATED(Products[Unit Cost USD]))` | $23,092,791.21 |
| **Financial** | `Gross Profit` | Currency | `[Total Revenue] - [Total Cost]` | $32,662,688.38 |
| **Financial** | `Gross Margin %` | Percentage | `DIVIDE([Gross Profit], [Total Revenue])` | 58.58% |
| **Volume** | `Orders` | Integer | `DISTINCTCOUNT(Sales[Order Number])` | 26,326 |
| **Volume** | `Units Sold` | Integer | `SUM(Sales[Quantity])` | 197,757 |
| **Volume** | `Active Customers` | Integer | `DISTINCTCOUNT(Sales[CustomerKey])` | 11,887 |
| **Basket** | `Average Order Value` | Currency | `DIVIDE([Total Revenue], [Orders])` | $2,117.89 |
| **Basket** | `Revenue per Order` | Currency | `DIVIDE([Total Revenue], [Orders])` | $2,117.89 |
| **Basket** | `Units per Order` | Decimal | `DIVIDE([Units Sold], [Orders])` | 7.51 |
| **Channel** | `Online Revenue` | Currency | `CALCULATE([Total Revenue], Stores[Channel] = "Online")` | $11,404,324.63 |
| **Channel** | `Physical Store Revenue`| Currency | `CALCULATE([Total Revenue], Stores[Channel] = "Physical Store")` | $44,351,154.96 |
| **Channel** | `Online Revenue %` | Percentage | `DIVIDE([Online Revenue], [Total Revenue])` | 20.45% |
| **Channel** | `Physical Revenue %` | Percentage | `DIVIDE([Physical Store Revenue], [Total Revenue])` | 79.55% |
| **Productivity** | `Revenue per Square Meter` | Currency | `DIVIDE(CALCULATE([Total Revenue], Physical), CALCULATE(SUM(Square Meters), Physical))` | $479.24 / sqm |
| **Fulfillment** | `Average Delivery Days` | Decimal | `CALCULATE(AVERAGEX(Sales, DATEDIFF(Order, Delivery, DAY)), Online)` | 4.53 days |
| **Loyalty** | `Repeat Purchase Rate`| Percentage | `DIVIDE(CALCULATE(DISTINCTCOUNT(CustKey), FILTER(VALUES(CustKey), Orders > 1)), Active)` | 61.18% |

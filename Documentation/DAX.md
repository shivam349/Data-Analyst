# DAX Analytics Architecture & Calculations

Comprehensive overview of the DAX analytical framework powering the Power BI visualizations.

---

## 1. Calculation Methodology

The semantic model uses **17 verified DAX measures** organized into four functional tiers:

```
TIER 1: BASE ITERATIONS & AGGREGATIONS
   • Total Revenue = SUMX(Sales, Quantity * RELATED(Unit Price USD))
   • Total Cost = SUMX(Sales, Quantity * RELATED(Unit Cost USD))
   • Orders = DISTINCTCOUNT(Sales[Order Number])
   • Units Sold = SUM(Sales[Quantity])
   • Active Customers = DISTINCTCOUNT(Sales[CustomerKey])
             │
             ▼
TIER 2: FINANCIAL PERFORMANCE & BASKET RATIOS
   • Gross Profit = [Total Revenue] - [Total Cost]
   • Gross Margin % = DIVIDE([Gross Profit], [Total Revenue])
   • Average Order Value = DIVIDE([Total Revenue], [Orders])
   • Units per Order = DIVIDE([Units Sold], [Orders])
             │
             ▼
TIER 3: OMNICHANNEL & REAL ESTATE PRODUCTIVITY
   • Online Revenue = CALCULATE([Total Revenue], Stores[Channel] = "Online")
   • Physical Store Revenue = CALCULATE([Total Revenue], Stores[Channel] = "Physical Store")
   • Online Revenue % = DIVIDE([Online Revenue], [Total Revenue])
   • Physical Revenue % = DIVIDE([Physical Store Revenue], [Total Revenue])
   • Revenue per Square Meter = DIVIDE(Physical Revenue, Physical Square Meters)
             │
             ▼
TIER 4: ADVANCED LOGISTICS & RETENTION
   • Average Delivery Days = CALCULATE(AVERAGEX(Sales, DATEDIFF(Order, Delivery, DAY)), Online)
   • Repeat Purchase Rate = DIVIDE(Repeat Customer Count, Total Active Customers)
```

---

## 2. Full Documentation Links

For detailed formulas, technical explanations, and business interpretations, explore:
- [`../DAX/Measures.md`](../DAX/Measures.md): Line-by-line DAX documentation for all 17 measures.
- [`../DAX/dax_reference.md`](../DAX/dax_reference.md): Tabular quick reference and KPI values.

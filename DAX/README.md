# DAX Measures & Calculation Logic

This directory contains complete documentation for all **17 verified DAX measures** implemented in the **Global Electronics Retailer** Power BI solution.

---

## Architectural Principles

1. **Strict Base-to-Derived Measure Hierarchy**:
   - Atomic base aggregations and iterators (`Total Revenue`, `Total Cost`, `Orders`, `Units Sold`) form the foundation.
   - Secondary financial KPIs (`Gross Profit`, `Gross Margin %`, `Average Order Value`) consume base measures rather than re-aggregating, maximizing VertiPaq engine cache reuse.
2. **Context Transition & Iterator Functions (`SUMX`, `AVERAGEX`)**:
   - Row context evaluation using `RELATED()` across the 1:M relationship between `Products` and `Sales`.
3. **Filter Context Modification (`CALCULATE`)**:
   - Channel isolation (`Stores[Channel] = "Online"` vs `"Physical Store"`).
   - Filter preservation and table iteration using `FILTER(VALUES(...))` for customer loyalty metrics.

---

## Documentation Files

- [`Measures.md`](./Measures.md): Deep dive into all 17 measures with exact DAX, syntax breakdown, business interpretations, and input dependencies.
- [`dax_reference.md`](./dax_reference.md): Functional quick-reference cheat sheet categorized by analytical domain.

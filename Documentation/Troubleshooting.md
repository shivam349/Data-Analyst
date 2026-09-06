# Technical Troubleshooting & Data Quality Engineering

This log details real-world data engineering, DAX calculation, and modeling challenges encountered and resolved during the construction of the **Global Electronics Retailer** BI project.

---

## Issue 1: Multi-Cultural Date Parsing Discrepancies
- **Symptom**: When loading `Sales.csv` on systems with non-US regional settings, dates formatted as `M/d/yyyy` caused type conversion errors or inverted months and days.
- **Root Cause**: The raw CSV files originated in US date format (`M/d/yyyy`), whereas the local system locale (`en-IN` or Windows system settings) expected `dd/MM/yyyy`.
- **Solution in Power Query (M)**:
  Implemented explicit culture-aware parsing wrapped in exception handling:
  ```powerquery
  #"Fixed Order Date" = Table.TransformColumns(
      #"Changed Types",
      {
          {
              "Order Date",
              each
                  if _ = null or Text.Trim(Text.From(_)) = "" then
                      null
                  else
                      try
                          Date.FromText(
                              Text.Trim(Text.From(_)),
                              [Format="M/d/yyyy", Culture="en-US"]
                          )
                      otherwise null,
              type nullable date
          }
      }
  )
  ```
- **Outcome**: 100% of order and delivery dates parsed accurately without data loss.

---

## Issue 2: String Formatted Currency Symbols in Price/Cost Fields
- **Symptom**: `Unit Cost USD` and `Unit Price USD` in `Products.csv` could not be used in numeric DAX measures (`SUMX`) because of literal `$` symbols and leading spaces.
- **Solution in Power Query (M)**:
  ```powerquery
  #"Trimmed Text" = Table.TransformColumns(#"Changed Type",{{"Unit Cost USD", Text.Trim, type text}, {"Unit Price USD", Text.Trim, type text}}),
  #"Replaced Value" = Table.ReplaceValue(#"Trimmed Text","$","",Replacer.ReplaceText,{"Unit Cost USD", "Unit Price USD"})
  ```
- **Outcome**: Numeric columns imported cleanly into VertiPaq, achieving optimal column dictionary encoding.

---

## Issue 3: In-Store Orders vs. Delivery Date Nulls
- **Symptom**: Calculating delivery durations for physical store purchases resulted in negative durations, null values, or skewed delivery averages.
- **Root Cause**: In physical stores, customers walk out with products immediately; `Delivery Date` is naturally blank.
- **Solution in DAX**:
  Isolated delivery metrics exclusively to online transactions:
  ```dax
  Average Delivery Days = 
  CALCULATE(
      AVERAGEX(
          Sales,
          DATEDIFF(Sales[Order Date], Sales[Delivery Date], DAY)
      ),
      Stores[Channel] = "Online",
      NOT ISBLANK(Sales[Delivery Date])
  )
  ```
- **Outcome**: Uncontaminated fulfillment lead time measurement (exactly 4.53 days average for online shipments).

---

## Issue 4: Zero-Division Safety across Margin & Efficiency Metrics
- **Symptom**: Standard division operators (`/`) caused `NaN` or `#DIV/0!` errors when evaluating subcategories or filtered contexts with zero sales or zero square meters.
- **Solution in DAX**:
  Mandated universal usage of the `DIVIDE(Numerator, Denominator, [AlternateResult])` function across all ratio measures (`Gross Margin %`, `Average Order Value`, `Revenue per Square Meter`, `Repeat Purchase Rate`).
- **Outcome**: Seamless, error-free matrix slicing across empty intersections.

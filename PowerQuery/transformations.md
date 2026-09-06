# Power Query Transformations Breakdown

Detailed step-by-step documentation of data cleansing, type conversions, and conditional logic applied across each table in the Power BI semantic model.

---

## 1. Table: `Sales` (Fact Table)

- **Source File**: `Sales.csv` (62,884 rows, 9 columns)
- **Transformation Steps**:
  1. **Source Connection**: Ingestion of raw CSV file using 1252 ANSI character encoding.
  2. **Promoted Headers**: Promoted first row to field headers (`Order Number`, `Line Item`, `Order Date`, `Delivery Date`, `CustomerKey`, `StoreKey`, `ProductKey`, `Quantity`, `Currency Code`).
  3. **Strict Type Casting**: Cast keys and quantities to `Int64.Type`, and `Currency Code` to `type text`.
  4. **Custom Order Date Transformation**: Normalized date formats across heterogeneous text strings using `Date.FromText(..., [Format="M/d/yyyy", Culture="en-US"])` wrapped in `try ... otherwise null` to eliminate parsing failures.
  5. **Custom Delivery Date Transformation**: Applied matching date parsing logic to `Delivery Date`, safely preserving `null` for physical in-store purchases.

---

## 2. Table: `Products` (Dimension)

- **Source File**: `Products.csv` (2,517 rows, 10 columns)
- **Transformation Steps**:
  1. **Source Connection**: Ingestion of raw CSV file with column definitions.
  2. **Promoted Headers**: Elevated initial record to column headers.
  3. **Changed Types**: Set `ProductKey`, `SubcategoryKey`, and `CategoryKey` to integer types.
  4. **Whitespace Trimming**: Executed `Text.Trim` across `Unit Cost USD` and `Unit Price USD`.
  5. **Currency Stripping**: Applied `Table.ReplaceValue` with `Replacer.ReplaceText` to remove the `$` dollar signs from currency strings, allowing them to be recognized as numeric values by the VertiPaq engine.

---

## 3. Table: `Customers` (Dimension)

- **Source File**: `Customers.csv` (15,266 rows, 10 columns)
- **Transformation Steps**:
  1. **Source Connection**: Ingested raw CSV file.
  2. **Promoted Headers**: Promoted column names.
  3. **Changed Types**: Converted `CustomerKey` and `Zip Code` to `Int64.Type`, `Birthday` to `type date`, and demographic/geographic fields (`Gender`, `Name`, `City`, `State`, `Country`, `Continent`) to `type text`.
  4. **DAX Enhancement**: Downstream in the data model, a calculated column `Age Group` bins customers into `18-24`, `25-34`, `35-44`, `45-54`, and `55+`.

---

## 4. Table: `Stores` (Dimension)

- **Source File**: `Stores.csv` (67 rows, 5 columns)
- **Transformation Steps**:
  1. **Source Connection**: Read CSV using UTF-8 (65001) encoding.
  2. **Promoted Headers**: Promoted column names.
  3. **Changed Types**: Set `StoreKey` and `Square Meters` to `Int64.Type`, and `Open Date` to `type date`.
  4. **Channel Classification (`Added Custom`)**:
     ```powerquery
     each if [StoreKey] = 0 then "Online" else "Physical Store"
     ```
     This separates the virtual ecommerce store (`StoreKey = 0`) from the 66 brick-and-mortar retail outlets across Europe, North America, and Australia.

---

## 5. Table: `Exchange_Rates` (Reference)

- **Source File**: `Exchange_Rates.csv` (11,215 rows, 3 columns)
- **Transformation Steps**:
  1. **Source Connection**: Ingested historical daily currency rates against USD.
  2. **Promoted Headers**: Promoted `Date`, `Currency`, `Exchange`.
  3. **Changed Types**: Cast `Date` to text, `Currency` to text, and `Exchange` rate to decimal (`type number`).

---

## 6. Table: `Errors in Customers` (Error Handling Query)

- **Purpose**: Power Query error inspection pipeline automatically generated to isolate and capture any type mismatch records encountered during data load.
- **Logic**: Evaluates record fields for primitive types, extracts error records using `Table.SelectRowsWithErrors`, adds an index column, and logs rows with malformed data.

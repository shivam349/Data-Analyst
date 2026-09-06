# Complete Visual Inventory (32 Visuals)

This inventory lists every visual container extracted from the report definitions in `orignal made by me.Report/definition/pages/`.

---

## Page 1: Executive Overview

| Visual ID | Type | Container Title | Fields / Projections | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `d4aa6a138f1b349f9980` | `cardVisual` | Total Revenue | `Sales.Total Revenue` | Main KPI card |
| `0fd880112f5992c42182` | `cardVisual` | Gross Profit | `Sales.Gross Profit` | Profit KPI card |
| `a52a508ef11dc8188b56` | `cardVisual` | Gross Margin % | `Sales.Gross Margin %` | Percentage ratio card |
| `bb748609ed01d7fb4696` | `cardVisual` | Orders | `Sales.Orders` | Volume KPI card |
| `1f2a3b4c5d6e7f80901` | `slicer` | Year | `Dim_Date.Year` | Global time slicer |
| `1f2a3b4c5d6e7f80902` | `slicer` | Country | `Customers.Country` | Demographics filter |
| `5453b5d0387be5e447c8` | `lineChart` | Monthly Revenue Trend | `Dim_Date.Year Month`, `Sales.Total Revenue` | Time-series visual |
| `1f2a3b4c5d6e7f80903` | `barChart` | Revenue by Category | `Products.Category`, `Sales.Total Revenue` | Categorical bar chart |
| `1f2a3b4c5d6e7f80904` | `barChart` | Revenue by Country | `Customers.Country`, `Sales.Total Revenue` | International bar chart |
| `1f2a3b4c5d6e7f80905` | `barChart` | Top 5 Stores by Revenue | `Stores.StoreKey`, `Sales.Total Revenue` | Top N filtered ranking |

---

## Page 2: Customer & Product Intelligence

| Visual ID | Type | Container Title | Fields / Projections | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `b4c2a1f7d9c84e2a11` | `cardVisual` | Active Customers | `Sales.Active Customers` | Unique buyer count |
| `b4c2a1f7d9c84e2a22` | `cardVisual` | Average Order Value | `Sales.Average Order Value` | Basket size ($) |
| `b4c2a1f7d9c84e2a33` | `cardVisual` | Units Sold | `Sales.Units Sold` | Physical throughput |
| `b4c2a1f7d9c84e2a44` | `cardVisual` | Repeat Purchase Rate | `Sales.Repeat Purchase Rate` | Customer loyalty (%) |
| `b4c2a1f7d9c84e2a55` | `barChart` | Revenue by Age Group | `Customers.Age Group`, `Sales.Total Revenue` | Demographics bar chart |
| `b4c2a1f7d9c84e2a66` | `barChart` | Revenue by Gender | `Customers.Gender`, `Sales.Total Revenue` | Gender split |
| `b4c2a1f7d9c84e2ab0` | `barChart` | Revenue by Brand | `Products.Brand`, `Sales.Total Revenue` | Brand leaderboard |
| `b4c2a1f7d9c84e2a88` | `barChart` | Top 10 Products by Revenue | `Products.Product Name`, `Sales.Total Revenue` | Top 10 revenue SKUs |
| `b4c2a1f7d9c84e2a99` | `barChart` | Top 10 Products by Gross Profit | `Products.Product Name`, `Sales.Gross Profit` | Top 10 profit SKUs |
| `b4c2a1f7d9c84e2a77` | `matrix` | Revenue by Category and Subcategory | `Category`, `Subcategory`, `Total Revenue` | Hierarchical breakdown |
| `b4c2a1f7d9c84e2ab5` | `slicer` | Category | `Products.Category` | Slicer dropdown |
| `b4c2a1f7d9c84e2ab6` | `slicer` | Brand | `Products.Brand` | Slicer dropdown |

---

## Page 3: Store, Channel & Fulfillment

| Visual ID | Type | Container Title | Fields / Projections | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `c8f7a1f7d9c84e2a11` | `cardVisual` | Online Revenue | `Sales.Online Revenue` | Ecommerce volume |
| `c8f7a1f7d9c84e2a22` | `cardVisual` | Physical Store Revenue | `Sales.Physical Store Revenue` | Brick & mortar volume |
| `c8f7a1f7d9c84e2a33` | `cardVisual` | Revenue per Square Meter | `Sales.Revenue per Square Meter` | Space yield ($/m²) |
| `c8f7a1f7d9c84e2a44` | `cardVisual` | Average Delivery Days | `Sales.Average Delivery Days` | Shipping speed (days) |
| `c8f7a1f7d9c84e2ab4` | `donutChart` | Online vs Physical Revenue | `Stores.Channel`, `Sales.Total Revenue` | Omnichannel proportions |
| `c8f7a1f7d9c84e2ab7` | `scatterChart` | Store Size vs Revenue | `Square Meters`, `Total Revenue`, `StoreKey` | Space elasticity correlation |
| `c8f7a1f7d9c84e2ab8` | `columnChart` | Online Delivery Time Distribution (Days) | `Delivery Days`, `Sales.Orders` | Lead time histogram |
| `c8f7a1f7d9c84e2ab9` | `matrix` | Country and Store Performance | `Country`, `StoreKey`, `Total Revenue` | Store-level drilldown |
| `c8f7a1f7d9c84e2ab5` | `slicer` | Country | `Stores.Country` | Geographic slicer |
| `c8f7a1f7d9c84e2ab6` | `slicer` | Channel | `Stores.Channel` | Channel toggle |

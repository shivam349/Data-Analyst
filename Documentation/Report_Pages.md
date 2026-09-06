# Power BI Report Pages & UX Design

The report is structured into **3 analytical pages** formatted at standard 1920x1080 resolution, built for executive storytelling and deep operational exploration.

---

## Page 1: Executive Overview (`07a1e8c8339e6d20f681`)

### Business Objective
Provides C-suite stakeholders with an immediate snapshot of enterprise revenue, profitability, order volume, macro sales trends, and high-level geographic/category performance.

### Key Visuals (10 Visuals)
1. **Executive KPI Cards (Top Banner)**:
   - `Total Revenue`: Card visual displaying **$55.76M**.
   - `Gross Profit`: Card visual displaying **$32.66M**.
   - `Gross Margin %`: Card visual displaying **58.6%**.
   - `Orders`: Card visual displaying **26.3K**.
2. **Interactive Slicers (Global Filters)**:
   - `Year`: Single/multi-select slicer connected to `Dim_Date[Year]`.
   - `Country`: Dropdown/tile slicer filtering customer nationality.
3. **Core Charts**:
   - `Monthly Revenue Trend`: Line chart showing monthly revenue trajectory across 2016–2021.
   - `Revenue by Category`: Horizontal bar chart ranking the primary product categories (Computers, Cameras, etc.).
   - `Revenue by Country`: Bar chart illustrating international demand distribution.
   - `Top 5 Stores by Revenue`: Filtered ranking of top brick-and-mortar revenue generators.

---

## Page 2: Customer & Product Intelligence (`b4c2e8c9f7a14a2a91c3`)

### Business Objective
Delivers actionable customer demographic insights, basket size analytics, brand contributions, and SKU-level profitability.

### Key Visuals (12 Visuals)
1. **Customer KPI Cards**:
   - `Active Customers`: Card visual displaying **11.9K** unique purchasers.
   - `Average Order Value`: Card visual displaying **$2,117.89**.
   - `Units Sold`: Card visual displaying **197.8K** physical items.
   - `Repeat Purchase Rate`: Card visual displaying **61.2%** repeat customer loyalty.
2. **Demographic & Brand Breakdown**:
   - `Revenue by Age Group`: Bar chart showing revenue distribution across `18-24`, `25-34`, `35-44`, `45-54`, and `55+`.
   - `Revenue by Gender`: Comparison of male vs female sales volume.
   - `Revenue by Brand`: Bar chart evaluating manufacturer performance (Contoso, Litware, Fabrikam, etc.).
3. **Product Deep-Dive**:
   - `Revenue by Category and Subcategory`: Hierarchical matrix view.
   - `Top 10 Products by Revenue`: Leaderboard of top-grossing hardware.
   - `Top 10 Products by Gross Profit`: Leaderboard of highest dollar-profit SKUs.
4. **Slicers**:
   - `Category`: Dynamic category filter.
   - `Brand`: Multi-brand selector.

---

## Page 3: Store, Channel & Fulfillment (`c8f7d5a8a1b24e33b7d2`)

### Business Objective
Analyzes omnichannel channel split (Online vs. Physical), physical store square meter productivity, and ecommerce shipping lead times.

### Key Visuals (10 Visuals)
1. **Channel & Logistics KPI Cards**:
   - `Online Revenue`: Card visual displaying **$11.40M** (20.5%).
   - `Physical Store Revenue`: Card visual displaying **$44.35M** (79.5%).
   - `Revenue per Square Meter`: Card visual displaying **$479.24 / m²**.
   - `Average Delivery Days`: Card visual displaying **4.53 days**.
2. **Channel & Space Analytics**:
   - `Online vs Physical Revenue`: Donut chart comparing omnichannel proportions.
   - `Store Size vs Revenue`: Scatter plot evaluating correlation between retail square meters and generated revenue.
   - `Online Delivery Time Distribution`: Column chart showing shipment volume delivered across 0–14 days.
   - `Country and Store Performance`: Detailed country and store matrix.
3. **Slicers**:
   - `Country`: Filter by store operating geography.
   - `Channel`: Toggle between `Online` and `Physical Store`.

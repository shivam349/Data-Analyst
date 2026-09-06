-- ============================================================
-- GLOBAL ELECTRONICS RETAILER - 35 BUSINESS & ANALYTICAL QUERIES
-- Author: Shivam Garg (Data Analyst)
-- Verified on: Sales (62,884 rows), Products (2,517 rows),
--              Customers (15,266 rows), Stores (67 rows)
-- ============================================================

-- ------------------------------------------------------------
-- Query 01: Total Customer Count by Continent
-- Business Purpose: Establishes baseline geographic dispersion of registered customers.
-- ------------------------------------------------------------
SELECT Continent, COUNT(*) AS Total_Customers
FROM Customers
GROUP BY Continent
ORDER BY Total_Customers DESC;

-- ------------------------------------------------------------
-- Query 02: Distribution of Products across Categories
-- Business Purpose: Identifies catalogue depth and product variety per category.
-- ------------------------------------------------------------
SELECT Category, COUNT(*) AS Product_Count, 
       ROUND(AVG(Unit_Price_USD), 2) AS Avg_Unit_Price,
       ROUND(MIN(Unit_Price_USD), 2) AS Min_Price,
       ROUND(MAX(Unit_Price_USD), 2) AS Max_Price
FROM Products
GROUP BY Category
ORDER BY Product_Count DESC;

-- ------------------------------------------------------------
-- Query 03: Active Physical Stores by Country
-- Business Purpose: Evaluates physical retail footprint across international markets.
-- ------------------------------------------------------------
SELECT Country, COUNT(*) AS Store_Count, SUM(Square_Meters) AS Total_Floor_Space_Sqm
FROM Stores
WHERE Channel = 'Physical Store'
GROUP BY Country
ORDER BY Store_Count DESC;

-- ------------------------------------------------------------
-- Query 04: Total Revenue, Total Cost, and Gross Profit Overall
-- Business Purpose: Calculates macro enterprise profitability matching executive KPIs.
-- ------------------------------------------------------------
SELECT 
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Total_Revenue_USD,
    ROUND(SUM(s.Quantity * p.Unit_Cost_USD), 2) AS Total_Cost_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)), 2) AS Gross_Profit_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)) * 100.0 / SUM(s.Quantity * p.Unit_Price_USD), 2) AS Gross_Margin_Pct
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey;

-- ------------------------------------------------------------
-- Query 05: Total Orders, Total Units Sold, and Unique Active Customers
-- Business Purpose: Measures core operational transaction volume and active customer engagement.
-- ------------------------------------------------------------
SELECT 
    COUNT(DISTINCT Order_Number) AS Total_Orders,
    SUM(Quantity) AS Total_Units_Sold,
    COUNT(DISTINCT CustomerKey) AS Active_Customers,
    ROUND(SUM(Quantity) * 1.0 / COUNT(DISTINCT Order_Number), 2) AS Units_Per_Order
FROM Sales;

-- ------------------------------------------------------------
-- Query 06: Average Order Value (AOV) Overall
-- Business Purpose: Indicates spending velocity and basket value per purchasing session.
-- ------------------------------------------------------------
WITH OrderTotals AS (
    SELECT s.Order_Number, SUM(s.Quantity * p.Unit_Price_USD) AS Order_Revenue
    FROM Sales s
    JOIN Products p ON s.ProductKey = p.ProductKey
    GROUP BY s.Order_Number
)
SELECT 
    COUNT(*) AS Total_Orders,
    ROUND(AVG(Order_Revenue), 2) AS Average_Order_Value_USD,
    ROUND(MIN(Order_Revenue), 2) AS Min_Order_Value_USD,
    ROUND(MAX(Order_Revenue), 2) AS Max_Order_Value_USD
FROM OrderTotals;

-- ------------------------------------------------------------
-- Query 07: Annual Performance Trends (Revenue, Orders, Customers by Year)
-- Business Purpose: Tracks historical sales trajectory and annual growth patterns.
-- ------------------------------------------------------------
SELECT 
    SUBSTR(s.Order_Date, 1, 4) AS Sales_Year,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    COUNT(DISTINCT s.CustomerKey) AS Active_Customers,
    SUM(s.Quantity) AS Units_Sold,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)), 2) AS Gross_Profit_USD
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY Sales_Year
ORDER BY Sales_Year ASC;

-- ------------------------------------------------------------
-- Query 08: Revenue and Profit Contribution by Product Category
-- Business Purpose: Reveals which product categories drive top-line revenue versus bottom-line profit.
-- ------------------------------------------------------------
SELECT 
    p.Category,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)), 2) AS Gross_Profit_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)) * 100.0 / SUM(s.Quantity * p.Unit_Price_USD), 2) AS Margin_Pct,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD) * 100.0 / (SELECT SUM(s2.Quantity * p2.Unit_Price_USD) FROM Sales s2 JOIN Products p2 ON s2.ProductKey = p2.ProductKey), 2) AS Revenue_Share_Pct
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.Category
ORDER BY Revenue_USD DESC;

-- ------------------------------------------------------------
-- Query 09: Online vs. Physical Store Channel Performance
-- Business Purpose: Directly compares omni-channel dynamics between ecommerce and brick-and-mortar.
-- ------------------------------------------------------------
SELECT 
    st.Channel,
    COUNT(DISTINCT s.Order_Number) AS Orders,
    SUM(s.Quantity) AS Units_Sold,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)), 2) AS Gross_Profit_USD,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD) * 100.0 / (SELECT SUM(s2.Quantity * p2.Unit_Price_USD) FROM Sales s2 JOIN Products p2 ON s2.ProductKey = p2.ProductKey), 2) AS Revenue_Share_Pct
FROM Sales s
JOIN Stores st ON s.StoreKey = st.StoreKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY st.Channel;

-- ------------------------------------------------------------
-- Query 10: Top 10 Revenue-Generating Products
-- Business Purpose: Identifies star products driving disproportionate commercial volume.
-- ------------------------------------------------------------
SELECT 
    p.Product_Name,
    p.Category,
    p.Brand,
    SUM(s.Quantity) AS Units_Sold,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)), 2) AS Gross_Profit_USD
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.ProductKey, p.Product_Name, p.Category, p.Brand
ORDER BY Revenue_USD DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Query 11: Top 10 Most Profitable Products
-- Business Purpose: Uncovers products that generate the highest dollar margins.
-- ------------------------------------------------------------
SELECT 
    p.Product_Name,
    p.Category,
    p.Brand,
    SUM(s.Quantity) AS Units_Sold,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)), 2) AS Gross_Profit_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)) * 100.0 / SUM(s.Quantity * p.Unit_Price_USD), 2) AS Margin_Pct
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.ProductKey, p.Product_Name, p.Category, p.Brand
ORDER BY Gross_Profit_USD DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Query 12: Revenue and Profit by Brand
-- Business Purpose: Evaluates partner brand commercial strength and brand profitability.
-- ------------------------------------------------------------
SELECT 
    p.Brand,
    COUNT(DISTINCT p.ProductKey) AS Product_Count,
    SUM(s.Quantity) AS Units_Sold,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)), 2) AS Gross_Profit_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)) * 100.0 / SUM(s.Quantity * p.Unit_Price_USD), 2) AS Margin_Pct
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.Brand
ORDER BY Revenue_USD DESC;

-- ------------------------------------------------------------
-- Query 13: Revenue by Customer Country
-- Business Purpose: Shows international demand distribution and core sovereign revenue drivers.
-- ------------------------------------------------------------
SELECT 
    c.Country,
    COUNT(DISTINCT c.CustomerKey) AS Total_Customers,
    COUNT(DISTINCT s.Order_Number) AS Orders,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD) * 100.0 / (SELECT SUM(s2.Quantity * p2.Unit_Price_USD) FROM Sales s2 JOIN Products p2 ON s2.ProductKey = p2.ProductKey), 2) AS Revenue_Share_Pct
FROM Sales s
JOIN Customers c ON s.CustomerKey = c.CustomerKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY c.Country
ORDER BY Revenue_USD DESC;

-- ------------------------------------------------------------
-- Query 14: Top 5 Physical Stores by Total Revenue
-- Business Purpose: Identifies the highest performing retail units across the physical network.
-- ------------------------------------------------------------
SELECT 
    st.StoreKey,
    st.Country,
    st.State,
    st.Square_Meters,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD) / st.Square_Meters, 2) AS Revenue_Per_Sqm
FROM Sales s
JOIN Stores st ON s.StoreKey = st.StoreKey
JOIN Products p ON s.ProductKey = p.ProductKey
WHERE st.Channel = 'Physical Store'
GROUP BY st.StoreKey, st.Country, st.State, st.Square_Meters
ORDER BY Revenue_USD DESC
LIMIT 5;

-- ------------------------------------------------------------
-- Query 15: Revenue by Customer Age Group
-- Business Purpose: Assesses demographic revenue contribution to tailor marketing and merchandising.
-- ------------------------------------------------------------
WITH CustomerAges AS (
    SELECT CustomerKey,
           CASE 
               WHEN Birthday IS NULL THEN 'Unknown'
               WHEN (2026 - CAST(SUBSTR(Birthday, 1, 4) AS INT)) < 25 THEN '18-24'
               WHEN (2026 - CAST(SUBSTR(Birthday, 1, 4) AS INT)) < 35 THEN '25-34'
               WHEN (2026 - CAST(SUBSTR(Birthday, 1, 4) AS INT)) < 45 THEN '35-44'
               WHEN (2026 - CAST(SUBSTR(Birthday, 1, 4) AS INT)) < 55 THEN '45-54'
               ELSE '55+'
           END AS Age_Group
    FROM Customers
)
SELECT 
    ca.Age_Group,
    COUNT(DISTINCT s.CustomerKey) AS Active_Customers,
    COUNT(DISTINCT s.Order_Number) AS Orders,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD) * 100.0 / (SELECT SUM(s2.Quantity * p2.Unit_Price_USD) FROM Sales s2 JOIN Products p2 ON s2.ProductKey = p2.ProductKey), 2) AS Revenue_Share_Pct
FROM Sales s
JOIN CustomerAges ca ON s.CustomerKey = ca.CustomerKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY ca.Age_Group
ORDER BY Revenue_USD DESC;

-- ------------------------------------------------------------
-- Query 16: Revenue and Order Metrics by Customer Gender
-- Business Purpose: Evaluates purchasing parity between male and female customer cohorts.
-- ------------------------------------------------------------
SELECT 
    c.Gender,
    COUNT(DISTINCT s.CustomerKey) AS Active_Customers,
    COUNT(DISTINCT s.Order_Number) AS Orders,
    SUM(s.Quantity) AS Units_Sold,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD) / COUNT(DISTINCT s.Order_Number), 2) AS AOV_USD
FROM Sales s
JOIN Customers c ON s.CustomerKey = c.CustomerKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY c.Gender;

-- ------------------------------------------------------------
-- Query 17: Repeat Customer Analysis & Repeat Purchase Rate
-- Business Purpose: Measures customer retention and loyalty performance.
-- ------------------------------------------------------------
WITH OrderCounts AS (
    SELECT CustomerKey, COUNT(DISTINCT Order_Number) AS Order_Count
    FROM Sales
    GROUP BY CustomerKey
)
SELECT 
    COUNT(*) AS Total_Active_Customers,
    SUM(CASE WHEN Order_Count > 1 THEN 1 ELSE 0 END) AS Repeat_Customers,
    SUM(CASE WHEN Order_Count = 1 THEN 1 ELSE 0 END) AS One_Time_Customers,
    ROUND(SUM(CASE WHEN Order_Count > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Repeat_Purchase_Rate_Pct
FROM OrderCounts;

-- ------------------------------------------------------------
-- Query 18: Distribution of Customer Order Frequency
-- Business Purpose: Shows the depth of customer loyalty by bucketed order counts.
-- ------------------------------------------------------------
WITH CustFreq AS (
    SELECT CustomerKey, COUNT(DISTINCT Order_Number) AS Total_Orders
    FROM Sales
    GROUP BY CustomerKey
)
SELECT 
    CASE 
        WHEN Total_Orders = 1 THEN '1 Order'
        WHEN Total_Orders = 2 THEN '2 Orders'
        WHEN Total_Orders = 3 THEN '3 Orders'
        WHEN Total_Orders BETWEEN 4 AND 5 THEN '4-5 Orders'
        ELSE '6+ Orders'
    END AS Order_Tier,
    COUNT(*) AS Customer_Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM CustFreq), 2) AS Pct_Of_Customers
FROM CustFreq
GROUP BY Order_Tier
ORDER BY Customer_Count DESC;

-- ------------------------------------------------------------
-- Query 19: Top 10 High-Value VIP Customers by Total Spend
-- Business Purpose: Enables high-touch VIP customer relationship management.
-- ------------------------------------------------------------
SELECT 
    c.CustomerKey,
    c.Name,
    c.City,
    c.Country,
    COUNT(DISTINCT s.Order_Number) AS Orders_Placed,
    SUM(s.Quantity) AS Total_Units_Purchased,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Lifetime_Spend_USD
FROM Sales s
JOIN Customers c ON s.CustomerKey = c.CustomerKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY c.CustomerKey, c.Name, c.City, c.Country
ORDER BY Lifetime_Spend_USD DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Query 20: Average Delivery Days for Online Orders by Country
-- Business Purpose: Evaluates international logistics and delivery speed across cross-border markets.
-- ------------------------------------------------------------
SELECT 
    c.Country,
    COUNT(s.Order_Number) AS Online_Shipments,
    ROUND(AVG(JULIANDAY(s.Delivery_Date) - JULIANDAY(s.Order_Date)), 2) AS Avg_Delivery_Days,
    MIN(JULIANDAY(s.Delivery_Date) - JULIANDAY(s.Order_Date)) AS Min_Delivery_Days,
    MAX(JULIANDAY(s.Delivery_Date) - JULIANDAY(s.Order_Date)) AS Max_Delivery_Days
FROM Sales s
JOIN Stores st ON s.StoreKey = st.StoreKey
JOIN Customers c ON s.CustomerKey = c.CustomerKey
WHERE st.Channel = 'Online' AND s.Delivery_Date IS NOT NULL
GROUP BY c.Country
ORDER BY Avg_Delivery_Days ASC;

-- ------------------------------------------------------------
-- Query 21: Online Delivery Days Distribution (Frequency per Day Bucket)
-- Business Purpose: Directly matches the Power BI report fulfillment histogram visual.
-- ------------------------------------------------------------
WITH DeliveryTime AS (
    SELECT 
        CAST(JULIANDAY(s.Delivery_Date) - JULIANDAY(s.Order_Date) AS INT) AS Delivery_Days
    FROM Sales s
    JOIN Stores st ON s.StoreKey = st.StoreKey
    WHERE st.Channel = 'Online' AND s.Delivery_Date IS NOT NULL
)
SELECT 
    Delivery_Days,
    COUNT(*) AS Shipment_Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM DeliveryTime), 2) AS Pct_Of_Shipments
FROM DeliveryTime
GROUP BY Delivery_Days
ORDER BY Delivery_Days ASC;

-- ------------------------------------------------------------
-- Query 22: Store Floor Space Productivity (Revenue per Square Meter by Country)
-- Business Purpose: Benchmarks physical real estate productivity across national store networks.
-- ------------------------------------------------------------
SELECT 
    st.Country,
    COUNT(DISTINCT st.StoreKey) AS Store_Count,
    SUM(st.Square_Meters) AS Total_Sqm,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD) / SUM(st.Square_Meters), 2) AS Revenue_Per_Sqm
FROM Sales s
JOIN Stores st ON s.StoreKey = st.StoreKey
JOIN Products p ON s.ProductKey = p.ProductKey
WHERE st.Channel = 'Physical Store'
GROUP BY st.Country
ORDER BY Revenue_Per_Sqm DESC;

-- ------------------------------------------------------------
-- Query 23: Store Size vs. Revenue Tier Analysis
-- Business Purpose: Determines whether larger physical footprint correlates with higher store revenue.
-- ------------------------------------------------------------
WITH StorePerf AS (
    SELECT 
        st.StoreKey,
        st.Square_Meters,
        CASE 
            WHEN st.Square_Meters < 1000 THEN 'Small (<1,000 sqm)'
            WHEN st.Square_Meters < 1750 THEN 'Medium (1,000-1,749 sqm)'
            ELSE 'Large (1,750+ sqm)'
        END AS Size_Tier,
        SUM(s.Quantity * p.Unit_Price_USD) AS Store_Revenue
    FROM Sales s
    JOIN Stores st ON s.StoreKey = st.StoreKey
    JOIN Products p ON s.ProductKey = p.ProductKey
    WHERE st.Channel = 'Physical Store'
    GROUP BY st.StoreKey, st.Square_Meters
)
SELECT 
    Size_Tier,
    COUNT(*) AS Store_Count,
    ROUND(AVG(Square_Meters), 1) AS Avg_Sqm,
    ROUND(AVG(Store_Revenue), 2) AS Avg_Store_Revenue,
    ROUND(SUM(Store_Revenue) / SUM(Square_Meters), 2) AS Revenue_Per_Sqm
FROM StorePerf
GROUP BY Size_Tier
ORDER BY Revenue_Per_Sqm DESC;

-- ------------------------------------------------------------
-- Query 24: Subcategory Breakdown within Top Product Categories
-- Business Purpose: Uncovers sub-product level drivers of category profitability and scale.
-- ------------------------------------------------------------
SELECT 
    p.Category,
    p.Subcategory,
    SUM(s.Quantity) AS Units_Sold,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)), 2) AS Gross_Profit_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)) * 100.0 / SUM(s.Quantity * p.Unit_Price_USD), 2) AS Margin_Pct
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.Category, p.Subcategory
ORDER BY Revenue_USD DESC
LIMIT 10;

-- ------------------------------------------------------------
-- Query 25: Quarterly Revenue Growth Trajectory
-- Business Purpose: Provides executive trend visibility across multi-year fiscal quarters.
-- ------------------------------------------------------------
WITH QuarterlySales AS (
    SELECT 
        SUBSTR(s.Order_Date, 1, 4) AS Sales_Year,
        CASE 
            WHEN CAST(SUBSTR(s.Order_Date, 6, 2) AS INT) BETWEEN 1 AND 3 THEN 'Q1'
            WHEN CAST(SUBSTR(s.Order_Date, 6, 2) AS INT) BETWEEN 4 AND 6 THEN 'Q2'
            WHEN CAST(SUBSTR(s.Order_Date, 6, 2) AS INT) BETWEEN 7 AND 9 THEN 'Q3'
            ELSE 'Q4'
        END AS Sales_Quarter,
        SUM(s.Quantity * p.Unit_Price_USD) AS Revenue
    FROM Sales s
    JOIN Products p ON s.ProductKey = p.ProductKey
    GROUP BY Sales_Year, Sales_Quarter
)
SELECT 
    Sales_Year || '-' || Sales_Quarter AS Year_Quarter,
    ROUND(Revenue, 2) AS Revenue_USD
FROM QuarterlySales
ORDER BY Year_Quarter ASC;

-- ------------------------------------------------------------
-- Query 26: Revenue Seasonality by Calendar Month (Aggregated Across Years)
-- Business Purpose: Identifies peak shopping seasons and seasonal demand cycles.
-- ------------------------------------------------------------
SELECT 
    SUBSTR(s.Order_Date, 6, 2) AS Month_Number,
    CASE SUBSTR(s.Order_Date, 6, 2)
        WHEN '01' THEN 'January' WHEN '02' THEN 'February' WHEN '03' THEN 'March'
        WHEN '04' THEN 'April'   WHEN '05' THEN 'May'      WHEN '06' THEN 'June'
        WHEN '07' THEN 'July'    WHEN '08' THEN 'August'   WHEN '09' THEN 'September'
        WHEN '10' THEN 'October' WHEN '11' THEN 'November' WHEN '12' THEN 'December'
    END AS Month_Name,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY Month_Number, Month_Name
ORDER BY Month_Number ASC;

-- ------------------------------------------------------------
-- Query 27: Currency Code Transaction Breakdown
-- Business Purpose: Tracks FX exposure and currency distribution in global trade.
-- ------------------------------------------------------------
SELECT 
    s.Currency_Code,
    COUNT(DISTINCT s.Order_Number) AS Order_Count,
    SUM(s.Quantity) AS Units_Sold,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD_Equivalent,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD) * 100.0 / (SELECT SUM(s2.Quantity * p2.Unit_Price_USD) FROM Sales s2 JOIN Products p2 ON s2.ProductKey = p2.ProductKey), 2) AS Pct_Share
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY s.Currency_Code
ORDER BY Revenue_USD_Equivalent DESC;

-- ------------------------------------------------------------
-- Query 28: Product Pricing Tier Classification (Budget, Mid-Range, Premium)
-- Business Purpose: Categorizes catalog by price points to measure volume vs. premium value.
-- ------------------------------------------------------------
WITH PriceTiers AS (
    SELECT 
        ProductKey,
        CASE 
            WHEN Unit_Price_USD < 50 THEN 'Budget (<$50)'
            WHEN Unit_Price_USD < 300 THEN 'Mid-Range ($50-$299)'
            WHEN Unit_Price_USD < 1000 THEN 'High-End ($300-$999)'
            ELSE 'Luxury / Flagship ($1,000+)'
        END AS Price_Tier
    FROM Products
)
SELECT 
    pt.Price_Tier,
    COUNT(DISTINCT s.ProductKey) AS Products_Sold,
    SUM(s.Quantity) AS Units_Sold,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)), 2) AS Gross_Profit_USD,
    ROUND(SUM(s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)) * 100.0 / SUM(s.Quantity * p.Unit_Price_USD), 2) AS Margin_Pct
FROM Sales s
JOIN PriceTiers pt ON s.ProductKey = pt.ProductKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY pt.Price_Tier
ORDER BY Revenue_USD DESC;

-- ------------------------------------------------------------
-- Query 29: Dense Ranking of Products within Each Category by Revenue
-- Business Purpose: Demonstrates advanced SQL window functions (`DENSE_RANK() OVER PARTITION BY`).
-- ------------------------------------------------------------
WITH CategoryProductRev AS (
    SELECT 
        p.Category,
        p.Product_Name,
        ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD
    FROM Sales s
    JOIN Products p ON s.ProductKey = p.ProductKey
    GROUP BY p.Category, p.ProductKey, p.Product_Name
),
RankedProducts AS (
    SELECT 
        Category,
        Product_Name,
        Revenue_USD,
        DENSE_RANK() OVER (PARTITION BY Category ORDER BY Revenue_USD DESC) AS Category_Rank
    FROM CategoryProductRev
)
SELECT Category, Category_Rank, Product_Name, Revenue_USD
FROM RankedProducts
WHERE Category_Rank <= 3
ORDER BY Category, Category_Rank;

-- ------------------------------------------------------------
-- Query 30: Running Cumulative Total Revenue Over Time (Monthly)
-- Business Purpose: Demonstrates window aggregation (`SUM() OVER (ORDER BY)`).
-- ------------------------------------------------------------
WITH MonthlySales AS (
    SELECT 
        SUBSTR(s.Order_Date, 1, 7) AS Sales_Month,
        ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Monthly_Revenue
    FROM Sales s
    JOIN Products p ON s.ProductKey = p.ProductKey
    GROUP BY Sales_Month
)
SELECT 
    Sales_Month,
    Monthly_Revenue,
    ROUND(SUM(Monthly_Revenue) OVER (ORDER BY Sales_Month ASC), 2) AS Cumulative_Revenue_USD
FROM MonthlySales
ORDER BY Sales_Month ASC
LIMIT 12;

-- ------------------------------------------------------------
-- Query 31: Month-over-Month (MoM) Revenue Growth Rate Using LAG()
-- Business Purpose: Demonstrates analytical trend comparison with window lag offset functions.
-- ------------------------------------------------------------
WITH MonthlyTotals AS (
    SELECT 
        SUBSTR(s.Order_Date, 1, 7) AS Sales_Month,
        ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue
    FROM Sales s
    JOIN Products p ON s.ProductKey = p.ProductKey
    GROUP BY Sales_Month
)
SELECT 
    Sales_Month,
    Revenue AS Current_Month_Rev,
    LAG(Revenue, 1) OVER (ORDER BY Sales_Month) AS Prior_Month_Rev,
    ROUND((Revenue - LAG(Revenue, 1) OVER (ORDER BY Sales_Month)) * 100.0 / LAG(Revenue, 1) OVER (ORDER BY Sales_Month), 2) AS MoM_Growth_Pct
FROM MonthlyTotals
ORDER BY Sales_Month ASC
LIMIT 12;

-- ------------------------------------------------------------
-- Query 32: Customer Recency, Frequency, and Monetary (RFM) Segmentation
-- Business Purpose: Builds an advanced customer segmentation model for marketing targeting.
-- ------------------------------------------------------------
WITH CustomerStats AS (
    SELECT 
        c.CustomerKey,
        c.Name,
        c.Country,
        MAX(s.Order_Date) AS Last_Order_Date,
        COUNT(DISTINCT s.Order_Number) AS Frequency,
        ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Monetary
    FROM Sales s
    JOIN Customers c ON s.CustomerKey = c.CustomerKey
    JOIN Products p ON s.ProductKey = p.ProductKey
    GROUP BY c.CustomerKey, c.Name, c.Country
),
RFMScores AS (
    SELECT 
        CustomerKey, Name, Country, Last_Order_Date, Frequency, Monetary,
        NTILE(4) OVER (ORDER BY Last_Order_Date ASC) AS R_Score,
        NTILE(4) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(4) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM CustomerStats
)
SELECT 
    CASE 
        WHEN R_Score = 4 AND F_Score >= 3 AND M_Score >= 3 THEN 'Champions'
        WHEN F_Score >= 3 AND M_Score >= 3 THEN 'Loyal Customers'
        WHEN R_Score = 4 AND F_Score <= 2 THEN 'Recent New Customers'
        WHEN R_Score <= 2 AND F_Score >= 3 THEN 'At Risk / Churning'
        ELSE 'Standard'
    END AS Customer_Segment,
    COUNT(*) AS Customer_Count,
    ROUND(AVG(Monetary), 2) AS Avg_Spend_USD,
    ROUND(SUM(Monetary), 2) AS Total_Segment_Spend_USD
FROM RFMScores
GROUP BY Customer_Segment
ORDER BY Total_Segment_Spend_USD DESC;

-- ------------------------------------------------------------
-- Query 33: Pareto 80/20 Analysis (Cumulative Revenue by Top Products)
-- Business Purpose: Determines whether 80% of sales come from 20% of products.
-- ------------------------------------------------------------
WITH ProductTotals AS (
    SELECT 
        p.ProductKey,
        p.Product_Name,
        SUM(s.Quantity * p.Unit_Price_USD) AS Product_Revenue
    FROM Sales s
    JOIN Products p ON s.ProductKey = p.ProductKey
    GROUP BY p.ProductKey, p.Product_Name
),
Ranked AS (
    SELECT 
        ProductKey,
        Product_Name,
        Product_Revenue,
        ROW_NUMBER() OVER (ORDER BY Product_Revenue DESC) AS Prod_Rank,
        COUNT(*) OVER () AS Total_Products,
        SUM(Product_Revenue) OVER (ORDER BY Product_Revenue DESC) AS Cumulative_Revenue,
        SUM(Product_Revenue) OVER () AS Total_Revenue
    FROM ProductTotals
)
SELECT 
    Prod_Rank,
    Product_Name,
    ROUND(Product_Revenue, 2) AS Product_Rev_USD,
    ROUND(Cumulative_Revenue * 100.0 / Total_Revenue, 2) AS Cumulative_Rev_Pct,
    ROUND(Prod_Rank * 100.0 / Total_Products, 2) AS Cumulative_Product_Pct
FROM Ranked
WHERE Prod_Rank IN (1, 10, 50, 100, 250, 500)
ORDER BY Prod_Rank;

-- ------------------------------------------------------------
-- Query 34: Online Delivery Speed vs. Repeat Purchase Behavior
-- Business Purpose: Validates whether faster delivery fulfillment correlates with higher repeat re-order rates.
-- ------------------------------------------------------------
WITH OnlineOrders AS (
    SELECT 
        s.Order_Number,
        s.CustomerKey,
        CAST(JULIANDAY(s.Delivery_Date) - JULIANDAY(s.Order_Date) AS INT) AS Delivery_Days
    FROM Sales s
    JOIN Stores st ON s.StoreKey = st.StoreKey
    WHERE st.Channel = 'Online' AND s.Delivery_Date IS NOT NULL
),
CustOrderSummary AS (
    SELECT 
        CustomerKey,
        COUNT(DISTINCT Order_Number) AS Total_Orders
    FROM Sales
    GROUP BY CustomerKey
),
OrdersTagged AS (
    SELECT 
        oo.Delivery_Days,
        CASE 
            WHEN oo.Delivery_Days <= 3 THEN 'Fast (0-3 Days)'
            WHEN oo.Delivery_Days <= 6 THEN 'Standard (4-6 Days)'
            ELSE 'Slow (7+ Days)'
        END AS Delivery_Speed_Tier,
        cos.Total_Orders
    FROM OnlineOrders oo
    JOIN CustOrderSummary cos ON oo.CustomerKey = cos.CustomerKey
)
SELECT 
    Delivery_Speed_Tier,
    COUNT(*) AS Online_Orders_Delivered,
    ROUND(AVG(Delivery_Days), 2) AS Avg_Days,
    ROUND(SUM(CASE WHEN Total_Orders > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Customer_Repeat_Rate_Pct
FROM OrdersTagged
GROUP BY Delivery_Speed_Tier
ORDER BY Avg_Days ASC;

-- ------------------------------------------------------------
-- Query 35: Underperforming Physical Stores by Square Meter Yield
-- Business Purpose: Pinpoints candidate stores for operational review, lease restructuring, or resizing.
-- ------------------------------------------------------------
WITH StoreMetrics AS (
    SELECT 
        st.StoreKey,
        st.Country,
        st.State,
        st.Square_Meters,
        ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue_USD,
        ROUND(SUM(s.Quantity * p.Unit_Price_USD) / st.Square_Meters, 2) AS Revenue_Per_Sqm,
        RANK() OVER (ORDER BY SUM(s.Quantity * p.Unit_Price_USD) / st.Square_Meters ASC) AS Yield_Rank
    FROM Sales s
    JOIN Stores st ON s.StoreKey = st.StoreKey
    JOIN Products p ON s.ProductKey = p.ProductKey
    WHERE st.Channel = 'Physical Store'
    GROUP BY st.StoreKey, st.Country, st.State, st.Square_Meters
)
SELECT 
    Yield_Rank,
    StoreKey,
    Country,
    State,
    Square_Meters,
    Revenue_USD,
    Revenue_Per_Sqm
FROM StoreMetrics
WHERE Yield_Rank <= 5
ORDER BY Yield_Rank ASC;


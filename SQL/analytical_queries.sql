-- =====================================================================
-- PRODUCTION ANALYTICAL QUERIES & REPORTING VIEWS
-- Global Electronics Retailer Analytics
-- Author: Shivam Garg (Data Analyst)
-- =====================================================================

-- ---------------------------------------------------------------------
-- VIEW 1: Executive KPI Summary View
-- Computes order revenue, cost, profit, and delivery duration per line
-- ---------------------------------------------------------------------
CREATE VIEW IF NOT EXISTS v_sales_detailed AS
SELECT 
    s.Order_Number,
    s.Line_Item,
    s.Order_Date,
    s.Delivery_Date,
    s.CustomerKey,
    c.Name AS Customer_Name,
    c.Country AS Customer_Country,
    c.Continent AS Customer_Continent,
    c.Gender,
    s.StoreKey,
    st.Country AS Store_Country,
    st.Channel,
    s.ProductKey,
    p.Product_Name,
    p.Category,
    p.Subcategory,
    p.Brand,
    s.Quantity,
    p.Unit_Cost_USD,
    p.Unit_Price_USD,
    (s.Quantity * p.Unit_Price_USD) AS Line_Revenue_USD,
    (s.Quantity * p.Unit_Cost_USD) AS Line_Cost_USD,
    (s.Quantity * (p.Unit_Price_USD - p.Unit_Cost_USD)) AS Line_Gross_Profit_USD,
    CASE 
        WHEN st.Channel = 'Online' AND s.Delivery_Date IS NOT NULL 
        THEN CAST(JULIANDAY(s.Delivery_Date) - JULIANDAY(s.Order_Date) AS INT)
        ELSE NULL 
    END AS Delivery_Days
FROM Sales s
JOIN Customers c ON s.CustomerKey = c.CustomerKey
JOIN Stores st ON s.StoreKey = st.StoreKey
JOIN Products p ON s.ProductKey = p.ProductKey;

-- ---------------------------------------------------------------------
-- QUERY 1: Monthly Financial Performance Summary
-- ---------------------------------------------------------------------
SELECT 
    SUBSTR(Order_Date, 1, 7) AS Year_Month,
    COUNT(DISTINCT Order_Number) AS Orders,
    COUNT(DISTINCT CustomerKey) AS Active_Customers,
    SUM(Quantity) AS Total_Units,
    ROUND(SUM(Line_Revenue_USD), 2) AS Total_Revenue,
    ROUND(SUM(Line_Cost_USD), 2) AS Total_Cost,
    ROUND(SUM(Line_Gross_Profit_USD), 2) AS Gross_Profit,
    ROUND(SUM(Line_Gross_Profit_USD) * 100.0 / SUM(Line_Revenue_USD), 2) AS Gross_Margin_Pct
FROM v_sales_detailed
GROUP BY Year_Month
ORDER BY Year_Month ASC;

-- ---------------------------------------------------------------------
-- QUERY 2: Product Category & Brand Matrix
-- ---------------------------------------------------------------------
SELECT 
    Category,
    Brand,
    COUNT(DISTINCT ProductKey) AS SKU_Count,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Line_Revenue_USD), 2) AS Revenue_USD,
    ROUND(SUM(Line_Gross_Profit_USD), 2) AS Profit_USD,
    ROUND(SUM(Line_Gross_Profit_USD) * 100.0 / SUM(Line_Revenue_USD), 2) AS Margin_Pct
FROM v_sales_detailed
GROUP BY Category, Brand
ORDER BY Category ASC, Revenue_USD DESC;

-- ---------------------------------------------------------------------
-- QUERY 3: Channel Delivery Speed Benchmarking
-- ---------------------------------------------------------------------
SELECT 
    Customer_Country,
    COUNT(DISTINCT Order_Number) AS Online_Orders,
    ROUND(AVG(Delivery_Days), 2) AS Avg_Lead_Time_Days,
    ROUND(MIN(Delivery_Days), 2) AS Min_Lead_Time_Days,
    ROUND(MAX(Delivery_Days), 2) AS Max_Lead_Time_Days
FROM v_sales_detailed
WHERE Channel = 'Online' AND Delivery_Days IS NOT NULL
GROUP BY Customer_Country
ORDER BY Avg_Lead_Time_Days ASC;

-- ---------------------------------------------------------------------
-- QUERY 4: Store Real Estate Yield (Sales per Sqm)
-- ---------------------------------------------------------------------
SELECT 
    st.StoreKey,
    st.Country,
    st.State,
    st.Square_Meters,
    COUNT(DISTINCT s.Order_Number) AS Orders,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Total_Revenue,
    ROUND(SUM(s.Quantity * p.Unit_Price_USD) / st.Square_Meters, 2) AS Revenue_Per_Sqm
FROM Sales s
JOIN Stores st ON s.StoreKey = st.StoreKey
JOIN Products p ON s.ProductKey = p.ProductKey
WHERE st.Channel = 'Physical Store'
GROUP BY st.StoreKey, st.Country, st.State, st.Square_Meters
ORDER BY Revenue_Per_Sqm DESC;

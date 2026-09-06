-- =====================================================================
-- ADVANCED SQL ANALYSIS: RFM, COHORTS, PARETO & WINDOW ANALYTICS
-- Global Electronics Retailer
-- Author: Shivam Garg (Data Analyst)
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. RFM (RECENCY, FREQUENCY, MONETARY) CUSTOMER SEGMENTATION
-- Uses NTILE(4) window functions to assign quartile scores
-- ---------------------------------------------------------------------
WITH CustomerSummary AS (
    SELECT 
        c.CustomerKey,
        c.Name,
        c.Country,
        MAX(s.Order_Date) AS Last_Purchase_Date,
        COUNT(DISTINCT s.Order_Number) AS Frequency,
        ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Monetary
    FROM Sales s
    JOIN Customers c ON s.CustomerKey = c.CustomerKey
    JOIN Products p ON s.ProductKey = p.ProductKey
    GROUP BY c.CustomerKey, c.Name, c.Country
),
RFMRanked AS (
    SELECT 
        CustomerKey,
        Name,
        Country,
        Last_Purchase_Date,
        Frequency,
        Monetary,
        NTILE(4) OVER (ORDER BY Last_Purchase_Date ASC) AS R_Score,
        NTILE(4) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(4) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM CustomerSummary
),
SegmentedCustomers AS (
    SELECT 
        CustomerKey, Name, Country, Last_Purchase_Date, Frequency, Monetary,
        R_Score, F_Score, M_Score,
        CASE 
            WHEN R_Score = 4 AND F_Score >= 3 AND M_Score >= 3 THEN 'Champions'
            WHEN F_Score >= 3 AND M_Score >= 3 THEN 'Loyal Customers'
            WHEN R_Score = 4 AND F_Score <= 2 THEN 'Recent New Customers'
            WHEN R_Score <= 2 AND F_Score >= 3 THEN 'At Risk / Churning'
            WHEN R_Score = 1 THEN 'Lost Customers'
            ELSE 'Standard Casual'
        END AS RFM_Segment
    FROM RFMRanked
)
SELECT 
    RFM_Segment,
    COUNT(*) AS Customer_Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM SegmentedCustomers), 2) AS Customer_Pct,
    ROUND(AVG(Frequency), 2) AS Avg_Orders,
    ROUND(AVG(Monetary), 2) AS Avg_Spend_USD,
    ROUND(SUM(Monetary), 2) AS Total_Spend_USD,
    ROUND(SUM(Monetary) * 100.0 / (SELECT SUM(Monetary) FROM SegmentedCustomers), 2) AS Total_Revenue_Pct
FROM SegmentedCustomers
GROUP BY RFM_Segment
ORDER BY Total_Spend_USD DESC;

-- ---------------------------------------------------------------------
-- 2. PARETO 80/20 ANALYSIS (PRODUCT REVENUE CONCENTRATION)
-- ---------------------------------------------------------------------
WITH ProductRevenue AS (
    SELECT 
        p.ProductKey,
        p.Product_Name,
        p.Category,
        SUM(s.Quantity * p.Unit_Price_USD) AS Total_Revenue
    FROM Sales s
    JOIN Products p ON s.ProductKey = p.ProductKey
    GROUP BY p.ProductKey, p.Product_Name, p.Category
),
CumulativeStats AS (
    SELECT 
        ProductKey,
        Product_Name,
        Category,
        Total_Revenue,
        ROW_NUMBER() OVER (ORDER BY Total_Revenue DESC) AS Product_Rank,
        COUNT(*) OVER () AS Total_SKUs,
        SUM(Total_Revenue) OVER (ORDER BY Total_Revenue DESC) AS Running_Cumulative_Rev,
        SUM(Total_Revenue) OVER () AS Total_Enterprise_Rev
    FROM ProductRevenue
)
SELECT 
    Product_Rank,
    Product_Name,
    Category,
    ROUND(Total_Revenue, 2) AS SKU_Revenue_USD,
    ROUND(Running_Cumulative_Rev * 100.0 / Total_Enterprise_Rev, 2) AS Cumulative_Rev_Pct,
    ROUND(Product_Rank * 100.0 / Total_SKUs, 2) AS Cumulative_SKU_Pct
FROM CumulativeStats
WHERE Product_Rank IN (1, 10, 50, 100, 250, 500, 1000)
ORDER BY Product_Rank ASC;

-- ---------------------------------------------------------------------
-- 3. MONTH-OVER-MONTH (MoM) REVENUE & ORDER GROWTH
-- Uses LAG() window function
-- ---------------------------------------------------------------------
WITH MonthlyRollup AS (
    SELECT 
        SUBSTR(s.Order_Date, 1, 7) AS Month_Period,
        COUNT(DISTINCT s.Order_Number) AS Orders,
        ROUND(SUM(s.Quantity * p.Unit_Price_USD), 2) AS Revenue
    FROM Sales s
    JOIN Products p ON s.ProductKey = p.ProductKey
    GROUP BY Month_Period
)
SELECT 
    Month_Period,
    Orders,
    Revenue AS Current_Revenue,
    LAG(Revenue, 1) OVER (ORDER BY Month_Period) AS Prior_Month_Revenue,
    ROUND((Revenue - LAG(Revenue, 1) OVER (ORDER BY Month_Period)) * 100.0 / LAG(Revenue, 1) OVER (ORDER BY Month_Period), 2) AS MoM_Growth_Pct
FROM MonthlyRollup
ORDER BY Month_Period ASC;

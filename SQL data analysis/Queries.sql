
USE WideWorldImporters;

--#1

--Subquery method
SELECT TT.*,
        FORMAT(ROUND((IncomePerYear / NumberOfDistinctMonth) * 12.0, 2 ), 'N2') AS YearlyLinearIncome,
        CAST(
        FLOOR(
            (
			(ROUND((IncomePerYear / NumberOfDistinctMonth) * 12.0, 2) - 
              LAG(ROUND((IncomePerYear / NumberOfDistinctMonth) * 12.0, 2)) OVER (ORDER BY [Year])) 
             / LAG(ROUND((IncomePerYear / NumberOfDistinctMonth) * 12.0, 2)) OVER (ORDER BY [Year])
			 ) * 10000
        ) / 100.0  
        AS DECIMAL(10,2)) AS GrowthRate
FROM (SELECT 
        YEAR(T1.OrderDate) AS [Year],
        SUM(T3.ExtendedPrice - T3.TaxAmount) AS IncomePerYear,
        COUNT(DISTINCT MONTH(T1.OrderDate)) AS NumberOfDistinctMonth
    FROM Sales.Orders AS T1
    JOIN Sales.Invoices AS T2 
    ON T2.OrderID = T1.OrderID
    JOIN Sales.InvoiceLines AS T3 
    ON T2.InvoiceID = T3.InvoiceID
    GROUP BY YEAR(T1.OrderDate)) AS TT
ORDER BY [Year];

--CTE (Common table expression) method
WITH TT AS (
            SELECT 
                    YEAR(T1.OrderDate) AS [Year],
                    SUM(T3.ExtendedPrice - T3.TaxAmount) AS IncomePerYear,
                    COUNT(DISTINCT MONTH(T1.OrderDate)) AS NumberOfDistinctMonth
    FROM Sales.Orders AS T1
    JOIN Sales.Invoices AS T2 
    ON T2.OrderID = T1.OrderID
    JOIN Sales.InvoiceLines AS T3 
    ON T2.InvoiceID = T3.InvoiceID
    GROUP BY 
            YEAR(T1.OrderDate)
)
SELECT
        [Year],
        ROUND(IncomePerYear, 2) AS IncomePerYear,
        NumberOfDistinctMonth AS NumberOfDistinctMonths,
        FORMAT(ROUND((IncomePerYear / NumberOfDistinctMonth) * 12.0, 2 ), 'N2') AS YearlyLinearIncome,
        CAST(
            FLOOR(
                (
			    (ROUND((IncomePerYear / NumberOfDistinctMonth) * 12.0, 2) - 
                  LAG(ROUND((IncomePerYear / NumberOfDistinctMonth) * 12.0, 2)) OVER (ORDER BY [Year])) 
                 / LAG(ROUND((IncomePerYear / NumberOfDistinctMonth) * 12.0, 2)) OVER (ORDER BY [Year])
			     ) * 10000
            ) / 100.0  
        AS DECIMAL(10,2)) AS GrowthRate
FROM TT
ORDER BY [Year];
--------------------------------------------------------------------------------------------------------------------------------------

--#2

--Subquery method
SELECT*
FROM (SELECT 
            YEAR(T2.OrderDate) AS TheYear,
            DATEPART(QUARTER, T2.OrderDate) AS TheQuarter,
            --T1.CustomerID,
            T1.CustomerName,
            SUM(T4.ExtendedPrice-T4.TaxAmount) AS IncomePerYear,
            ROW_NUMBER () OVER(PARTITION BY YEAR(T2.OrderDate), DATEPART(QUARTER, T2.OrderDate) 
            ORDER BY SUM(T4.ExtendedPrice-T4.TaxAmount) DESC) AS DNR
FROM Sales.Customers AS T1
LEFT JOIN Sales.Orders AS T2
ON T1.CustomerID=T2.CustomerID
LEFT JOIN Sales.Invoices AS T3
ON T2.OrderID=T3.OrderID
LEFT JOIN Sales.InvoiceLines AS T4
ON T3.InvoiceID=T4.InvoiceID
GROUP BY 
         YEAR(T2.OrderDate), 
         DATEPART(QUARTER, T2.OrderDate), 
         T1.CustomerName) AS T5
WHERE 1=1
AND T5.DNR <=5
ORDER BY 
        T5.TheYear, 
        T5.TheQuarter, 
        T5.DNR;

--CTE (Common table expression) method
WITH T5 AS 
     (SELECT 
            YEAR(T2.OrderDate) AS TheYear,
            DATEPART(QUARTER, T2.OrderDate) AS TheQuarter,
            T1.CustomerName,
            SUM(T4.ExtendedPrice-T4.TaxAmount) AS IncomePerYear,
            ROW_NUMBER() OVER(PARTITION BY YEAR(T2.OrderDate), DATEPART(QUARTER, T2.OrderDate) 
            ORDER BY SUM(T4.ExtendedPrice-T4.TaxAmount) DESC) AS DNR
        FROM Sales.Customers AS T1
        LEFT JOIN Sales.Orders AS T2
        ON T1.CustomerID=T2.CustomerID
        LEFT JOIN Sales.Invoices AS T3
        ON T2.OrderID=T3.OrderID
        LEFT JOIN Sales.InvoiceLines AS T4
        ON T3.InvoiceID=T4.InvoiceID
        GROUP BY YEAR(T2.OrderDate), 
        DATEPART(QUARTER, T2.OrderDate), 
        T1.CustomerName)
SELECT *
FROM T5
WHERE 1=1
AND DNR <=5
ORDER BY 
        TheYear,
        TheQuarter,
        DNR;
--------------------------------------------------------------------------------------------------------------------------------------

--#3

SELECT TOP 10 T1.StockItemID,
        T2.StockItemName,
        SUM(T1.ExtendedPrice-T1.TaxAmount) AS TotalProfit       
FROM Sales.InvoiceLines AS T1
LEFT JOIN Warehouse.StockItems AS T2
ON T1.StockItemID=T2.StockItemID
GROUP BY 
        T1.StockItemID,T2.StockItemName
ORDER BY 
        TotalProfit DESC;
--------------------------------------------------------------------------------------------------------------------------------------

--#4

--Subquery method
SELECT 
        ROW_NUMBER() OVER(ORDER BY TT.NominalProductProfit DESC) AS Rn,
        TT.*,
        DENSE_RANK() OVER(ORDER BY TT.NominalProductProfit DESC) AS DNR
FROM(SELECT 
            StockItemID,
            StockItemName,
            UnitPrice,
            RecommendedRetailPrice,
            RecommendedRetailPrice-UnitPrice AS NominalProductProfit
FROM Warehouse.StockItems
WHERE ValidTo>GETDATE()) AS TT
ORDER BY Rn;

--CTE (Common table expression) method
WITH TT AS
(SELECT 
        StockItemID,
        StockItemName,
        UnitPrice,
        RecommendedRetailPrice,
        RecommendedRetailPrice-UnitPrice AS NominalProductProfit
FROM Warehouse.StockItems
WHERE ValidTo>GETDATE())
SELECT 
        ROW_NUMBER() OVER(ORDER BY TT.NominalProductProfit DESC) AS Rn,
        TT.*,
        DENSE_RANK() OVER(ORDER BY TT.NominalProductProfit DESC) AS DNR
FROM TT
ORDER BY Rn;
--------------------------------------------------------------------------------------------------------------------------------------

--#5

--Method with using STRING_AGG function
SELECT 
        CONCAT(T1.SupplierID, ' - ', T2.SupplierName)  AS SupplierDetails,
	    STRING_AGG(CONCAT(CAST(T1.StockItemID AS NVARCHAR(MAX)), ' ', 
        CAST(T1.StockItemName AS NVARCHAR(MAX))), ' / , ') AS ProductDetails
FROM Warehouse.StockItems AS T1
LEFT JOIN Purchasing.Suppliers AS T2
       ON T1.SupplierID=T2.SupplierID
GROUP BY 
        T1.SupplierID, 
        T2.SupplierName
ORDER BY 
        T1.SupplierID;

--Method with using STUFF function and XML
SELECT 
        CONCAT(T1.SupplierID, ' - ', T2.SupplierName) AS SupplierDetails,
        STUFF((
                SELECT ' / , ' + 
                        CAST(SI.StockItemID AS NVARCHAR(MAX)) + ' ' + 
                        CAST(SI.StockItemName AS NVARCHAR(MAX))
                FROM Warehouse.StockItems AS SI
                WHERE SI.SupplierID = T1.SupplierID
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 5, '') AS ProductDetails
FROM Warehouse.StockItems AS T1
LEFT JOIN Purchasing.Suppliers AS T2
ON T1.SupplierID = T2.SupplierID
GROUP BY 
        T1.SupplierID, 
        T2.SupplierName
ORDER BY 
        T1.SupplierID;
--------------------------------------------------------------------------------------------------------------------------------------

--#6

SELECT TOP 5 
	       T1.CustomerID, 
	       T2.CityName,
	       T4.CountryName,
	       T4.Continent,
	       T4.Region,
	       SUM(T6.ExtendedPrice) AS TotalExtendedPrice
FROM Sales.Customers AS T1
LEFT JOIN Application.Cities AS T2
ON T1.PostalCityID=T2.CityID
LEFT JOIN Application.StateProvinces AS T3
ON T2.StateProvinceID=T3.StateProvinceID
LEFT JOIN Application.Countries AS T4
ON T3.CountryID=T4.CountryID
LEFT JOIN Sales.Invoices AS T5
ON T1.CustomerID=T5.CustomerID
LEFT JOIN Sales.InvoiceLines AS T6
ON T5.InvoiceID=T6.InvoiceID
GROUP BY 
         T1.CustomerID, 
		 T2.CityName,
		 T4.CountryName,
		 T4.Continent,
		 T4.Region
ORDER BY 
         TotalExtendedPrice DESC;
--------------------------------------------------------------------------------------------------------------------------------------

--#7

--Subquery method
SELECT
        OrderYear,
        OrderMonth,
        MonthlyTotal,
        CumulativeTotal
FROM
(SELECT
        OrderYear,
        CAST(OrderMonth AS NVARCHAR(20)) AS OrderMonth,
        MonthlyTotal,
        SUM(MonthlyTotal) OVER (PARTITION BY OrderYear ORDER BY OrderMonth) AS CumulativeTotal,
        1 AS SortKey
 FROM (SELECT
              YEAR(T1.OrderDate)  AS OrderYear,
              MONTH(T1.OrderDate) AS OrderMonth,
              SUM(T3.ExtendedPrice - T3.TaxAmount) AS MonthlyTotal
        FROM Sales.Orders AS T1
        LEFT JOIN Sales.Invoices AS T2
        ON T1.OrderID = T2.OrderID
        LEFT JOIN Sales.InvoiceLines AS T3
        ON T2.InvoiceID = T3.InvoiceID
        GROUP BY
                 YEAR(T1.OrderDate),
                 MONTH(T1.OrderDate)) AS TT
UNION ALL
SELECT
        OrderYear,
        'GrandTotal' AS OrderMonth,
        SUM(MonthlyTotal) AS MonthlyTotal,
        SUM(MonthlyTotal) AS CumulativeTotal,
        2 AS SortKey
FROM (SELECT
            YEAR(T1.OrderDate)  AS OrderYear,
            MONTH(T1.OrderDate) AS OrderMonth,
            SUM(T3.ExtendedPrice - T3.TaxAmount) AS MonthlyTotal
        FROM Sales.Orders AS T1
        LEFT JOIN Sales.Invoices AS T2
        ON T1.OrderID = T2.OrderID
        LEFT JOIN Sales.InvoiceLines AS T3
        ON T2.InvoiceID = T3.InvoiceID
        GROUP BY
                YEAR(T1.OrderDate),
                MONTH(T1.OrderDate)) AS TT1
GROUP BY 
        OrderYear) AS TT2
ORDER BY
        OrderYear,
        SortKey,
        TRY_CAST(OrderMonth AS INT);

--CTE (Common table expression) method
WITH TT AS
(SELECT 
        YEAR(T1.OrderDate)  AS OrderYear,
        MONTH(T1.OrderDate) AS OrderMonth,
        SUM(T3.ExtendedPrice - T3.TaxAmount) AS MonthlyTotal
 FROM Sales.Orders AS T1
 LEFT JOIN Sales.Invoices AS T2
 ON T1.OrderID = T2.OrderID
 LEFT JOIN Sales.InvoiceLines AS T3
 ON T2.InvoiceID = T3.InvoiceID
 GROUP BY
         YEAR(T1.OrderDate),
         MONTH(T1.OrderDate)),
TT1 AS
(SELECT 
        OrderYear,
        CAST(OrderMonth AS NVARCHAR(20)) AS OrderMonth,
        MonthlyTotal,
        SUM(MonthlyTotal) OVER
        (PARTITION BY OrderYear ORDER BY OrderMonth) AS CumulativeTotal,
        1 AS SortKey
FROM TT

UNION ALL

SELECT OrderYear,
        'GrandTotal' AS OrderMonth,
        SUM(MonthlyTotal) AS MonthlyTotal,
        SUM(MonthlyTotal) AS CumulativeTotal,
        2 AS SortKey
FROM TT
GROUP BY OrderYear)
SELECT TT1.OrderYear,
        TT1.OrderMonth,
        TT1.MonthlyTotal,
        TT1.CumulativeTotal
FROM TT1
ORDER BY 
        OrderYear,
        SortKey,
        TRY_CAST(OrderMonth AS INT);
--------------------------------------------------------------------------------------------------------------------------------------

--#8

SELECT OrderMonth,
		"2013",
		"2014",
		"2015",
		"2016"
FROM (SELECT 
            YEAR(OrderDate) AS OrderYear,
		    MONTH(OrderDate) AS OrderMonth,
		    OrderID
FROM Sales.Orders) AS TT 
PIVOT (COUNT(OrderID) 
		FOR OrderYear IN ("2013", "2014", "2015", "2016")) AS PVT
ORDER BY 
        OrderMonth;
--------------------------------------------------------------------------------------------------------------------------------------

--#9

--Subquery method
SELECT T3.CustomerID,
       T4.CustomerName,
	   T3.OrderDate,	   
	   T3.DaysDiffBetweenOrders,
	   T3.AvgDaysBetweenOrders,
       CASE 
	       WHEN DaysDiffBetweenOrders>T3.AvgDaysBetweenOrders*2 THEN 'Potential Churn'
	       ELSE 'Active' 
       END AS CustomerStatus  
FROM(SELECT T2.*
FROM(SELECT T1.CustomerID,
			T1.OrderDate,
			T1.PrevOrderDate,
		DATEDIFF(DAY,T1.OrderDate, T1.PrevOrderDate) AS DaysDiffBetweenOrders,
		AVG(DATEDIFF(DAY,T1.OrderDate, T1.PrevOrderDate)) OVER (PARTITION BY T1.CustomerID) AS AvgDaysBetweenOrders,		
		ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY T1.PrevOrderDate DESC) AS RN		
FROM (SELECT 
		    CustomerID,
		    OrderDate,
		    LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS PrevOrderDate		
FROM Sales.Orders) AS T1) AS T2
WHERE 1=1 
AND PrevOrderDate IS NOT NULL 
AND RN=1) AS T3
LEFT JOIN Sales.Customers AS T4
ON T3.CustomerID=T4.CustomerID;

--CTE (Common table expression) method
WITH T1 AS 
	(SELECT 
            CustomerID,
			OrderDate,
			LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS PrevOrderDate		
	FROM Sales.Orders),
T2 AS
	(SELECT 
            T1.CustomerID,
			T1.OrderDate,
			T1.PrevOrderDate,
			DATEDIFF(DAY,T1.OrderDate, T1.PrevOrderDate) AS DaysDiffBetweenOrders,
			AVG(DATEDIFF(DAY,T1.OrderDate, T1.PrevOrderDate)) OVER (PARTITION BY T1.CustomerID) AS AvgDaysBetweenOrders,		
			ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY T1.PrevOrderDate DESC) AS RN
	FROM T1),
T3 AS
	(SELECT*
	FROM T2
	WHERE 1=1
	AND PrevOrderDate IS NOT NULL
	AND RN=1)
SELECT 
       T3.CustomerID,
       T4.CustomerName,
	   T3.OrderDate,	   
	   T3.DaysDiffBetweenOrders,
	   T3.AvgDaysBetweenOrders,
       CASE 
	       WHEN DaysDiffBetweenOrders>T3.AvgDaysBetweenOrders*2 THEN 'Potential Churn'
	       ELSE 'Active' 
       END AS CustomerStatus  
FROM T3
LEFT JOIN Sales.Customers AS T4
ON T3.CustomerID=T4.CustomerID;
--------------------------------------------------------------------------------------------------------------------------------------

--#10

--Subquery method
SELECT
        T4.CustomerCategoryName,
        T4.CustomerCOUNT,
        T5.TotalCustCount,
        FORMAT(T4.CustomerCOUNT * 100.0 / T5.TotalCustCount, 'N2') + '%' AS DistributionFactor
FROM
(SELECT 
        T1.CustomerCategoryName,
        COUNT(DISTINCT
        CASE
             WHEN T2.CustomerName LIKE 'Tailspin%' THEN 'Tailspin'
             WHEN T2.CustomerName LIKE 'Wingtip%'  THEN 'Wingtip'
             ELSE T2.CustomerName
        END) AS CustomerCOUNT
  FROM Sales.CustomerCategories AS T1
  JOIN Sales.Customers AS T2
  ON T2.CustomerCategoryID = T1.CustomerCategoryID
  GROUP BY 
            T1.CustomerCategoryName) AS T4
CROSS JOIN
(SELECT
        COUNT(DISTINCT
        CASE
              WHEN CustomerName LIKE 'Tailspin%' THEN 'Tailspin'
              WHEN CustomerName LIKE 'Wingtip%'  THEN 'Wingtip'
              ELSE CustomerName
        END) AS TotalCustCount
FROM Sales.Customers) AS T5;

--CTE (Common table expression) method
WITH T4 AS
(SELECT T1.CustomerCategoryName,
        COUNT(DISTINCT
            CASE
                WHEN T2.CustomerName LIKE 'Tailspin%' THEN 'Tailspin'
                WHEN T2.CustomerName LIKE 'Wingtip%'  THEN 'Wingtip'
                ELSE T2.CustomerName
            END) AS CustomerCOUNT
 FROM Sales.CustomerCategories AS T1
 JOIN Sales.Customers AS T2
 ON T2.CustomerCategoryID = T1.CustomerCategoryID
 GROUP BY 
        T1.CustomerCategoryName),
T5 AS
(SELECT COUNT(DISTINCT
            CASE
                WHEN CustomerName LIKE 'Tailspin%' THEN 'Tailspin'
                WHEN CustomerName LIKE 'Wingtip%'  THEN 'Wingtip'
                ELSE CustomerName
            END) AS TotalCustCount
FROM Sales.Customers)
SELECT 
       T4.CustomerCategoryName,
       T4.CustomerCOUNT,
       T5.TotalCustCount,
       FORMAT(T4.CustomerCOUNT * 100.0 / T5.TotalCustCount, 'N2') + '%' AS DistributionFactor
FROM T4
CROSS JOIN T5;

--Subquery method with using EXISTS
SELECT T4.*,
		FORMAT (CustomerCOUNT*100.0/TotalCustCount, 'N2') + '%' AS DistributionFactor 
FROM (SELECT 
            T1.CustomerCategoryName,
		(SELECT COUNT(DISTINCT CASE
						            WHEN T2.CustomerName LIKE 'Tailspin%' THEN 'Tailspin'  
						            WHEN T2.CustomerName LIKE 'Wingtip%' THEN 'Wingtip'
						            ELSE T2.CustomerName 
						        END)
		FROM Sales.Customers AS T2
		WHERE 1=1
		AND T2.CustomerCategoryID=T1.CustomerCategoryID) AS CustomerCOUNT,
        (SELECT COUNT(DISTINCT CASE 
						            WHEN T2.CustomerName LIKE 'Tailspin%' THEN 'Tailspin'  
						            WHEN T2.CustomerName LIKE 'Wingtip%' THEN 'Wingtip'
						            ELSE T2.CustomerName 
						        END) 		
		FROM Sales.Customers AS T2) AS TotalCustCount
FROM Sales.CustomerCategories AS T1
WHERE EXISTS(SELECT 1
			FROM Sales.Customers AS T3
			WHERE 1=1
			AND T3.CustomerCategoryID=T1.CustomerCategoryID)) AS T4;
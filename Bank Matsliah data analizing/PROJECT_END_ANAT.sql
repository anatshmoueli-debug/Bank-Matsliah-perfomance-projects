
USE BANKMATSLIAKH;

/*
1. כמות חשבונות תמורה וחשבונות עו"ש נפתחו בכל רביעון בכל שנה של תקופה 2018-2022
*/

SELECT 
    [Year],
    AccountType,
    COALESCE([1],0) AS Q1,
    COALESCE([2],0) AS Q2,
    COALESCE([3],0) AS Q3,
    COALESCE([4],0) AS Q4,   
    COALESCE([1],0) + COALESCE([2],0) + COALESCE([3],0) + COALESCE([4],0) AS TotalYear

FROM
    (SELECT 
     YEAR(DateAccountOpening) AS [Year],
     DATEPART(QUARTER, DateAccountOpening) AS QuarterNumber,
     AccountType
    FROM Accounts
    WHERE 1=1
    AND YEAR(DateAccountOpening) BETWEEN 2018 AND 2022) AS SourceTable

PIVOT
(COUNT(QuarterNumber)
 FOR QuarterNumber IN ([1],[2],[3],[4])) AS PivotTable

ORDER BY [Year] DESC, AccountType;

/*
2. סניפים שפתחו יותר חשבונות בתקופה 2018-2022
*/

WITH TopBranches AS
    (SELECT
    BranchID, 
    COUNT(*) AS TotalQuantityOpenAccounts, 
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM Accounts
    WHERE 1=1
    AND DateAccountOpening >= '2018-01-01' AND DateAccountOpening < '2023-01-01'
    GROUP BY BranchID)
SELECT
    BranchID,
    TotalQuantityOpenAccounts,
    rnk
FROM TopBranches
WHERE 1=1
AND rnk <= 5
ORDER BY TotalQuantityOpenAccounts DESC;

/*

3. סכומים שהופקדו בפיקדונות בכל רביעון בכל שנה של תקופה 2018-2022
*/

SELECT 
    [Year],
    COALESCE([1],0) AS Q1,
    COALESCE([2],0) AS Q2,
    COALESCE([3],0) AS Q3,
    COALESCE([4],0) AS Q4,   
    COALESCE([1],0) + COALESCE([2],0) + COALESCE([3],0) + COALESCE([4],0) AS TotalYearAmount

FROM
(SELECT 
 YEAR(DateDepositOpening) AS [Year],
 DATEPART(QUARTER, DateDepositOpening) AS QuarterNumber,
 SUM(AmountDeposit) AS TotalAmount
 FROM Deposits
 WHERE 1=1
 AND YEAR(DateDepositOpening) BETWEEN 2018 AND 2022
 GROUP BY 
        YEAR(DateDepositOpening),
        DATEPART(QUARTER, DateDepositOpening)) AS SourceTable

PIVOT
(SUM(TotalAmount)
 FOR QuarterNumber IN ([1],[2],[3],[4])) AS PivotTable

ORDER BY TotalYearAmount DESC;

/*
4. כמות חשבונות שנסגרו בכל חודש בשנת 2023
*/

SELECT 
    YEAR(DateAccountClosing) AS [Year],
    MONTH(DateAccountClosing) AS [Month],
    COUNT(*) AS QuantityCloseAccount
FROM Accounts
WHERE 1=1 
AND YEAR(DateAccountClosing) = 2023
AND DateAccountClosing IS NOT NULL
GROUP BY YEAR(DateAccountClosing), MONTH(DateAccountClosing);

/*
5. כמות תלונות של לקוחות וכמות חשבונות שנסגרו בכל חודש של שנת 2023

*/

WITH ClosedAccounts AS 
    (SELECT
        YEAR(DateAccountClosing) AS [Year],
        MONTH(DateAccountClosing) AS [Month],
        COUNT(*) AS ClosedAccounts
    FROM Accounts
    WHERE 1=1
    AND YEAR(DateAccountClosing) = 2023
    GROUP BY YEAR(DateAccountClosing), MONTH(DateAccountClosing)),

Complaints AS 
    (SELECT
        YEAR(FeedbackDate) AS [Year],
        MONTH(FeedbackDate) AS [Month],
        COUNT(*) AS Complaints
    FROM Clients
    WHERE 1=1
      AND FeedbackType = 'Complaint'
      AND YEAR(FeedbackDate) = 2023
    GROUP BY YEAR(FeedbackDate), MONTH(FeedbackDate))

SELECT
    T1.[Year],
    T1.[Month],
    T1.ClosedAccounts,
    COALESCE(T2.Complaints,0) AS Complaints
FROM ClosedAccounts AS T1
LEFT JOIN complaints AS T2
ON T1.[Year] = T2.[Year]
AND T1.[Month] = T2.[Month]
ORDER BY T1.[Year], T1.[Month];




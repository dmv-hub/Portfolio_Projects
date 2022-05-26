SELECT * 
FROM PortfolioProject.dbo.Stores



SELECT * 
FROM PortfolioProject.dbo.Stores
ORDER BY 3 DESC, 5 DESC


-- Does Store Size correlate to Number of Items in Store
SELECT Store_Area, Items_Available
FROM PortfolioProject.dbo.Stores
ORDER BY Store_Area DESC

-- Is Store Size Linked with Daily Customer Increase?
SELECT Store_Area, Daily_Customer_Count
FROM PortfolioProject.dbo.Stores
ORDER BY Daily_Customer_Count DESC

--Does Store Area Correlate with Store Sales?
SELECT Store_Area, Store_Sales
FROM PortfolioProject.dbo.Stores
ORDER BY Store_Area DESC


--Do number of items available correlate with store sales?
SELECT Items_Available, Store_Sales
FROM PortfolioProject.dbo.Stores
ORDER BY Items_Available DESC

--Does Daily Customer Count impact Store sales?
SELECT Daily_Customer_Count, Store_Sales
FROM PortfolioProject.dbo.Stores
ORDER BY Daily_Customer_Count DESC



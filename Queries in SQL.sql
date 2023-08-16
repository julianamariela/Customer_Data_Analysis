
/*
This query will create a table of customer segments based on their yearly income level.
It will also help finding the most common educational qualification associated with each segment,
and determine if the number of children a customer has influences the volume of goods they purchase.
The query will then use the segments to understand the distribution by country and continent,
and if income is influencing revenue inflow to AHG.
*/

-- Creating table for Customer Segment
SELECT
 DC.[CustomerKey],
 CONCAT(DC.[FirstName],' ',DC.[MiddleName],' ',DC.[LastName]) AS FullName,
 DC.[Gender],
 VDP.[Age],
 DC.[MaritalStatus],
  CASE
    WHEN DC.[TotalChildren] =0 THEN '0'
    WHEN DC.[TotalChildren] >=1 AND DC.[TotalChildren] <=2 THEN '1-2'
    WHEN DC.[TotalChildren] >=3 AND DC.[TotalChildren] <=4 THEN '3-4'
    WHEN DC.[TotalChildren] >= 5 THEN '5+'
 END AS NrChildren,
 CASE
    WHEN DC.[YearlyIncome] >=10000 AND DC.[YearlyIncome] <=50000 THEN 'Segment A'
    WHEN DC.[YearlyIncome] >50000 AND DC.[YearlyIncome] <=100000 THEN 'Segment B'
    WHEN DC.[YearlyIncome] >100000 THEN 'Segment C'
 END AS YearlyIncomesSegment,
 DC.[EnglishEducation] AS EducationalQualification,
 DC.[GeographyKey],
 DG.[EnglishCountryRegionName] As Country,
  CASE
    WHEN DG.[EnglishCountryRegionName] ='Canada' THEN 'NorthAmerica'
    WHEN DG.[EnglishCountryRegionName] ='United States' THEN 'NorthAmerica'
    WHEN DG.[EnglishCountryRegionName] ='Germany' THEN 'Europe'
    WHEN DG.[EnglishCountryRegionName] ='France' THEN 'Europe'
    WHEN DG.[EnglishCountryRegionName] ='United Kingdom' THEN 'UK'
    WHEN DG.[EnglishCountryRegionName] ='Australia' THEN 'Australia'
 END AS Continent
 
FROM
 [dbo].[DimCustomer] AS DC
   INNER JOIN [dbo].[DimGeography] AS DG ON DC.[GeographyKey]=DG.[GeographyKey]
   INNER JOIN [dbo].[vDMPrep] AS VDP ON DC.[CustomerKey]= VDP.[CustomerKey]
 

 

/*The below query is divided into two parts, each focusing on retrieving data from a different sales channel. 
Both parts of the query fetch relevant information about the products, 
including their categories and subcategories, as well as sales-related metrics such as revenue, profit, and quantities. 
The query does not calculate the profit or profit-to-revenue ratio, as these calculations will be performed in Power BI.
*/

-- ResallerSales
SELECT
 FRS.[SalesOrderNumber],
 PR.[ProductKey],
 PR.[EnglishProductName] AS Product,
 PR.[ProductSubcategoryKey],
 PS.[EnglishProductSubcategoryName] as ProdSubcategory,
 PC.[EnglishProductCategoryName]as ProdCategory,
 FRS.[OrderDate] as ResellerOrderDate,
 FRS.[OrderQuantity] AS ResellerOrderQty,
 FRS.[TotalProductCost] AS ResallerCost,
 FRS.[UnitPrice] AS ResellerUnitPrice,
 FRS.[DiscountAmount] AS ResellerDiscount,
 FRS.[SalesAmount] AS ResellerRevenue,
 FRS.[TaxAmt] AS ResellerTax,
 FRS.[Freight] AS ResellerFreight
FROM
 [dbo].[DimProduct] AS PR
 INNER JOIN [dbo].[DimProductSubcategory] AS PS ON PR.[ProductSubcategoryKey] = PS.[ProductSubcategoryKey]
 INNER JOIN [dbo].[DimProductCategory] AS PC ON PS.[ProductCategoryKey] = PC.[ProductCategoryKey]
 INNER JOIN [dbo].[FactResellerSales] AS FRS ON PR.[ProductKey] = FRS.[ProductKey]

-- InternetSales
 SELECT
 FIS.[SalesOrderNumber],
 PR.[ProductKey],
 PR.[EnglishProductName],
 PR.[ProductSubcategoryKey], 
 PS.[EnglishProductSubcategoryName],
 PC.[EnglishProductCategoryName],
 FIS.[OrderDate] as InternetOrderDate,
 FIS.[OrderQuantity] AS InternetOrderQty,
 FIS.[UnitPrice] AS InternetUnitPrice,
 FIS.[DiscountAmount] AS InternetDiscount,
 FIS.[TotalProductCost] AS InternetCost,
 FIS.[SalesAmount] AS InternetRevenue,
 FIS.[TaxAmt] AS InternetTax,
 FIS.[Freight] AS InternetFreight,
 FIS.[CustomerKey]
FROM
 [dbo].[DimProduct] AS PR
 INNER JOIN [dbo].[DimProductSubcategory] AS PS ON PR.[ProductSubcategoryKey] = PS.[ProductSubcategoryKey]
 INNER JOIN [dbo].[DimProductCategory] AS PC ON PS.[ProductCategoryKey] = PC.[ProductCategoryKey]
 INNER JOIN [dbo].[FactInternetSales] AS FIS ON PR.[ProductKey] = FIS.[ProductKey]



 SELECT[SalesOrderNumber],[SalesOrderLineNumber]
 
 FROM[dbo].[FactInternetSales]

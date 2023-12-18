--Sales

Select *
From SQLToturial.dbo.order_detailsN

Select *
From SQLToturial.dbo.ordersN

-- Total Sales
Select CAST(Sum(sales) As decimal(13)) AS Sales
From SQLToturial.dbo.order_detailsN

-- orders
Select Count (Distinct orderId) As orders
from SQLToturial.dbo.order_detailsN

-- AVG Monthly Sales  
With ss as(
Select DATEPART(year,b.orderDate) as _year,DATEPART(month,b.orderDate) as _Month,Sum(a.sales)as _Sum
From SQLToturial.dbo.order_detailsN a
join SQLToturial.dbo.ordersN b
  On a.orderID =b.orderID
  
  Group by DATEPART(year,b.orderDate) ,DATEPART(month,b.orderDate)
  
  )
  select Round(AVG(_sum),0) AS AVG_Monthly_Sales
  From ss;

  -- Highest Monthly Sales

  Select FORMAT(b.orderDate,'MMM-yyyy') As Dates,Round(Sum(a.sales),0) AS _Sum_Sales
  From SQLToturial.dbo.order_detailsN A
  Join SQLToturial.dbo.ordersN B
    On A.orderID=B.orderID
	Group by FORMAT(b.orderDate,'MMM-yyyy') 
	Order by _Sum_Sales DESC
	

	-- LOWEST Monthly Sales
	Select FORMAT(orderDate,'MMM-yyyy') AS Dates,Round(Sum(B.sales),0) AS_Sum_Sales
	From SQLToturial.dbo.ordersN A
	join SQLToturial.dbo.order_detailsN B
	 ON A.orderID=B.orderID
	 Group By FORMAT(orderDate,'MMM-yyyy')
	 Order By Sum(B.sales) ASC 
	
	-- Hight Low Speard 
With SS AS(
	Select FORMAT(orderDate,'MMM-yyyy') As Dates,Sum(Sales) as _Sum_Sales
	From SQLToturial.dbo.order_detailsN A
	Join SQLToturial.dbo.ordersN B
	On A.orderID=B.orderID
	Group By FORMAT(orderDate,'MMM-yyyy')
)
Select
MAX(_Sum_Sales)-Min(_Sum_Sales)
From SS

	-- Sales By Month
    Select { FN MONTHNAME(orderDate)} AS 'Month',YEAR(orderDate) AS 'Year',Sum(Sales) AS Sales_monthly,Count(Distinct A.orderID) AS Orders
	From SQLToturial.dbo.order_detailsN A
	Join  SQLToturial.dbo.ordersN B
	On A.orderID=B.orderID
	Group By { FN MONTHNAME(orderDate)},MONTH(orderDate),YEAR(orderDate)
	Order By YEAR(orderDate),Month(orderDate)
	
--Shipping

--Shipping Cost

    Select CAST(Sum(Freight)AS money) AS _Freight
    From SQLToturial.dbo.ordersN

--Avrage Cost Per Orders (Freight)
    Select CAST(AVG(Freight)AS decimal(2)) As Avr_Fright
	From SQLToturial.dbo.ordersN

-- Highest Monthly Shipping

  Select  FORMAT(shippedDate,'MMM-yyyy') AS DATES,Round(AVG(Freight),0) AS FR
  From SQLToturial.dbo.ordersN
  Group by FORMAT(shippedDate,'MMM-yyyy')
  Order By FR DESC

-- Lowest Monthly Shipping

   Select FORMAT(ShippedDate,'MMM-yyyy') As Dates,Round(AVG(Freight),0) AS FR
   From SQLToturial.dbo.ordersN
   Group By Format(ShippedDate,'MMM-yyyy')
   Order by FR ASC
 
 -- Hight Low Speard 
 With SP AS(
  Select FORMAT(shippedDate,'MMM-yyyy') AS Dates,Avg(freight) AS FR
  From SQLToturial.dbo.ordersN
  Group By FORMAT(shippedDate,'MMM-yyyy')
  )
  Select CAST(Max(FR)-MIN(FR) AS Decimal(4,2)) AS Speard
  From SP 

  -- Shipping Cost Per Order By Month
  Select {FN MONTHNAME(ShippedDate)} AS 'Month',Year(ShippedDate) AS 'Year',Round(AVG(Freight),0) AS 'FR'
  From SQLToturial.dbo.ordersN
  Group by {FN MONTHNAME(ShippedDate)},MONTH(shippedDate),YEAR(shippedDate)
  Order By YEAR(shippedDate),MONTH(shippedDate)

  -- Customers
Select * From SQLToturial.dbo.customersN
Select * From SQLToturial.dbo.ordersN
Select * From SQLToturial.dbo.order_detailsN


  --
  --Add New Colmun 
  Alter Table OrdersN Add  CompanyName Nvarchar(255);
  --Update Column From Table CustomerId
  Update SQLToturial.dbo.ordersN
    Set CompanyName=B.companyName
    From SQLToturial.dbo.ordersN A
    Join SQLToturial.dbo.customersN B
    On A.customerID=B.customerID
    Where A.customerID=B.customerID

  -- Top 3 Company Sales
  
  Select Top(3) A.CompanyName,CAST(Sum(Sales)AS money) AS Total,ROUND(sum(sales) / Sum(Sum(Sales)) over(),4)*100 As Total_of_Percentage
  From SQLToturial.dbo.ordersN A
  Join SQLToturial.dbo.order_detailsN B
  on A.orderID=B.orderID
  Group by A.CompanyName
  order By Total_of_Percentage DESC
  
  -- Total Of 3 Company Sales And Percentage
   With Top3 AS(
  Select Top(3) A.CompanyName,CAST(Sum(Sales)AS money) AS Total,ROUND(sum(sales) / Sum(Sum(Sales)) over(),4)*100 As Total_of_Percentage
  From SQLToturial.dbo.ordersN A
  Join SQLToturial.dbo.order_detailsN B
  on A.orderID=B.orderID
  Group by A.CompanyName
  order By Total_of_Percentage DESC
  ) 

  Select Cast(Sum(Total)AS decimal(8,2) ) AS Sales ,Round(Sum(Total_of_Percentage),4) As '%Of_Total'
  From Top3
  

  --Customer By month
  Select {FN MONTHNAME(orderDate)} AS Month,Year(orderDate) AS Year,COUNT(CustomerId)As Orders
  From SQLToturial.dbo.ordersN
  Group By {FN MONTHNAME(orderDate)},Month(orderDate),YEAR(OrderDate)
  order By Year(OrderDate),MONTH(OrderDate)
  

  --Product
  Select * From SQLToturial.dbo.productsN
  Select * From SQLToturial.Dbo.order_detailsN
  Select * From SQLToturial.dbo.ordersN

 --Top 3 Prooduct Sales
 Select TOP(3) productName,Sum(Sales) AS Sal,Round(SUM(sales) / Sum(Sum(Sales))Over(),4)*100 AS '%OF_Total_Sales'
 From SQLToturial.Dbo.productsN A
 Join SQLToturial.Dbo.order_detailsN B
 On A.productID=B.productID
 Group By productName
 Order By Sal DESC

 --Top 3 Product Sales And Percentage
 With TopProduct AS(
   Select Top(3) productName,Sum(Sales)AS Sal,Round(Sum(Sales) / Sum(Sum(Sales)) over(),4)*100 As '%Of_Total_Sales'
   From SQLToturial.dbo.productsN A
   Join SQLToturial.Dbo.order_detailsN B
   on A.productID=B.productID
   Group by productName
   Order By Sal DESC
   )
   Select Sum(Sal) AS Top_3_Product_Sales,Sum([%Of_Total_Sales]) AS '%OF Total Percentage'
   From TopProduct 


   -- Product By Month
   Select {FN MONTHNAME(OrderDate)} AS MONTH ,YEAR(orderDate)AS Year,Count(DISTINCT productID)As Product
   from SQLToturial.dbo.order_detailsN A
   Join SQLToturial.Dbo.ordersN b
   On A.orderID=B.orderID
   Group by {FN MONTHNAME(OrderDate)},MONTH(OrderDate),Year(OrderDate)
   Order by YEAR(orderDate),Month(OrderDate)

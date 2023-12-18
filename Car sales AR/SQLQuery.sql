Select*
From SQLToturial.dbo.cars

--Car Sold
 Select 
 Year(Date) AS _Year,
 COUNT([Company]) AS Cars_Sold
 From SQLToturial.dbo.cars
 Group by Year(Date)

--Grwoth--
 ;with YTY_Cars_Sold As
 (
   Select
   YEAR(date) as _Year,
   Count(Company) As Cars_Sold
   from SQLToturial.dbo.cars
   Group by YEAR(date)
  ),
     YTY_Prev_Sold As
     (
      Select
      _Year,
      Cars_Sold,
      LAG(Cars_Sold,1,Cars_Sold)Over(Order by _Year) Priv_Sold
      From YTY_Cars_Sold
     )
      select
      PS.*,
      ConCat(CAST(PS.Cars_Sold-PS.Priv_Sold AS Money) /PS.Priv_Sold*100 ,'%') As Growth
      From YTY_Prev_Sold PS

	  --Avg PerCar
	  Select Year(date)As date,Cast(AVG([Price ($)])AS decimal(8,2)) AS Sales
	  From SQLToturial.dbo.cars
	  Group By Year(date) 
	  --Growth
	  With Gr AS ( 
	  Select YEAR(Date) As Date,Cast(Avg([Price ($)])AS Decimal(8,2)) As Sales
	  From SQLToturial.dbo.cars
	  Group by Year(Date)
	  ),
	   Gr1 AS(
	  Select *,Lag(Sales,1,Sales)over(order by Date) As Prive_sales
	  From Gr
	  )
	  Select *,Concat(CAST((Sales - Prive_sales )/Prive_sales*100 AS decimal(12,2)),'%')AS YTY_Growth
	  From Gr1

--Sales
Select Year(Date)As Date,Sum([Price ($)])AS Total
From SQLToturial.dbo.cars
	Group by Year(Date)

	--Growth
	with Prive_Sales As(
	Select Year(Date) As Date,Sum([Price ($)]) As Sales
	From SQLToturial.dbo.cars
	 Group by Year(Date)
	 ),
	 Growth AS(
	 Select *,LAG(Sales,1,Sales)over(order by Date) As Sal_Priv
	 From Prive_Sales
	 )
	 Select *, Concat(Cast((Sales-Sal_Priv)/Sal_Priv*100 As Decimal(12,2)),'%')As YTY_Growh
	 From Growth


	 --Sales By Color
	 Select  Year(Date) AS Year,Color,Sum([Price ($)]) As Sales
	 ,(Select Sum([Price ($)]) From SQLToturial.dbo.cars) AS Total_Sales
	 From SQLToturial.dbo.cars
	 Group by Year(Date),Color
	 Order By Year(Date),Color

	 --Sales By type Body Style
	 Select Year(Date) As Year,[Body Style],Sum([Price ($)]) As Sales
	 ,(Select Sum([Price ($)]) From SQLToturial.dbo.cars) As Total_Sales
	 From SQLToturial.dbo.cars
	 Group by Year(Date),[Body Style]
	 Order by Year(Date),[Body Style]

	 --Weekly Sales
	 Select Year(Date) As Year
	 ,DatePart(WEEK,Date) As Weekly
	 ,Sum([Price ($)]) As Sales
	  From SQLToturial.dbo.cars
	  Group by Year(date),DatePart(WEEK,Date)
	  Order By Year(date),DatePart(WEEK,Date)
	

	--Details 2021
	Select Company
	,Count(Company)AS Car_Sold
	,Sum([Price ($)])AS Sales 
	,Avg([Price ($)]) As AVG_Per_Car
	,Concat (Sum([Price ($)])/(select Sum([Price ($)]) From SQLToturial.dbo.cars
	Where Year(Date)='2021')*100 ,'%') AS '%Of_Total'
	From SQLToturial.dbo.cars
	where YEAR(Date)='2021'
	Group by Company
	Order by 2 DESC

	--Sales by Region And Transmission 2021
	Select Year(Date) As Date
	,Dealer_Region
	,Transmission
	,Sum([Price ($)]) AS Sales
	From SQLToturial.dbo.cars
	Group by YEAR(Date),Dealer_Region,Transmission
	order By YEAR(Date),Dealer_Region,Transmission 
    
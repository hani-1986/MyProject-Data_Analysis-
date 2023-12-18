Select *
From SQLToturial.dbo.Sales$

--Revenu
Select Cast(Sum(LineTotal)As decimal(12,0)) As #Revenu
From SQLToturial.dbo.Sales
where Status in('Approved','In Process','Shipped')

--Total Tax
Select Cast(Sum(TaxAmt)As decimal(12,0)) As #Total_Tax
From SQLToturial.dbo.Sales
where Status in('Approved','In Process','Shipped')

--Total Freight
Select Cast(Sum(Freight)As decimal(12,0)) As #Total_Freight
From SQLToturial.dbo.Sales
where Status in('Approved','In Process','Shipped')

--Total Due
Select Cast(Sum(TotalDue)As decimal(12,0)) As #Total_Due
From SQLToturial.dbo.Sales
where Status in('Approved','In Process','Shipped')

--Order Days
Select {FN DAYNAME(DUEDATE)}AS Days,Count(DISTINCT OrderID)AS Orders
From SQLToturial.dbo.Sales$
Group by DateNAME(DW,DueDate)
order By 2 DESC

--Order Monthly
Select Format(DueDate,'MMM')As Monthly,Count(DISTINCT OrderID)AS Orders
From SQLToturial.dbo.Sales$
where Status in('Approved','In Process','Shipped')
Group by Format(DueDate,'MMM') 
Order By CASE When Format(DueDate,'MMM')  = 'Jan' then 1
When Format(DueDate,'MMM')  = 'Feb' then 2
When Format(DueDate,'MMM')  = 'Mar' then 3
When Format(DueDate,'MMM')  = 'Apr' then 4
When Format(DueDate,'MMM')  = 'May' then 5
When Format(DueDate,'MMM')  = 'Jun' then 6
When Format(DueDate,'MMM')  = 'Jul' then 7
When Format(DueDate,'MMM')  = 'Aug' then 8
When Format(DueDate,'MMM')  = 'Sep' then 9
When Format(DueDate,'MMM')  = 'Oct' then 10
When Format(DueDate,'MMM')  = 'Nov' then 11
When Format(DueDate,'MMM')  = 'Dec' then 12
Else Null end

--orders

Select Status,Count(DISTINCT OrderID) AS Status
From SQLToturial.dbo.Sales$
group by Status
Order By 2 DESC


--Revenu By ProductSubCategory
Select DISTINCT ProductSubCategory,Sum(LineTotal) AS Total
, CONCAT(Sum(LineTotal)/( Select Sum(lineTotal)
From SQLToturial.dbo.Sales$
where Status in('Approved','In Process','Shipped'))*100,'%')AS '%OF_Total'
From SQLToturial.dbo.Sales$
where Status in('Approved','In Process','Shipped')
Group by ProductSubCategory
order By 2 DESC


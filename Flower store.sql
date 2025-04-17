create Database Flowers


create schema Contact
create schema [Order]
create schema Stock

--The first table: Stock.Flowers created by the graphical interface

Create table Contact.Customers (
CustomerID int Not null identity (1,1),
FirstName VARCHAR (20) NOT NULL,
LastName VARCHAR (20) NOT NULL,
Address VARCHAR (20) NULL,
Email VARCHAR (20) NULL,
JoinDate SMALLDATETIME NOT NULL)

Create table [Order].Orders (
OrderID int Not null identity (1,1),
OrderDate SMALLDATETIME NOT NULL,
CustomerID int NOT NULL,
FlowerID int NOT NULL,
Quantity INT NOT NULL)


--Views
Create view v_order_details
as
Select O.[OrderID] ,O.[OrderDate],O.[CustomerID], CONCAT(C.[FirstName],' ',C.[LastName]) AS [Customer Name],o.[FlowerID],f.[FlowerName]
From [Order].[Orders] o inner join contact.customers c on o.customerID = C.CustomerID INNER JOIN Stock.Flowers F on o.FlowerID = F.flowerID

alter view v_top3
as
Select top 3 o.FlowerID, count(o.flowerid) as num, f.FlowerName, SUM(o.[Quantity]) as Quantity
from [Order].[Orders] o inner join Stock.Flowers F on o.FlowerID =f.FlowerID
group by o.Flowerid,f.FlowerName
order by num desc

--View was changed to top 5 by the graphical interfce

--Indexes: 
SET STATISTICS IO ON
select count(*) as [No. Of Orders]
from [Order].[Orders]
where customerid =1
Create clustered index i_orderID_orders on [Order].[orders]([CustomerID])

select [LastName] from [Contact].[Customers] where [Email] = 'sapb@gmail.com'
create index i_email_cust on [Contact].[Customers] ([Email])

SELECT * FROM [Order].[Orders] WHERE [OrderID] = 10

--Add PK constraint to create index on the OrderID column
Alter table [Order].[Orders] add constraint PK_order_id Primary key ([OrderID])

SELECT * FROM [Order].[Orders] WHERE [FlowerID] = 8
Create index i_flower_id on [Order].[Orders] ([FlowerID])

select [LastName],[Email] from [Contact].[Customers] where [Email] = 'sapb@gmail.com'
Create index ix_ln_email_customer on [Contact].[Customers] ([LastName],[Email])

select [FirstName],[LastName],[Email] 
from [Contact].[Customers] 
where [LastName] = 'x' and [FirstName] = 'y'

--index was changed by the graphical interface

--Use Northwnd DB
use NORTHWND 
go
SELECT CompanyName, Country, ShipCountry, COUNT(*) Total_Orders
from Orders O join Customers C on o.CustomerID=c.CustomerID
WHERE O.ShipCountry = 'Argentina' and c.Country = 'Argentina'
Group by CompanyName, Country, ShipCountry
Having count(*) > 5

Create index ix_cty_customers on [dbo].[Customers]([Country]) include ([CompanyName])
Create index ix_ship_cty_orders on [dbo].[Orders] ([ShipCountry])
Create index ix_flwName on [Stock].[Flowers] ([FlowerName])
--Index was changed to custtomerID column and include on the Ship Country column

--Procedures: 

alter Procedure Add_order 
@orderid int output,
@date date,
@cust_id int, 
@flower_id int,
@q int
as
IF @flower_id NOT IN (SELECT [FlowerID] FROM [Stock].[Flowers]) 
BEGIN PRINT 'The flower id you have inserted does not exist! please use correct number' 
set @orderid = -1
select @orderid END
IF  @cust_id NOT IN (SELECT [CustomerID] FROM [Contact].[Customers]) 
BEGIN PRINT 'The Customer ID you have inserted does not exist! please use correct number'  Rollback END
else
Begin 
 Insert into [Order].[Orders] ([OrderDate],[CustomerID],[FlowerID],[Quantity])
 values (@date,@cust_id, @flower_id,@q)
 set @orderid = @@IDENTITY
 select @orderid output
END
go

Declare @orderid int, @v_orderid int, @v_date date, @v_cust_id  int, @v_flower_id int, @v_q  int
SET @v_orderid= 0
SET @V_date ='20140220'
SET @v_cust_id  = 108
SET @v_flower_id = 8
SET @v_q = 1

exec Add_order 
  @orderid  = @v_orderid output,  @date = @v_date,  @cust_id = @v_cust_id ,  @flower_id = @v_flower_id ,  @q = @v_q 
 Print 'New order id: ' + @v_orderid 
 go



 --Functions: 
 alter function fn_age(@birthdate date )
 Returns int
 as
 BEGIN
	 Declare @age int
	 Select @age = cast(datediff(year,@birthdate, getdate()) as int)
	 Return @age
 END

 select [EmployeeID],[LastName],[FirstName],dbo.fn_age ([BirthDate]) as age
 from NORTHWND.dbo.Employees


 Create function fn_flower_name (@f_id int)
 Returns varchar (20)
 AS 
 BEGIN
	Declare @f_name varchar (20)
	if @f_id IN (SELECT [FlowerID] FROM [Stock].[Flowers])
	BEGIN
	Select @f_name = [FlowerName]
	from [Stock].[Flowers]
	where [FlowerID] = @f_id END
	ELSE begin
	SET @f_name  = 'N/A' end
	Return @f_name
END

Select[OrderID], dbo.fn_flower_name ([FlowerID]) as [Flower Name] from [Order].[Orders]

Select dbo.fn_flower_name ([FlowerID]) as [Flower Name], count([OrderID]) as Amount_of_ord, sum([Quantity]) as Quantity
from [Order].[Orders]
group by [FlowerID]

--In line TVF
Create Function fn_customer_orders_TVF (@Cust_id int)
Returns Table 
AS 
Return (
	Select top 20 CONCAT(c.[FirstName], ' ',c.[LastName]) as [Customer Name], O.[OrderID]
	From [Contact].[Customers] c inner join [Order].[Orders] o ON c.[CustomerID] = o.[CustomerID]
	where c.[CustomerID] = @Cust_id 
	order by [OrderDate]
	)

SELECT * FROM DBO.fn_customer_orders_TVF(7)

--Turning into Multi-statement table valued function
DROP FUNCTION DBO.fn_customer_orders_TVF
GO

aLTER function fn_customer_orders_MSTVF (@Cust_id int)
Returns @MSTVF Table (
					Name_customer VARCHAR (25),
					Orders int,
					OrdDate smalldatetime,
					Flwr_Name varchar(25),
					Quantity int)
AS
BEGIN
IF  (select count(*) from [Contact].[Customers] where [CustomerID]=@Cust_id) = 0 
	Begin
	INSERT INTO @MSTVF (Name_customer) values ( 'No such customer') end

Else begin	INSERT INTO @MSTVF 
	select  CONCAT(c.[FirstName], ' ',c.[LastName]) as [Customer Name], O.[OrderID], o.[OrderDate], f.[FlowerName], o.[Quantity]
	From [Contact].[Customers] c inner join [Order].[Orders] o ON c.[CustomerID] = o.[CustomerID] join
			[Stock].[Flowers] as f on o.flowerID = f.[FlowerID]
	where c.[CustomerID] = @Cust_id 
	order by [OrderDate] END
	
    Return 
END


--Constraints
Alter table [Contact].[Customers] ADD CONSTRAINT PK_customerID Primary key ([CustomerID])
Alter table [Stock].[Flowers] ADD CONSTRAINT PK_flowerID Primary key ([FlowerID])

Alter table [Order].[Orders] ADD constraint FK_OrdCust Foreign key ([CustomerID]) references [Contact].[Customers] ([CustomerID])
Alter table [Order].[Orders] ADD constraint FK_OrdFlow Foreign key ([FlowerID]) references [Stock].[Flowers] ([FlowerID])

Alter table [Stock].[Flowers] ADD CONSTRAINT uq_flName UNIQUE	([FlowerName])
Alter table [Contact].[Customers] ADD CONSTRAINT ck_email CHECK ([Email] LIKE '%@%')

Alter table [Order].[Orders] add constraint df_date DEFAULt (getdate()) for [OrderDate] 
Alter table [Order].[Orders] add constraint  df_qty DEFAULt (1) for [Quantity]
Alter table [Contact].[Customers] add constraint df_joinDate  DEFAULt (getdate()) for [JoinDate]

--Trigger
create trigger tg_flower
ON [Stock].[Flowers]
AFTER DELETE
AS 
 BEGIN 
 Print 'You are not allowed to delete this record'
 Rollback 
 end
 


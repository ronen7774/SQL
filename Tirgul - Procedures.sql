--Procedures

--1
alter PROCEDURE usp_prod_cat 
@prod_name Varchar (25)
AS 
BEGIN
Declare @cat_name varchar (15)

SELECT @cat_name = [CategoryName]
FROM Products P INNER JOIN Categories C
ON p.CategoryID = c.CategoryID
where ProductName = @prod_name
print @prod_name
print @cat_name
END

exec usp_prod_cat @prod_name = 'Chai'

--2
Alter PROCEDURE usp_order
@emp int
AS 
BEGIN


SELECT o.[OrderID], o.EmployeeID
FROM Orders O INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
where o.EmployeeID = @emp

END

exec usp_order @emp =1

--3
go
alter procedure usp_products
@cat_id int
as
BEGIN
SELECT [ProductID],[ProductName],[QuantityPerUnit], CategoryID
FROM Products
WHERE CategoryID = @cat_id
END

--4
go
create procedure usp_employees
@date date
as
BEGIN
SELECT [EmployeeID], [LastName], [BirthDate]
FROM Employees
WHERE [BirthDate] > @date
END

--5
go
alter procedure usp_supplier
@sup_id int
as
declare @v_counter int
begin
select @v_counter = count(*)
from Products
where [SupplierID] = @sup_id
IF @v_counter > 20
begin
print 'More than 20'
end
Else
print 'Less than 20'
end 
go

--6
Go 
Create procedure usp_compare
@prd_id int
as
declare @v_comp int,
@v_average int
begin
select @v_comp = [UnitPrice], @v_average = (select AVG([UnitPrice]) from Products where @prd_id = [ProductID]
group by [CategoryID])
from Products

IF @v_comp > @v_average
begin
print 'Higher than AVG'
end
Else
print 'Lower than AVG'
end 
go

--7
GO
CREATE PROCEDURE usp_order_P 
@emp_id int
AS
BEGIN
SELECT COUNT (*) AS Num_of_ord
FROM Orders
where EmployeeID = @emp_id
end

--8
GO
alter PROCEDURE usp_order_P 
@emp_id int
AS
declare @result int
BEGIN
SELECT @result = COUNT (*)
FROM Orders
where EmployeeID = @emp_id
PRINT @emp_id
print @result

end
--9
alter PROCEDURE usp_order_P 
@emp_id int
AS
declare @result int
BEGIN
SELECT @result = COUNT (*)
FROM Orders
where EmployeeID = @emp_id

if @result > 40
begin
PRINT @emp_id
print @result
end
else 
print 'Under 40'
end

--10
alter PROCEDURE usp_order_P 
@emp_id int
AS
declare @result int

BEGIN

SELECT @result = COUNT (*)FROM Orders where EmployeeID = @emp_id

print @result
if @result > 100
	begin
		PRINT 'Num of orders = ' + cast(@result as VARCHAR(10)) + ' '
		+ replicate ('*',@result/10)

end
else 
print 'Under 40'
end

--11
go
alter procedure usp_prod_id
(@prod_id int,
@prod_name VARCHAR(50) OUTPUT)
AS
BEGIN
	SELECT @prod_name  = [ProductName]
	FROM Products
	WHERE [ProductID]= @prod_id
END
go
declare @prod_name varchar (50)
EXEC usp_prod_id 5 ,@prod_name  output

print @prod_name

--12
go
Create PROC usp_emp 
@date date, 
@fn varchar (10) output,
@ln varchar (20) output,
@bd date output
as
BEGIN
	Select  @fn = [FirstName],@ln =[LastName], @bd=[BirthDate]
	from Employees
	where [BirthDate] > @date 
END

Declare @first_name varchar(10), @last_name varchar (20), @birthdate date
exec usp_emp  @date ='19600101', @fn = @first_name output, @ln = @last_name output, @bd = @birthdate output
print @first_name + ' ' +@last_name 

--13
go
Create procedure prod_det_details
@prod_name varchar(40) output,
@cat_name varchar(15) output,
@prod_id int 
as
Set @prod_id = 6
Begin
	Select @prod_name = [ProductName], @cat_name = [CategoryName]
	from products p inner join Categories c on p.CategoryID = c.CategoryID
	where [ProductID] = @prod_id
end 

--14
GO
aLTER PROC prod_det_details
@prod_name varchar(20) output,
@cat_name varchar(15) output,
@prod_id int 
as
Begin
	Select @prod_name = [ProductName], @cat_name = [CategoryName]
	from products p inner join Categories c on p.CategoryID = c.CategoryID
	where [ProductID] = @prod_id
end 

--15
go 
Create proc usp_top_price
@prod_id int OUTPUT, 
@prod_name varchar(20) OUTPUT, 
@UNIT_PRICE INT OUTPUT
as
Begin
	Select  @prod_id = [ProductID], @prod_name=[ProductName], @UNIT_PRICE = [UnitPrice]
	from Products
	WHERE EXISTS (Select  TOP 10*
	from Products
	order by [UnitPrice] desc)
	
end

--15fix
go 
alter proc usp_top_price

as
Begin
	Select  top 10 [ProductID],[ProductName], [UnitPrice]
	from Products
	order by [UnitPrice] desc
	
end

--16
go 
alter proc usp_top_price
@n int 
as
Begin
	Select  top (@n) [ProductID],[ProductName], [UnitPrice]
	from Products
	order by [UnitPrice] desc
	
end

--17
go
alter PROC usp_emp_det
@emp int
as 
Declare @last_name varchar (20),
@bd date,
@city varchar (20) 
IF (select [LastName] from employees where @emp = [EmployeeID]) LIKE '%a%'
BEGIN
Select @last_name=[LastName],@bd = [BirthDate],@city=[City]
FROM Employees
print @last_name+ ' '+ cast(@bd as varchar (10)) + ' ' + @city
END 
ELSE PRINT 'Employee Number: ' + cast(@emp as varchar(2))+', has no letter A'

--18
go
Create PROC usp_cust_det
@cust_id varchar (5)
as
BEGIN
Select [CompanyName], [Country], [Address]
from Customers
where @cust_id = [CustomerID]
end

--19
go
alter PROC usp_cust_det
@cust_id varchar (5)
as
Declare @cty varchar (15), 
@c_name varchar (40),
@address varchar (60)
begin
Select @c_name = [CompanyName], @cty=[Country], @address = [Address]
from Customers
where @cust_id = [CustomerID]
if (select country from Customers where @cust_id = [CustomerID]) = 'Germany'
BEGIN print 'The customer is German' END
else IF (select country from Customers where @cust_id = [CustomerID]) = 'Mexico'
BEGIN print 'The customer is Mexican' END
else BEGIN print  @c_name SELECT @c_name,@address, @cty END

end
--20
GO 
CREATE PROC usp_ord_det
@cust_id varchar (5)
,@num_of_ord int output

as
begin
select @num_of_ord = COUNT([OrderID])
from Orders
where @cust_id = [CustomerID]

if @num_of_ord > 10 
begin print 'Num. of order for customer: ' + @cust_id + ', is higher than 10' end
else begin select @cust_id, @num_of_ord end
end
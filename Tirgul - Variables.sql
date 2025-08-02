--1
Declare @var1 varchar(12) = 'Hello', @var2 varchar(12) = 'World'
Select @var1 +' '+@var2

--2 
Declare @x varchar(25) = 'The current Date is:', @date date = getdate()
Select concat(@x, @date)

--3
Declare @emp_5 int,
@emp_5fn varchar (25),  
@emp_5ln varchar (25),
@emp_5bd datetime 
Select @emp_5 = EmployeeID,
@emp_5fn = FirstName, 
@emp_5ln =LastName,
@emp_5bd = BirthDate
FROM Employees
WHERE EmployeeID = 5
Select @emp_5
Select @emp_5fn +' '+@emp_5ln
Select @emp_5bd

 

 --4
 Declare @c_name varchar (25), @city varchar (15)
 SELECT @c_name = [CompanyName], @city = [City]
 from Suppliers
 where [SupplierID] =2
 print @c_name
 print @city

 --5
 Declare @prod_id int,
		@prod_name varchar(25),
		@prod_cat varchar(25)
	BEGIN
	Set @prod_id = 1
		SELECT @prod_name = P.ProductName,
		@prod_cat = C.CategoryName
		FROM Products P INNER JOIN Categories  C ON P.Categoryid = C.categoryid
		WHERE ProductID = @prod_id
		print @prod_name + ' '+@prod_cat
		--print @prod_cat
END


--6
 Declare @cust_id varchar(5),
		@company_name varchar(40),
		@comp_city varchar(15)
	BEGIN
	Set @cust_id= 'ANATR'
		SELECT @company_name = CompanyName,
		@comp_city = City
		FROM Customers
		WHERE CustomerID = @cust_id
		print @company_name
		print @comp_city
END

--7
 Declare @cat_id int,
		@Average int
	BEGIN
	Set @cat_id= 5
		SELECT @cat_id = [CategoryID], @Average =AVG([UnitPrice])
		FROM Products
		WHERE [CategoryID] = @cat_id
		group by [CategoryID]
		print @Average
END

--8
go
Declare @prod_id int,
		@prod_name varchar(40), 
		@supplier_name varchar (40)	
	Begin	
		Set @prod_id = 1
		Select @prod_name = p.[ProductName], @supplier_name = s.CompanyName
		from Products P inner join Suppliers S on p.SupplierID =s.SupplierID
		where ProductID = @prod_id
		print @prod_name 
		print @supplier_name
END

--9
GO
Declare @cust_id varchar(5),
		@num_of_oreders int
	Begin	
		Set @cust_id = 'BOLID'
		Select @num_of_oreders = COUNT([OrderID])
		from Orders O inner join Customers C on o.CustomerID = C.CustomerID
		where C.CustomerID = @cust_id
		print @cust_id 
		print @num_of_oreders
END


--Case
--1
go
Declare @v_en varchar(25), 
@len int,
@res varchar (50)
BEGIN
select @v_en =lastname
from Employees
where EmployeeID = 4

set @len = LEN(@v_en)

set @res = ( CASE
      WHEN @len > 5 THEN @v_en +' '+ 'You have a very long last name, change it!'
	  ELSE 'You have a normal name, change it'
	  END)
PRINT @res
END

--2
go
Declare @emp_id int, 
@sales int,
@stat varchar (50)

set @emp_id = 9
select @sales = sum(OD.[UnitPrice] * OD.[Quantity])
from Employees e inner join orders O ON E.EmployeeID = O.EmployeeID 
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
where @emp_id = e.EmployeeID

set @stat = ( CASE
      WHEN @sales < 100000 THEN 'Bad sales'
	  WHEN @sales < 200000 THEN 'Normal sales'
	  ELSE 'Good sales'
	  END)
PRINT @stat + ' ' + cast(@sales as varchar (20))

--IF...ELSE
--1
Declare @p_id int,
@price int

Set @p_id = 4 --Any product ID

SELECT @price = UnitPrice 
from Products
where  ProductID = @p_id

IF @price > 20 
BEGIN
PRINT 'Higher than 20'
end
IF @price < 20
BEGIN
PRINT 'Lower than 20'
end
IF @price = 20
BEGIN
print 'Equal to 20'
end

--2
Declare @cat_id int,
@ustock int

Set @cat_id = 4 --or any other cat_id

Select @ustock = sum(UnitsInStock)
from Products
where CategoryID = @cat_id
print @ustock
IF @ustock > 200
BEGIN
PRINT 'Higher than 200'
END
else if @ustock < 200
begin
print 'Smaller than 200'
end
else 
begin
print'equal to 200'
end

--3
go
Declare @cat_name varchar (15),
@average int

Set @cat_name = 'Condiments' --or any other cat name

select @average = AVG([UnitPrice]) 
from Products p inner join Categories c on p.CategoryID=c.CategoryID
where c.CategoryName = @cat_name
print @average
IF @average > 20 
begin
print 'Greater than 20'
end
else if @average < 20
begin print 'lower than 20'
end
else begin print 'Equal to 20' end

--4
Declare @v_price money

Select @v_price = UnitPrice
from Products
where ProductID = 9
print @v_price
If @v_price > 50 
begin print 'The price is above market value' end
else begin select 'The price is beloew market value' end

--5
go
Declare @prod_name varchar (15),
@price money
SET @prod_name = 'Change'

SELECT @price = UnitPrice
FROM Products
where ProductName = @prod_name

IF @price <20 
BEGIN 
SEt @price = @price*1.1 
print 'New price is ' + cast(@price as varchar(15))
END

else IF @price >= 20 AND @price <40
BEGIN 
SEt @price = @price*1.2 
print 'New price is ' + cast(@price as varchar(15))  end

else if @price > 40
begin 
SEt @price = @price*1.5 
print 'New price is ' + cast(@price as varchar(15))  end


--Whlie
--1
Declare @num int = 1
while @num < 11
BEGIN
IF @num % 2 = 0 
	 begin print cast(@num as varchar (2)) + ' Dual' end
ELSE begin print cast(@num as varchar (2)) + ' Odd'  end
	SET @num=@num+1
	end

--2 
go
Declare @num int = 1
while @num < 7 
BEGIN
	print @num 
	set @num = @num +1
	end
	print  '7 is a bad luck number!'

--3
go
Declare @num int = 1
while @num <= 10 
BEGIN
	print @num set @num = @num +1
	if @num < 7 continue
	else  print cast(@num as varchar(2)) + ' The number is greater than 7' 
	end
	
--4
Declare @lastname varchar (10),
@emp_id int = (select MIN(employeeid)from Employees),
@last_emp int = (select MAX(employeeid) from Employees)
while @emp_id <= @last_emp

BEGIN 	Select @lastname=LastName from Employees where EmployeeID = @emp_id	
	IF @lastname LIKE '%E%'
	BEGIN
	PRINT @lastname
	END
	ELSE PRINT @lastname + '; The last name does not contain the letter E'
	Set @emp_id = @emp_id+1
	
END



--View

--1
Create view v_prod as
Select [ProductName], [UnitPrice], [UnitsInStock], [UnitsOnOrder]
from Products

select * from v_prod
where [UnitsInStock] <=10

--2
Create view v_OrderCustDetails as
Select c.CompanyName, COUNT(o.orderID) as NumOfOrd 
from Customers C inner join Orders O on c.customerid = o.CustomerID
group by c.CompanyName

--3
select top 10 CompanyName from v_OrderCustDetails
order by NumOfOrd desc

--4
Create view V_prod_stock as
select [ProductID], [ProductName], [UnitPrice] , ([UnitsInStock] - [UnitsOnOrder]) as Updstock
from Products
where UnitPrice >= 20

select * from V_prod_stock

--User defined transactions
--1
alter function dbo.emp_ln( @emp_id int)
Returns Varchar(20)
as
begin 
Declare @ln Varchar(20)
	select @ln = [LastName]
	from Employees
	where @emp_id = [EmployeeID]
	return @ln
end

--2
Create function dbo.prod_name(@prod_id int)
Returns Varchar(40)
as
begin 
Declare @p_name Varchar(40)
	select @p_name = [ProductName]
	from Products
	where @prod_id = [ProductID]
	return @p_name
end

--3
create function dbo.emp_email(@emp_id int)
Returns Varchar(60)
as
begin 
Declare @ln Varchar(20), @fn varchar(20)
	select  @fn = [FirstName],@ln = [LastName]
	from Employees
	where @emp_id = [EmployeeID]
	return @fn+@ln+'@gmail.com'
end

--4
Create function dbo.cus_phone (@id nchar(5))
Returns Varchar(20)
as
begin 
Declare  @phone varchar(20)
	select  @phone= [Phone]
	from Customers
	where @id = [CustomerID]

	set @phone = replace(@phone, '-','')
	set @phone = replace(@phone, '(','')
	set @phone = replace(@phone, ')','')
	set @phone = replace(@phone, ' ','')

	return  @phone
end

--5
create function dbo.prodcheck(@prod_id int)
Returns bit
as
begin 
declare @result int, @v_check int
	select @v_check = [UnitPrice]
	from Products 
	where @prod_id = [ProductID] 	
if @v_check is null 
          set @result = 0 
		  else set @result = 1
		return  @result
end
go 


create proc usp_prod_price (@prod_id int)
as
Declare @v_check int
	BEGIN
	SET @v_check = dbo.prodcheck(@prod_id)
	if @v_check =1 
	begin 
	update Products
	set [UnitPrice] = [UnitPrice] +1
	where @prod_id = [ProductID]
	end
	else print 'No such product!'
end

--6
alter function dbo.stam (@name varchar (25))
Returns varchar (300)
as

begin
Declare @length int, 
	@counter int ,
	@v_partname varchar(300)
	set @length = LEN(@name)
	set @v_partname =''
	set @counter = 1
	while @counter <= @length
	begin 
	set @v_partname = @v_partname + SUBSTRING(@name,1,@counter) + CHAr(13)
	set @counter = @counter + 1
	end
	return @v_partname
end

--7
alter function dbo.category(@cat_id int)
returns table 
as 
return
	(select CategoryID, COUNT([ProductID]) as num_of_products
	from Products
	where  CategoryID = @cat_id 
	group by CategoryID)

--8
create function dbo.fun_date (@v_date date)
returns table 
as
	return	
		(select   convert(date,[BirthDate] ,103) as new_bd from Employees where @v_date = BirthDate)


--1
Create trigger t_emp
on employees 
for insert, update, delete
as 
BEGIN Rollback end

--2
create trigger t_emp
on employees 
for insert, update, delete
as 
BEGIN 
if DATEPART(dw,getdate()) = 1
rollback
end

--3
select [FirstName], [LastName] into emp_copy  from employees 
select * from emp_copy
--4
select [FirstName], [LastName] into emp_copy_log from employees 
truncate table emp_copy_log
select * from emp_copy_log

--5
create trigger copy_log
on emp_copy
after delete 
as
begin 
insert into emp_copy_log
select *  from deleted
end

--6
create trigger copy_log_insert
on emp_copy
after insert 
as
begin 
insert into emp_copy_log
select *  from categorylog
end

--7
create table categorylog (Log varchar(25), LogDate date)
create trigger trig_cat_log
on Categories
after update
as begin 
insert into categorylog (Log, LogDate) values ('Categories update', getdate() )
end

--8
alter trigger trig_cord_det
on [order details]
after insert
as
declare @dis bit 
select @dis = p.Discontinued from products p inner join inserted i 
on p.ProductID = i.ProductID

if @dis = 1 
begin 
	print 'Invalid insert - product is unavailable' 
	Rollback
end


--9
alter trigger tr_stsat
on products
after update 
as 
declare @units int, @reorder int, @prod_id int 
if UPDATE (UNITSINSTOCK)
begin
	select @reorder = d.[ReorderLevel],
	@units = i.UNITSINSTOCK,
	@prod_id = I.ProductID
	from deleted d join inserted i 
	on d. ProductID = i. ProductID

	if @units < @reorder
	update Products set Discontinued =1 where ProductID = @prod_id
end

--10
alter trigger tr_prod
on [Order Details] after 
insert 
as
Declare
@p_id int,
@Quantity int
BEGIN 
	select @Quantity = Quantity, @p_id =ProductID
	from  inserted 
	
	UPDATE Products set [UnitsInStock] = [UnitsInStock]- @Quantity where ProductID = @p_id

end


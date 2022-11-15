Create table Customers (
cust_id int, 
cust_name varchar (50), 
cust_city varchar (50))

insert Customers (cust_id, cust_name,cust_city) values (3,'Nike','Berlin')
insert Customers (cust_id, cust_name,cust_city) values (9,'Adidas','London')
insert Customers (cust_id, cust_name,cust_city) values (1,'HP','Manchester')
insert Customers (cust_id, cust_name,cust_city) values (4,'G-force','Viena')
insert Customers (cust_id, cust_name,cust_city) values (2,'Coca-cola','Berlin')
insert Customers (cust_id, cust_name,cust_city) values (6,'BMW','Berlin')
insert Customers (cust_id, cust_name,cust_city) values (5,'Check Point','Tel Aviv')
insert Customers (cust_id, cust_name,cust_city) values (8,'Zara','Madrid')

SELECT * from Customers
where cust_id = 3

select cust_id from Customers
create unique nonclustered index cust_id_ix
on Customers (cust_id)
GO

DROP TABLE Customers

Create table Customers (
cust_id int constraint pk_cust_id PRIMARY KEY, 
cust_name varchar (50), 
cust_city varchar (50),
cust_phone varchar (3000) 
)

insert Customers (cust_id, cust_name,cust_city,cust_phone) values (3,'Nike','Berlin',REPLICATE('*',3000))
insert Customers (cust_id, cust_name,cust_city,cust_phone) values (9,'Adidas','London',REPLICATE('*',3000))
insert Customers (cust_id, cust_name,cust_city,cust_phone) values (1,'HP','Manchester',REPLICATE('*',3000))
insert Customers (cust_id, cust_name,cust_city,cust_phone) values (4,'G-force','Viena',REPLICATE('*',3000))
insert Customers (cust_id, cust_name,cust_city,cust_phone) values (2,'Coca-cola','Berlin',REPLICATE('*',3000))
insert Customers (cust_id, cust_name,cust_city,cust_phone) values (6,'BMW','Berlin',REPLICATE('*',3000))
insert Customers (cust_id, cust_name,cust_city,cust_phone) values (5,'Check Point','Tel Aviv',REPLICATE('*',3000))
insert Customers (cust_id, cust_name,cust_city,cust_phone) values (8,'Zara','Madrid',REPLICATE('*',3000))

select [SalesOrderID], 
[OrderDate],
[DueDate],
[ShipDate],
[Status]
from Sales.SalesOrderHeader
WHERE ShipDate ='2011-06-07'
order by DueDate




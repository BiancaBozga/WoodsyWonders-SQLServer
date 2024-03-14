use WoodsyWonders
go
set ansi_nulls on
go
set quoted_identifier on
go
alter procedure CRUD_Products
    @table_name varchar(50),
	@name varchar(50),
	@quantity int,
	@price int,
	@color varchar(20),
	@noOfRows int
as
begin 
        if (dbo.IS_NOT_NULL(@name)=1 )
	   begin
		set nocount on ;
		--create=insert
		declare @n int=1
		while @n<=@noOfRows begin 
			insert into Products(Name,Quantity,Price,Color)
			values(@name,@quantity,@price,@color)
			set @n=@n+1
		end
		select * from Products
		--read=select
		select * from Products
		--update
		update Products set Price=200 where Color='albastru'
		--delete
		declare @max int;
		select @max=MAX(Pid) from Products
		delete from Products where Pid=@max
		select * from Products
		print 'CRUD operation for table '+@table_name
		end
		else
		begin
			 RAISERROR('Datele de intrare nu sunt valide', 16, 1);
			return
		end


end 

CREATE OR ALTER Function IS_NOT_NULL(@string nvarchar(50))
   RETURNS INT
AS
BEGIN
	IF LEN(@string) >0
	BEGIN
		RETURN 1
	END

	RETURN 0
	 
END
GO

create or alter procedure CRUD_Shops
	@table_name varchar(50),
	@name varchar(50),
	@city varchar(50),
	@openTime time(7),
	@closeTime time(7),
	@fid int,
	@noOfRows int
as
begin
	set nocount on;
	if (dbo.IS_NOT_NULL(@name)=1 and dbo.IS_NOT_NULL(@city)=1)
	begin
	declare @n int=1
		while @n<=@noOfRows begin 
			insert into Shops(Name,City,OpenTime,CloseTime,Fid)
			values(@name,@city,@openTime,@closeTime,@fid)
			set @n=@n+1
		end
		--read
		select * from Shops 
		--update
		update Shops set City='Cluj Napoca' where City='Arad'
		select * from Shops 
		--delete
		delete from Shops where OpenTime<='07:00:00.0000000'
		select * from Shops 
		print 'CRUD operation for table '+@table_name
	end
		else
		begin
			Print 'Error CRUD'+@table_name
			return
		end
end
alter procedure CRUD_ShopsProducts
   @table_name varchar(50)
as
begin
	declare @fk_shops int
	declare @fk_products int
	declare @n int=1
	select top 1 @fk_shops=Sid from Shops where City='Cluj Napoca'
	select top 1 @fk_products=Pid from Products order by Price 
	print(@fk_shops)
	select * from ShopsProducts
	insert into ShopsProducts(Pid,Sid)
	values(@fk_products,@fk_shops)
	
	select * from ShopsProducts
	delete from ShopsProducts where Pid=@fk_products and Sid=@fk_shops
	select * from ShopsProducts
	print 'CRUD operation for table '+@table_name
end 




INSERT INTO Shops (Name, City, OpenTime, CloseTime, Fid)
VALUES ('Shoppp', 'Cluj Napoca', '06:30:00', '18:00:00', 1)
INSERT INTO Shops (Name, City, OpenTime, CloseTime, Fid)
VALUES ('Shop2', 'Arad', '06:30:00', '18:00:00', 1)
--exec Shops
exec CRUD_Shops 'Shops','Lala','Arad','09:00:00.0000000','17:00:00.0000000','1','1'

--exec Products
exec CRUD_Products 'Products','dulap',500,1000,'kaki',1

--exec ShopsProducts
exec CRUD_ShopsProducts 'ShopsProducts'




DECLARE @c INT;
SET @c = 99;

WHILE @c<= 600
BEGIN
  DECLARE @shopName NVARCHAR(50);
  SET @shopName = 'Shop' + CAST(@c AS NVARCHAR(5));

  INSERT INTO Shops (Name, City, OpenTime, CloseTime, Fid)
  VALUES
    (@shopName, 'Cluj Napoca', '09:00:00.0000000', '19:00:00.0000000', 1);
  
  SET @c = @c + 1;
END;




--INDEX
if exists (select name from sys.indexes where name=N'N_idx_City')
	drop index N_idx_City on Shops
go
create nonclustered index N_idx_City on Shops(City)
go

--demonstratie index N_idx_City
select * from Shops order by City
select City from Shops order by City


if exists (select name from sys.indexes where name=N'N_idx_Price')
	drop index N_idx_Price on Products
go
create nonclustered index N_idx_Price on Products(Price)
go

select * from Products p
inner join 
ShopsProducts sp on p.Pid=sp.Pid
order by p.Price

select Price from Products p
inner join 
ShopsProducts sp on p.Pid=sp.Pid
order by p.Price





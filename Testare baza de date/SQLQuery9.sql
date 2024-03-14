use COMM_D0
go

select * from Shops
select * from Factories
select * from ShopsProducts

Create or alter VIEW ViewFactories
as
	select F.City as 'City'
	from Factories F
go

create or alter VIEW ViewShopsProducts
as
	select S.Name as 'ShopName',SP.Pid as 'ProductId'
	from Shops S
	inner join ShopsProducts SP
	on S.Sid=SP.Sid
go

create or alter VIEW ViewShops
as
	select S.Name as 'ShopName',Count(F.Fid) as 'No of Factory'
	from Shops S 
	inner join Factories F
	on S.Fid=F.Fid
	where S.Name='testDB'
	Group by S.Name
go

select * from ViewShops
select * from Factories
select * from Shops

SET IDENTITY_INSERT Tables ON
DELETE FROM Tables
INSERT INTO Tables(TableID, Name)
VALUES (1, 'Factories'), (2, 'Shops'), (3, 'ShopsProducts');
SET IDENTITY_INSERT Tables OFF

select * from Tables


SET IDENTITY_INSERT Views ON;
DELETE FROM Views;
INSERT INTO Views(ViewID, Name)
VALUES (1, 'ViewFactories'), (2, 'ViewShops'), (3, 'ViewShopsProducts');
SET IDENTITY_INSERT Views OFF;

select * from Views

SET IDENTITY_INSERT Tests ON;
DELETE FROM Tests;
INSERT INTO Tests(TestID, Name)
VALUES (1, 'selectView'),
		(2, 'insertFactories'), (3, 'deleteFactories'),
		(4, 'insertShops'), (5, 'removeShops'),
		(6, 'insertShopsProducts'), (7, 'deleteShopsProducts');
SET IDENTITY_INSERT Tests OFF;

select * from Tests

DELETE FROM TestViews;
INSERT INTO TestViews(TestID, ViewID)
VALUES (1, 1), (1, 2), (1, 3);

DELETE FROM TestTables;
INSERT INTO TestTables(TestID, TableID, NoOfRows, Position)
VALUES (4, 1, 10000, 1), (2, 2, 10000, 2), (6, 3, 10000, 3)

select * from TestTables
create or alter proc insertFactories as
begin
	declare @rows int=(select top 1 TT.NoOfRows
	from TestTables TT inner join Tests T on TT.TestID=T.TestID
	where T.name='insertFactories');
	Print (@rows)
	declare @current int=1;
	while @current <=@rows
	begin
		insert into Factories(Surface,City) values (@rows,'testDB')
		set @current=@current+1
	end

end
exec insertFactories1
select * from Factories

create or alter proc deleteFactories as
begin
	delete from Factories 
	where City='testDB';

end


create or alter proc insertShops as
begin
	declare @rows int=(select top 1 TT.NoOfRows
	from TestTables TT inner join Tests T on TT.TestID=T.TestID
	where T.name='insertShops');
	declare @current int=1;
	declare @fid int=(select top 1 Fid from Factories where City='testDB');
	while @current <=@rows
	begin
		insert into Shops(Name,City,OpenTime,CloseTime,Fid)
		values ('testDB','testDB','07:00:00.0000000','17:00:00.0000000',@fid);
			set @current=@current+1
	end

end

create or alter proc deleteShops as
begin
	delete from Shops
	where Name='testDB';

end

create or alter proc insertShopsProducts as
begin 
	declare @rows int=(select top 1 TT.NoOfRows
	from TestTables TT inner join Tests T on TT.TestID=T.TestID
	where T.name='insertShopsProducts');
	declare @current int=1
	declare @pid int =(select top 1 Pid from Products);
	declare @sid int=(select top 1 Sid from Shops where Name='testDB');
	--Print(@sid)
	while @current <=@rows 
	begin
		DECLARE @current_pid INT = @pid;
		DECLARE @current_sid INT = (SELECT @sid + @current - 1);
		--Print( @current_sid)
		INSERT INTO ShopsProducts(Pid,Sid)
		VALUES (@current_pid, @current_sid);
		SET @current = @current + 1
	end
end
select * from ShopsProducts
create or alter proc deleteShopsProducts as
begin
	delete from ShopsProducts 
	where Sid in (select Sid from Shops where Name='testDB');
end
select * from ShopsProducts

select * from Factories where City='testDB'




CREATE OR ALTER PROCEDURE inserare_testgen
@idTest INT
AS
BEGIN
	DECLARE @numeTest NVARCHAR(50) = (SELECT T.Name FROM Tests T WHERE T.TestID = @idTest);
	DECLARE @numeTabela NVARCHAR(50);
	DECLARE @NoOfRows INT;
	DECLARE @procedura NVARCHAR(50);
	DECLARE @aux_id int; -- Am adăugat punct și virgulă aici
	DECLARE @pozitie int = (SELECT tt.Position FROM TestTables tt WHERE tt.TestID = @idTest);
	DECLARE @poz int = 1;
	DECLARE @proc NVARCHAR(50);
	PRINT(@numeTest);
	--PRINT(@pozitie);

	WHILE @poz <= @pozitie
	BEGIN
		SET @aux_id = (SELECT tt.TableID FROM TestTables tt WHERE tt.Position = @poz);
		SET @numeTabela = (SELECT tt.Name FROM Tables tt WHERE tt.TableID = @aux_id);
		set @proc=N'insert'+@numeTabela;
		--PRINT(@proc);
		EXEC @proc;
		SET @poz = @poz + 1;
	END
END;



select * from Factories where City='testDB'
select * from Shops where City='testDB'

select * from Factories where City='testDB'
EXECUTE inserare_testgen 6;


GO
CREATE or alter PROCEDURE stergere_testgen
@idTest INT
AS
BEGIN
	DECLARE @numeTest NVARCHAR(50) = (SELECT T.Name FROM Tests T WHERE T.TestID = @idTest);
	DECLARE @numeTabela NVARCHAR(50);
	DECLARE @NoOfRows INT;
	DECLARE @procedura NVARCHAR(50);
	DECLARE @aux_id int; -- Am adăugat punct și virgulă aici
	DECLARE @pozitie int = (SELECT tt.Position FROM TestTables tt WHERE tt.TestID = @idTest);
	DECLARE @poz int ;
	select @poz= MAX(Position) FROM TestTables ;
	DECLARE @proc NVARCHAR(50);
	--PRINT(@numeTest);
	--PRINT(@pozitie);

	WHILE @poz >= @pozitie
	BEGIN
		SET @aux_id = (SELECT tt.TableID FROM TestTables tt WHERE tt.Position = @poz);
		SET @numeTabela = (SELECT tt.Name FROM Tables tt WHERE tt.TableID = @aux_id);
		set @proc=N'delete'+@numeTabela;
		--PRINT(@proc);
		EXEC @proc;
		SET @poz = @poz - 1;
	END
END;


EXECUTE stergere_testgen 4;




create or alter procedure MyMain
@table_name NVARCHAR(50)
as
begin 
DECLARE @start DATETIME;
	DECLARE @inter DATETIME;
	DECLARE @end DATETIME;
	declare @tableid int;	
	declare @viewname NVARCHAR(50);
	set @viewname='View'+@table_name;
	--print(@viewname);
	declare @viewid int;
	set @viewid=(select V.ViewID from Views V where V.Name=@viewname) ;
	set @tableid=(select tt.TableID FROM Tables tt WHERE tt.Name = @table_name);
	declare @testid int;
	set @testid=(select tt.TestID from TestTables tt where tt.TableID=@tableid);
	--print(@testid);
	
	
	
	DECLARE @comanda NVARCHAR(55) = 
		N'SELECT * FROM ' + @viewname;

	SET @start = GETDATE();
	--delete
	exec stergere_testgen @testid
	EXECUTE (@comanda);
	--insert
	exec inserare_testgen @testid
	
	
	SET @inter = GETDATE();
	
	
	--view
	
	EXECUTE (@comanda);
	--print(@viewid)
	SET @end = GETDATE();
	declare @idd int;
	
	INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('insert/delete/view Test'+@table_name, @start, @end)
	SET @idd = (select tt.TestRunID from TestRuns tt where tt.Description='insert/delete/view Test'+@table_name and tt.StartAt=@start);
    INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@idd, @tableid, @start, @inter);
	 INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@idd, @viewid, @inter, @end);


	PRINT CHAR(10) + '---> TEST COMPLETAT CU SUCCES IN ' + 
		 CONVERT(VARCHAR(10), DATEDIFF(millisecond, @start, @end)) +
		 ' milisecunde. <---'
end
--AICI!!!!
exec MyMain ShopsProducts

exec deleteShopsProducts
exec deleteShops
exec deleteFactories

delete from TestRuns
delete from TestRunTables
delete from TestRunViews
delete from TestViews


select * from Shops 
select * from Tests
select * from TestTables
select * from Tables
select * from Views
SELECT * FROM TestRuns;
SELECT * from TestRunTables
SELECT * from TestRunViews

select * from Factories where City='testDB'
select * from Shops where Name='testDB'
select * from ShopsProducts

set nocount on
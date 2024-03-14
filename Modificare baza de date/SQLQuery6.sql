USE WoodsyWonders
go

CREATE TABLE Versions (
	version INT PRIMARY KEY,
	last_change DATETIME DEFAULT GETDATE()
);

INSERT INTO Versions(version)
VALUES (0);
--modifica tipul unei coloane 
go
ALTER PROCEDURE do_proc_1 AS 
BEGIN 
	ALTER TABLE Products 
	ALTER COLUMN Name NVARCHAR(100)
	print N'Products table:Name column was updated to NVARCHAR(100)'
	UPDATE Versions SET version = 1, last_change = GETDATE()
END
--revine la tipul precedent al coloanei

go
ALTER PROCEDURE undo_proc_1 AS
BEGIN
	ALTER TABLE Products
	ALTER COLUMN name VARCHAR(50)
	PRINT N'Products table:Name column was updated to varchar(50)'
	UPDATE Versions SET version = 0, last_change = GETDATE()
END

--adauga o costrangere de "valoare implicita" pentru un camp
go
ALTER PROCEDURE do_proc_2 AS
BEGIN
	ALTER TABLE Advertisements
	ADD CONSTRAINT  df_type DEFAULT 'online' FOR Type
	PRINT N'Advertisements table: type column has a default value'
	UPDATE Versions SET version = 2, last_change = GETDATE()
END
--sterge o costrangere de "valoare implicita" pentru un camp
GO
ALTER PROCEDURE undo_proc_2 AS
BEGIN
	ALTER TABLE Advertisements
	DROP CONSTRAINT  df_type;
	PRINT N'Advertisements table: type column does not have a default value anymore'
	UPDATE Versions SET version = 1, last_change = GETDATE()
END
GO
--creeaza o tabela noua
ALTER PROCEDURE do_proc_3 AS
BEGIN
	CREATE TABLE EmployeeAccessCards (
	    AccesCode INT PRIMARY KEY,
		CNP varchar(13) NOT NULL,
		Color varchar(50) 
	)
	PRINT N'EmployeeAccessCards table: the table was created'
	UPDATE Versions SET version = 3, last_change = GETDATE()
END
GO

GO
--  sterge o tabela
ALTER PROCEDURE undo_proc_3 AS
BEGIN
	DROP TABLE EmployeeAccessCards
	PRINT N'EmployeeAccessCards table: the table was dropped'
	UPDATE Versions SET version = 2, last_change = GETDATE()
END
GO
-- do_proc_4, adauga un camp nou
ALTER PROCEDURE do_proc_4 AS
BEGIN
	ALTER TABLE EmployeeAccessCards
	ADD expire_date DATE
	PRINT N'EmployeeAccessCards table: expire_date column added'
	UPDATE Versions SET version = 4, last_change = GETDATE()
END
GO

GO
-- undo_proc_4, eliminare camp existent
ALTER PROCEDURE undo_proc_4 AS
BEGIN
	ALTER TABLE  EmployeeAccessCards
	DROP COLUMN expire_date
	PRINT N'EmployeeAccessCards table: expire_date column removed'
	UPDATE Versions SET version = 3, last_change = GETDATE()
END
GO

GO
-- do_proc_5, creeaza o constrangere de "cheie straina" pentru un camp
ALTER PROCEDURE do_proc_5 AS
BEGIN
	ALTER TABLE EmployeeAccessCards
	ADD CONSTRAINT fk_employee_id  FOREIGN KEY(CNP) REFERENCES Employee(CNP)
	PRINT N'EmployeeAccessCards table: Fid column now references Fid column from Factories table'
	UPDATE Versions SET version = 5, last_change = GETDATE()
END
GO

GO
-- undo_proc_2, sterge constrangerea de "cheie straina" pentru un camp
ALTER PROCEDURE undo_proc_5 AS
BEGIN
	ALTER TABLE EmployeeAccessCards
	DROP CONSTRAINT fk_employee_id;
	PRINT N'EmployeeAccessCards table: Fid column no longer references Fid column from Factories table'
	UPDATE Versions SET version = 4, last_change = GETDATE()
END
GO
GO

-- updates the database to a certain version
ALTER PROCEDURE main @new_version INT AS
BEGIN
	SET NOCOUNT ON

	DECLARE @old_version INT
	DECLARE @current_version INT
	DECLARE @procedure VARCHAR(30)
	
	SELECT @current_version = version FROM Versions
	SET @old_version = @current_version 
	IF @new_version > 5 OR @new_version < 0
		RAISERROR(N'Invalid version, must be between 0 and 5!', 16, 1)
	ELSE IF @current_version < @new_version
		BEGIN
			WHILE @current_version < @new_version
			BEGIN
				SET @current_version = @current_version + 1
				SET @procedure = 'do_proc_' + CONVERT(VARCHAR, @current_version)
				EXEC @procedure
			END
			PRINT CHAR(10) + 'Successfully updated from version ' + CONVERT(VARCHAR, @old_version)
				+ ' to version ' + CONVERT(VARCHAR, @new_version) + '!'
		END
	ELSE IF @current_version > @new_version
		BEGIN
			WHILE @current_version > @new_version
			BEGIN
				SET @procedure = 'undo_proc_' + CONVERT(VARCHAR, @current_version)
				EXEC @procedure
				SET @current_version = @current_version - 1
			END
			PRINT CHAR(10) + 'Successfully updated from version ' + CONVERT(VARCHAR, @old_version)
				+ ' to version ' + CONVERT(VARCHAR, @new_version) + '!'
		END
	ELSE
		RAISERROR(N'Cannot update to the specified version because it is already in use!', 16, 1)
	
END

EXEC main 2.3
select * from Versions



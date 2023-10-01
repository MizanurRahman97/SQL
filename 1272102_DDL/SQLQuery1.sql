 
                            SQL Project Name : EmpployeeHistoryDB
				            PreparedBy       : Md.Mizanur Rahman
							Batch ID         : 1272102
						    
 
        =====================<<<<<<<START>>>>>>>======================================
 
 /*------------DDL: 01. Database
                    02. Table
                    03. Alter Table
                    04. Constraint(Primary Key,FK,Default,Null)
                    05. Drop object
                    06. Index
                    07. Sequence
                    08. View
                    09. Stored procedure
                    10.Trigger(For, Instead Of)
                    11.UDF(Scalar valued & Table valued function).................*/

    
     --------------Question No-01(Create a 3NF database)------------
USE MASTER 
GO
IF DB_ID('EmpHistoryDB') Is Not Null
Drop Database EmpHistoryDB
GO
Create Database EmpHistoryDB
ON
(
	Name='EmpHistoryDB_Data_1',
	FileName='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER01\MSSQL\DATA\EmpHistoryDB_Data_1.mdf',
	Size=25MB,
	MaxSize=100,
	FileGrowth=5%
)

Log ON
(
	Name='EmpHistoryDB_Log_1',
	FileName='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER01\MSSQL\DATA\EmpHistoryDB_Log_1.ldf',
	Size=2MB,
	MaxSize=50,
	FileGrowth=1mb
)

           ------------------------02(Create Table Department_1------------

CREATE TABLE Department_1
(
	DepartmentID Int Primary Key NONCLUSTERED Not Null,
	DeptName Varchar(20)not null
)
GO
Select * from Department_1

           -----------------------03(Create Table Employee)--------------------------

CREATE TABLE Employee
(
	EmployeeID Int Primary Key Not Null,
	EmployeeFName Varchar(12) Not Null,
	EmployeeLName Varchar(12) Not Null,
	EmployeeJoiningDate DateTime Not Null,
	Email varchar(40) Not Null,
	Phone Varchar(11) Not Null,
	DepartmentID Int References Department_1(DepartmentID)
)
Go
Select * from Employee


------------------------------4.CREATE TABLE EmployeeGradeHistory_1------------------------------


CREATE TABLE EmployeeGradeHistory_1
(
	GradeID Int Not Null,
	GradeName Varchar(8) Not Null,
	StartDate datetime Not Null,
	EndDate datetime,
	EmployeeID Int References Employee(EmployeeID),
	primary key(GradeID,EmployeeID)
)


------------------------------4.CREATE TABLE EmployeeDesignationHistory-----------------------------

CREATE TABLE EmployeeDesignationHistory
(
	DesigID Int Not Null,
	DesigName Varchar(15) Not Null,
	StartDate DateTime Not Null,
	EndDate DateTime Null,
	EmployeeID Int References Employee(EmployeeID),
	primary key(DesigID,EmployeeID)
)


-----------------------------05.-ALTER TABLE (Delete,ADD, DELETE COLUMN, DROP COLUMN)---------------------------------------------------
Delete from Students where StudentsID=101

---------------------------------------- Update For any one TABLE----------------------------------------------------------
 
Update Students
Set StudentsName='Rahman'
Where StudentsID=101
GO
-------------------------------------------DELETE COLUMN FROM A EXISTING TABLE--------------------------------------------------------------
ALTER TABLE student
DROP COLUMN studentName
GO
--------------------------------------------------------DROP A TABLE------------------------------------------------------------------------
IF Object_Id ('Students') is not null
Drop Table Students
-


--
-------------------------------------------------06 INDEX ----------------------------------------------------------------------

-------------------------------------CREATING A NONCLUSTERED INDEX FOR Department_1 TABLE-------------------------------------------------------

         CREATE UNIQUE NONCLUSTERED INDEX IX_Department_1
         ON Department (DepartmentID)    

-------------------------------------CREATING A CLUSTERED INDEX FOR Department_1 TABLE---------------------------------------------------------
	CREATE CLUSTERED INDEX ix_Department_1 DeptName
    On Department_1(DeptName)
    --Justify
    --EXEC sp_helpindex Department
	-------------------------------------  07.(VIEW ) ---------------------------------

USE EmpHistoryDB
GO
Create View vw_EmployeeHistoryDetail
AS
Select e.EmployeeFName+' '+ e.EmployeeLName AS "EmpName", d.DeptName, 
CONVERT (Varchar,e.EmployeeJoiningDate,23) AS "EmpJoiningDate", e.Email, e.Phone, eg.GradeName AS Grade,
CONVERT(varchar,eg.StartDate,23) AS JoinDate,
CONVERT(varchar,eg.EndDate,23) AS EndDate, dg.DesigName, 
CONVERT(varchar,eg.StartDate,23) AS JoinDate
From Employee_1 e
join Department_1 d on d.DepartmentID=e.DepartmentID
JOIN EmployeeGradeHistory eg on eg.EmployeeID=eg.EmployeeID
JOIN EmployeeDesignationHistory dg on dg.EmployeeID=eg.EmployeeID


----------------------------------------08. A STORED PROCEDURE FOR QUERY  DATA---------------------------------------------------
CREATE PROC InsertUpdateDeleteOutputErrorTran
@processtype varchar(20),
@DepartmentID int not null,
@DeptName varchar(20),
@processCount int output
as
BEGIN
BEGIN TRY
BEGIN TRAN
--SELECT
IF @processtype='SELECT'
BEGIN
SELECT * FROM Department_1
END
--INSERT
IF @processtype='INSERT'
BEGIN
INSERT INTO Department_1 VALUES (@DepartmentID,@DeptName)
END
--UPDATE
IF @processtype='UPDATE'
BEGIN
UPDATE Department_1 SET DeptName=@DeptName WHERE DepartmentID=@DepartmentID
END
--DELETE
IF @processtype='DELETE'
BEGIN
DELETE FROM Department_1 WHERE DepartmentID=@DepartmentID
END
--COUNT 
IF @processtype='COUNT'
BEGIN
SELECT @processCount=COUNT(*) FROM Department_1
END
COMMIT TRAN 
END TRY
BEGIN CATCH
SELECT ERROR_LINE() AS ErrorLine,
ERROR_MESSAGE() AS ErrorMessage,
ERROR_NUMBER() AS ErrorNumber,
ERROR_SEVERITY() AS ErrorSeverity,
ERROR_STATE() AS ErrorState
ROLLBACK TRAN
END CATCH
END

-----------------------09.Scalar valued function------------
 Create Function fn_GradeID
(@GradeName varchar(8))
 Returns varchar(8)
 BEGIN
 RETURN(SELECT GradeID FROM EmployeeGradeHistory WHERE @GradeName=@GradeName)
 END

 ----------------------------10.CREATE TABLE VALUED FUNCTION--------------
CREATE Function fnAllEmployee()
Returns @Employee Table
(
  EmployeeId int primary key not null,
  EmployeeFName varchar(12),
  EmployeeLName varchar(12),
  EmployeeJoiningDate datetime not null,
  Email varchar(40),
  Phone varchar(11)
  )
  AS
  BEGIN
  INSERT INTO @Employee
  SELECT DepartmentID,DeptName FROM Department_1

  INSERT INTO @Employee
  SELECT * FROM EmployeeDesignationHistory
  RETURN;
  END
----------------------------------------------11. TRIGGERS-------------------------------
  
  Create Table Department_1
  (
        DepartmentID int primary key,
		DeptName varchar(20) not null
  )
  GO
  Create Table EmployeeGradeHistory
  (
        GradeID int not null,
		GradeName varchar(8) not null,
		StartDate datetime not null,
		EndDate Datetime
  )
  GO


  Select * from Department_1
  Go

  ---------------After Trigger For Insert Data Into Department_1 Table----------

  Create TRIGGER TR_EmployeeGradeHistory_1Insert
  ON EmployeeGradeHistory_1
  For Insert
  As
    BEGIN
	      DECLARE @GradeID INT , @startdate int
		  Select @GradeID,@startdate from inserted

		  update EmployeeGradeHistory_1
		  SET startdate=2019-07-01
		  WHERE GradeID=@startdate
   END
GO
SELECT * FROM EmployeeGradeHistory_1
GO
-----------------CREATE TRIGGER FOR DELETE DATA FROM DEPARTMENT_1 TABLE-------------
CREATE TRIGGER TR_DeleteDepartment_1
ON Department_1
FOR DELETE
AS
    BEGIN
	       DECLARE @DpartmentID INT ,@DeptName varchar(20)
		   SELECT @DpartmentID, @DeptName FROM inserted

		   UPDATE Department_1
		   SET DeptName='IT'
		   WHERE DepartmentID=@DpartmentID
   END
GO
---TEST--
DELETE FROM Department_1
WHERE DepartmentID=101
GO

----------------------CREATE UPDATE FOR TRIGGER FOR DATA IN THE EMPLOYEEGRADEHISTORY_1--------
Select * from EmployeeGradeHistory_1 Details
GO
Create TRIGGER TR_UpdateEmployeeGradeHistory_1Details
ON EmployeeGradeHistory_1 
FOR UPDATE
AS
    BEGIN 
	       IF UPDATE (StartDate)
		   BEGIN
		              DECLARE @GradeID int,
					          @GradeName varchar(8),
							  @startDate datetime,
							  @EndDate datetime
                   Select @GradeID=i.GradeID,@GradeName=i.GradeName,@startDate=i.StartDate 
				   from inserted i
				   JOIN deleted D ON D.GradeID=I.GradeID
				   SET @EndDate=@GradeName-@startDate

				   UPDATE EmployeeGradeHistory_1
				   SET StartDate=StartDate+@@DATEFIRST
				   Where GradeID=GradeID
           END

		  ============>>>>>>>>>>>     END OF DDL SCRIPT     <<<<<<<<<<<<====================
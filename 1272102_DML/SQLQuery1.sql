                         
						 SQL Project Name : EmpployeeHistoryDB
				            PreparedBy       : Md.Mizanur Rahman
							Batch ID         : 1272102
						    
 
   =====================<<<<<<<START>>>>>>>======================================
  /* ------DML:--------   01. Data Insert
                          02. Join Query
                          03. Sub Query
						  04. CASE
                          05. CTE
                          06. Test Trigger
                          07. CUST---CONVERT
						  08. IIF---CHOOSE
						  09. ISNULL---COALESCE
						  10. RANKING FUNCTION
                          11. IF...ELSE
                          12. Built-in Function 
                          13. CAST- CONVERT
                          14. TRY....CATCH
						  15. CURSOR
						  16. Test View
                          17. Test UDF
                          18. Test  
						  19. MERGE...........*/
USE EmployeeHistoryDB
                           
GO

------------------------------->DATA INSERT<------------------------------------------

------------------------>1.INSERT INTO  Department_1 VALUES	<------------------------------


Insert Into Department_1 VALUES				 
	(101,'IT'),
	(102,'Admin'),
	(103,'HR')
GO
SELECT * FROM Department_1
GO

------------------------ >2.INSERT INTO Employee VALUES <----------------------------
Insert Into Employee VALUES
	(201,'Muzahid','ul islam','1-7-2017','rm@gmail.com','01934675987','101'),
	(202,'Kaisar','Faisal','1-1-2017','kf@gmail.com','01934612612','102'),
	(203,'Azad','Ahmed','1-3-2018','az@gmail.com','01751123123','103')
Go
Select * from  Employee
GO

Go
Begin try
Begin tran
Insert Into Employee VALUES
	(201,'Muzahid','ul islam','1-7-2017','rm@gmail.com','01934675987','101'),
	(202,'Kaisar','Faisal','1-1-2017','kf@gmail.com','01934612612','102'),
	(203,'Azad','Ahmed','1-3-2018','az@gmail.com','01751123123','103')
Commit try,
Begin catch
Rollback tran
Select ERROR_MESSAGE()as meg,
ERROR_NUMBER() as ErrorNumber,
ERROR_SEVERITY()as severity,
ERROR_STATE() as state
END catch
---------------------------3.INSERT INTO EmployeeGradeHistory_1 VALUES------------------------------
Insert Into EmployeeGradeHistory_1 VALUES
	(301,'G02','2019-07-01','2022-06-30',201),
	(302,'G01','2019-07-01','2021-06-30',202),
	(303,'M003','2019-07-01','',203)
GO
Select * from EmployeeGradeHistory_1
Go

     -------------------4.INSERT INTO EmployeeDesignationHistory VALUES---------------------------
 Insert Into EmployeeDesignationHistory VALUES
	(401,'Proj.Manager','2017-07-01','2018-06-30',201),
	(402,'Ass.Manager','2018-07-01','2019-06-30',202),
	(403,'Recruit Manager','2019-07-01','',203)
GO
Select * from EmployeeDesignationHistory
GO

   -----------------------Join Query(INNER JOIN)---------------------------
   USE EmpHistoryDB
	GO
	
	Select e.DepartmentID,e.Phone,r.DesigName,e.EmployeeID from Employee e
	Join EmployeeDesignationHistory r ON e.EmployeeID=r.EmployeeID
	Group By e.DepartmentID,e.Phone,r.DesigName,e.EmployeeID
	having e.EmployeeID=201
            ----------------------SUBQUERY----------------------------
	SELECT DepartmentID FROM Department_1 d
JOIN Department_1 Details Depertment_1 d ON DepartmentID=d.DepartmentID
WHERE DeptName='IT'(SELECT DepartmentID FROM Department_1 WHERE DepartmentID=101 )

        ----- ---------------Question -(Search Case)------------------------

GO
SELECT  DepartmentID,DepatName,
CASE
	WHEN Datediff(MONTH,EmployeeJoiningDate,'01-01-2018')>6
	Then 'REGULAR'
	ELSE 'Not REgular'
	End AS status
	from Department_1

		--------------------Question ..(Cursor)------------------------------
CREATE Table Departmentcopy
(	DepartmentID  int primary key  not null ,
	DepatName varchar(20) not null
)
GO
Declare @DepartmentID Int
Declare @DepatName Varchar(20)
Declare @DepartmentCount Int
Set @DepartmentCount=0;
Declare DepartmentCount_Cursor CURSOR
FOR
Select * From Department_1
OPEN DepartmentCount_Cursor
Fetch Next From DepartmentCount_Cursor Into @DepartmentID, @DepartmentName;
While @@FETCH_STATUS<>-1
Begin
Insert Into Departmentcopy Values (@DepartmentID, @DepatName)
Set @DepartmentCount=@DepartmentCount+1;
Fetch Next From DepartmentCount_Cursor Into @DepartmentID, @DepartmentName;
End
Close DepartmentCount_Cursor
Deallocate DepartmentCount_Cursor
Print Convert(varchar,@DepartmentCount)+'Rows inserted'


	--------------------TEST TRIGGERS FOR UPDATE DATA---------------
  DELETE FROM Department_1
  WHERE DepartmentID=101
 GO
 -------------------------Test Trigger---------------
                  UPDATE EmployeeGradeHistory_1
				   SET StartDate=StartDate+@@DATEFIRST
				   Where GradeID=GradeID

         ------------------Question...(Convert)---------------------------

DECLARE @EndDate smalldatetime
SET  @EndDate='30-june-2022 11:00 am'
Select CONVERT(time,@EndDate)
         ---------------------------Question(Cast)-----------------------
DECLARE @StartDate smalldatetime
SET  @StartDate='01-july-2019 11:00 am'
Select Cast(@StartDate as date)as StartDate

         -----------------------Question(IIF/Choose)--------------------------
USE EmpHistoryDB
Select AVG(EmployeeJoiningDate)as AvgEmployeeJoiningDate ,
iif(avg(EmployeeJoiningDate)>=2019-07-01,'Increment','Decrement') as iif_f,
Choose(EmployeeJoiningDate,'Increment','Decrement')as Choose_f
from Employee
Group By EmployeeJoiningDate

           ------------------Question(IsNull/Coalesce)--------------------
select EmployeeID,
  isnull(EmployeeFName,'Muzahidul')as isnull_f,
  coalesce(EmployeeFName,'Muzahidul')as coalesce_f
  from Employee

         ---------------------------Question(RANKING)------------------------
SELECT EmployeeFName,
Rank() over (order by EmployeeEmail) as rank_f,
DENSE_RANK() over(order by EmployeeEmail) as DenseRank_f,
ROW_NUMBER() over(partition by EmployeeID order by EmployeePhone) as RowNumber_f,
NTILE(1) over (order by EmployeeEmail) as NTile_f
FROM Employee
  ------------------------------------IF ELSE------------------------------

CREATE TRIGGER TR_EmployeeGradeHistory_1
ON EmployeeGradeHistory_1
INSTEAD OF INSERT
AS
	BEGIN
			DECLARE @GradeID INT, @startdate INT
			SELECT @GradeID,@startDate FROM inserted
			SELECT @GradeID= SUM(StartDate) FROM EmployeeGradeHistory_1 WHERE GradeID=GradeID
			
			IF @GradeID>=@GradeID
					BEGIN 
							INSERT INTO EmployeeGradeHistory_1 Details(GradeID,GradeName,StartDate)	
							SELECT @GradeID,@startDate FROM inserted
					END

			ELSE
					BEGIN
							RAISERROR('SORRY, THERE IS NOT Item ',101)
							ROLLBACK TRANSACTION
					END
	END
GO

  -------------------------------------CTE--------------------------
USE EmpHistoryDB
GO 
With ct_Employee
as
(Select e.EmployeeFName+''+e.EmployeeLName AS EmployeeName, 
 AS EmployeeJoiningdate, e.Phone AS EmpPhone,e.EmployeeID
From Employee e
JOIN Department_1 d ON d.DepartmentID=e.DepartmentID) 


---------------------------------------------CAST-------------------------------------------------------

 SELECT CAST('01-JUNE-2019 10:00 AM' AS DATE) 'DATE'
   GO

 DECLARE @MYTIME   datetime= '01-june-2019 10:00 AM'
 SELECT CONVERT (VARCHAR,GETDATE(),  8) 'TIME'
 GO

 
           ----------------------------TRY CATCH-------------------------

CREATE PROCEDURE sp_WithDepartment_1  
AS  
    SELECT * FROM Department_1 Details 
GO  
  
BEGIN TRY  
    EXECUTE DeptName'IT',  
	EXECUTE DeptName'Admin',
	EXECUTE DeptName'HR'
	
END TRY  
BEGIN CATCH  
    SELECT   
        ERROR_DepartmentID(101),(102),(103), as
     
END CATCH; 

       -------------------------Built-in Function--------------------------------

SELECT LTRIM(' Shamsun  ')'NAME'
SELECT RTRIM('12215')'        NUMER'
SELECT RTRIM(LTRIM('   Hasan         '))'name'
SELECT LOWER('     Amanur     ')'NAME'
SELECT UPPER('Romjan')
SELECT REVERSE('')
SELECT LEN(' Imran  ') 'CHARACTER'
SELECT ASCII('Safayet  ')'CHARACTER'
GO
-------------------- LOOP(While LOOP)------------------------
DECLARE @Number INT
SET @Number =50
WHILE @Number <=112
BEGIN
PRINT CHAR (@Number)
SET @Number=@Number+1
End
GO
-----------------------------------MERGE---------------------------------
   SELECT *FROM Department_1
   GO
   SELECT *FROM EmployeeGradeHistory_1
   GO
   
    MERGE Department_1 AS TARGET
	USING EmployeeGradeHistory_1 AS SOURCE
	ON SOURCE.GradeID = TARGET.DeptName
	WHEN MATCHED THEN 
	UPDATE SET TARGET.DepartmentID=SOURCE.GradeID
	WHEN  NOT MATCHED BY TARGET THEN
	INSERT (DepartmentID,DeptName) VALUES(SOURCE.GradeName,.GradeID);
	Go

	=======================>>>>>>>>>>>>    END OF DML SCRIPT     <<<<<<<<<<<<================

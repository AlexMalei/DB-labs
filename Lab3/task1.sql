USE [AdventureWorks2012];
GO
/*----------------------------------------------------------------------------------*/
/*a) �������� � ������� dbo.Employee ���� EmpNum ���� int;*/
ALTER TABLE [dbo].[Employee] 
		ADD [EmpNum] INT; 

/*----------------------------------------------------------------------------------*/
/*b) �������� ��������� ���������� � ����� �� ���������� ��� dbo.Employee � ���������
 �� ������� �� dbo.Employee. ���� VacationHours ��������� �� ������� 
 HumanResources.Employee. ���� EmpNum ��������� ����������������� �������� ����� 
 (��������� ������� ������� ��� �������� SEQUENCE);*/
 DECLARE @t1 TABLE ([BusinessEntityID] INT, [NationalIDNumber] NVARCHAR(15),
					[LoginID] NVARCHAR(256), [JobTitle] NVARCHAR(50),
					[BirthDate] DATE, [MaritalStatus] NCHAR(1),
					[Gender] NCHAR(1), [HireDate] DATE, [VacationHours] SMALLINT,
					[SickLeaveHours] SMALLINT, [ModifiedDate] DATE, [EmpNum] INT)  

INSERT INTO @t1 ([BusinessEntityID], 
				 [NationalIDNumber],
				 [LoginID],
				 [JobTitle],
				 [BirthDate],
				 [MaritalStatus],
				 [Gender],
				 [HireDate],
				 [VacationHours],
				 [SickLeaveHours],
				 [ModifiedDate],
				 [EmpNum] )
SELECT [dboEmployee].[BusinessEntityID], 
	   [dboEmployee].[NationalIDNumber],
	   [dboEmployee].[LoginID],
	   [dboEmployee].[JobTitle],
	   [dboEmployee].[BirthDate],
	   [dboEmployee].[MaritalStatus],
	   [dboEmployee].[Gender],
	   [dboEmployee].[HireDate],
	   [HREmployee].[VacationHours],
	   [dboEmployee].[SickLeaveHours],
	   [dboEmployee].[ModifiedDate],
	   ROW_NUMBER() OVER (ORDER BY [dboEmployee].[BusinessEntityID]) [EmpNum]
FROM [dbo].[Employee] AS [dboEmployee]
JOIN [HumanResources].[Employee] AS [HREmployee]
ON [HREmployee].[BusinessEntityID] = [dboEmployee].[BusinessEntityID]; 


/*----------------------------------------------------------------------------------*/
/*c) �������� ���� VacationHours � EmpNum � dbo.Employee ������� �� ��������� ����������. 
���� �������� � ��������� ���������� � ���� VacationHours = 0 � �������� ������ ��������;*/

UPDATE [dboEmployee]
SET [dboEmployee].[VacationHours] = [TableVar].[VacationHours], 
	[dboEmployee].[EmpNum] = [TableVar].[EmpNum]	
FROM [dbo].[Employee] AS [dboEmployee] 
JOIN @t1 AS [TableVar] 
	ON [dboEmployee].[BusinessEntityID] = [TableVar].[BusinessEntityID]
WHERE [TableVar].[VacationHours] != 0;



/*----------------------------------------------------------------------------------*/
/*d) ������� ������ �� dbo.Employee, EmailPromotion ������� ����� 0 
	 � ������� Person.Person;*/
DELETE FROM [dbo].[Employee]
FROM [dbo].[Employee] AS [dboEmployee]
JOIN [Person].[Person] AS [PPerson] 
ON [dboEmployee].[BusinessEntityID] = [PPerson].[BusinessEntityID]
WHERE [PPerson].[EmailPromotion] = 0
 
/*----------------------------------------------------------------------------------*/
/*e) ������� ���� EmpName �� �������, ������� ��� ��������� ����������� 
	 � �������� �� ���������.*/
ALTER TABLE [dbo].[Employee] 
	DROP COLUMN [EmpNum];
ALTER TABLE [dbo].[Employee] 
	DROP CONSTRAINT [Unique], [GreaterZero]

SELECT *
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Employee';

/*----------------------------------------------------------------------------------*/
/*f) ������� ������� dbo.Employee.*/

DROP TABLE [dbo].[Employee]
---������� 5---
USE [AdventureWorks2012];
GO

/*
a) 
	�������� ������� dbo.Employee � ����� �� ���������� ��� HumanResources.Employee, 
	����� ����� OrganizationLevel, SalariedFlag, CurrentFlag, � ����� ����� ����� � ����� hierarchyid, 
	uniqueidentifier, �� ������� �������, ����������� � ��������;
*/
SELECT TOP 0 * INTO [dbo].[Employee] 
FROM [HumanResources].[Employee];

ALTER TABLE [dbo].[Employee] 
	DROP COLUMN [OrganizationLevel],
				[SalariedFlag],
				[CurrentFlag],
				[OrganizationNode],
				[rowguid];		
						
/*
b) 
	��������� ���������� ALTER TABLE, 
    �������� ��� ������� dbo.Employee ����������� UNIQUE ��� ���� NationalIDNumber;
*/

ALTER TABLE [dbo].[Employee] 
	ADD CONSTRAINT [Unique] UNIQUE ([NationalIDNumber])

/*
c) 
	��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Employee 
	����������� ��� ���� VacationHours, 
	����������� ���������� ����� ���� ���������� �������� ��� ������� 0;
*/	

ALTER TABLE [dbo].[Employee] 
	ADD CONSTRAINT [GreaterZero] CHECK ([VacationHours] > 0 )

/*
d) 
	��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Employee 
	����������� DEFAULT ��� ���� VacationHours, ������� �������� �� ��������� 144;
*/

ALTER TABLE [dbo].[Employee] 
	ADD CONSTRAINT [DefaultVacationHours] DEFAULT 144 FOR [VacationHours];

/*
e) 
	��������� ����� ������� ������� �� HumanResources.Employee � ����������� �� ������� �Buyer�. 
	�� ���������� ��� ������� ���� VacationHours, ����� ��� ����������� ���������� �� ���������;
*/

INSERT INTO [dbo].[Employee] ([BusinessEntityID], 
							  [NationalIDNumber], 
							  [LoginID], 
							  [JobTitle], 
							  [BirthDate], 
							  [MaritalStatus], 
							  [Gender], 
							  [HireDate], 
							  [SickLeaveHours], 
							  [ModifiedDate])
SELECT [BusinessEntityID], 
	   [NationalIDNumber], 					  
	   [LoginID], 
	   [JobTitle], 
	   [BirthDate], 
	   [MaritalStatus], 
	   [Gender], 
	   [HireDate],
	   [SickLeaveHours], 
	   [ModifiedDate] 
FROM [HumanResources].[Employee]
WHERE [JobTitle] = 'Buyer';

/*
f) 
	�������� ��� ���� ModifiedDate �� DATE 
	� ��������� ���������� null �������� ��� ����.
*/

ALTER TABLE [dbo].[Employee] 
	ALTER COLUMN [ModifiedDate] DATE NULL;





---------------------------------------------------------
INSERT INTO	[dbo].[Employee] VALUES (1, 'NatIDNumber', 'LoginID', 'JobTitle', '1990-12-21', '1', '1', '2012-12-21', 20, 22, '2015-10-11 15:50:35')

--------------------------------------------------------

INSERT INTO	[dbo].[Employee] VALUES (1, 'NatIDNumber', 'LoginID', 'JobTitle', '1990-12-21', '1', '1', '2012-12-21', 20, 22, '2015-10-11 15:50:35')

INSERT INTO	[dbo].[Employee] VALUES (1, 'UniqueNatIDNumber', 'LoginID', 'JobTitle', '1990-12-21', '1', '1', '2012-12-21', 20, 22, '2015-10-11 15:50:35')

-----------------------------------------

INSERT INTO	[dbo].[Employee] VALUES (1, 'VacationHoursZero', 'LoginID', 'JobTitle', '1990-12-21', '1', '1', '2012-12-21', 0, 22, '2015-10-11 15:50:35')

INSERT INTO	[dbo].[Employee] VALUES (1, 'VacationHoursGreaterZero', 'LoginID', 'JobTitle', '1990-12-21', '1', '1', '2012-12-21', 1, 22, '2015-10-11 15:50:35')

-----------------------------------------------

INSERT INTO	[dbo].[Employee] ([BusinessEntityID], 
							  [NationalIDNumber], 
							  [LoginID], 
							  [JobTitle], 
							  [BirthDate], 
							  [MaritalStatus], 
							  [Gender], 
							  [HireDate], 
							  [SickLeaveHours], 
							  [ModifiedDate]) 
	VALUES (1, 'VacHoursEmpty', 'LoginID', 'JobTitle', '1990-12-21', '1', '1', '2012-12-21', 22, '2015-10-11 15:50:35')
----------------------------------------------------------

----------------------------------------------------------
DROP TABLE [dbo].[Employee];

SELECT TOP 1000 [BusinessEntityID]
      ,[NationalIDNumber]
      ,[LoginID]
      ,[JobTitle]
      ,[BirthDate]
      ,[MaritalStatus]
      ,[Gender]
      ,[HireDate]
      ,[VacationHours]
      ,[SickLeaveHours]
      ,[ModifiedDate]
  FROM [AdventureWorks2012].[dbo].[Employee]

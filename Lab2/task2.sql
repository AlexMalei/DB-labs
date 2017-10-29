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








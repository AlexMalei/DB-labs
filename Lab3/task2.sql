USE [AdventureWorks2012];
GO

/*-------------------------------------------------------------------------------------------*/
/*a) ��������� ���, ��������� �� ������ ������� ������ ������������ ������. 
�������� � ������� dbo.Employee ���� SumTotal MONEY � SumTaxAmt MONEY. 
����� �������� � ������� ����������� ���� WithoutTax, 
����������� ������� ����� ����� ������ ��������� ������� (SumTaxAmt) 
� ����� ������ ������ (SumTotal).*/

ALTER TABLE [dbo].[Employee]
	ADD [SumTotal] MONEY, 
		[SumTaxAmt] MONEY,
		[WithoutTax] AS ([SumTotal] - [SumTaxAmt])
		
ALTER TABLE [dbo].[Employee]
	DROP COLUMN [WithoutTax], [SumTotal], 
		[SumTaxAmt] ;

/*-------------------------------------------------------------------------------------------*/
/*b) �������� ��������� ������� #Employee, � ��������� ������ �� ���� BusinessEntityID. 
	 ��������� ������� ������ �������� ��� ���� ������� dbo.Employee 
	 �� ����������� ���� WithoutTax.*/
IF OBJECT_ID('tempdb.dbo.#Employee') IS NOT NULL
  DROP TABLE #Employee; 

CREATE TABLE #Employee (
			[BusinessEntityID] INT PRIMARY KEY IDENTITY(1,1), 
			[NationalIDNumber] NVARCHAR(15),
			[LoginID] NVARCHAR(256),
			[JobTitle] NVARCHAR(50),
			[BirthDate] DATE,
			[MaritalStatus] NCHAR(1),
			[Gender] NCHAR(1),
			[HireDate] DATE,
			[VacationHours] SMALLINT,
			[SickLeaveHours] SMALLINT,
			[ModifiedDate] DATE,
			[SumTotal] MONEY,
			[SumTaxAmt] MONEY 
);

/*-------------------------------------------------------------------------------------------*/
/*c) ��������� ��������� ������� ������� �� dbo.Employee. 
     ���������� ����� ������ (TotalDue) � ����� ������� (TaxAmt) ��� ������� ���������� (EmployeeID) 
	 � ������� Purchasing.PurchaseOrderHeader � ��������� ����� ���������� ���� SumTotal � SumTaxAmt. 
	 �������� ������ �� ������, ��� SumTotal > 5 000 000. ������� ����� ������ 
	 � ����� ������� ����������� � Common Table Expression (CTE).*/

SET IDENTITY_INSERT #Employee ON;
/*WITH [prepared_data] ([EmployeeID], [TotalSum], [TotalTax])
	AS ( SELECT DISTINCT  [PPOrderHeader].[EmployeeID],
						  SUM([PPOrderHeader].[TotalDue]) OVER (PARTITION BY [PPOrderHeader].[EmployeeID]),
				          SUM([PPOrderHeader].[TaxAmt]) OVER (PARTITION BY [PPOrderHeader].[EmployeeID])
		 FROM [Purchasing].[PurchaseOrderHeader] AS [PPOrderHeader] 
			JOIN [dbo].[Employee] AS [dboEmployee] 
			  ON [dboEmployee].[BusinessEntityID] = [PPOrderHeader].[EmployeeID] )*/
WITH [prepared_data] ([EmployeeID], [TotalSum], [TotalTax])
	AS ( SELECT DISTINCT  [PPOrderHeader].[EmployeeID],
						  SUM([PPOrderHeader].[TotalDue]) ,
				          SUM([PPOrderHeader].[TaxAmt])
		 FROM [Purchasing].[PurchaseOrderHeader] AS [PPOrderHeader] 
			JOIN [dbo].[Employee] AS [dboEmployee] 
			  ON [dboEmployee].[BusinessEntityID] = [PPOrderHeader].[EmployeeID] 
		GROUP BY [PPOrderHeader].[EmployeeID])

INSERT INTO #Employee ( [BusinessEntityID],
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
						[SumTotal],
						[SumTaxAmt] )
SELECT	[prepared_data].[EmployeeID],
		[NationalIDNumber],
		[LoginID],
		[JobTitle],
		[BirthDate],
		[MaritalStatus],
		[Gender],
		[HireDate],
		[VacationHours],
		[SickLeaveHours],
	    [dboEmployee].[ModifiedDate],
		[prepared_data].[TotalSum],
		[prepared_data].[TotalTax]
FROM [dbo].[Employee] AS [dboEmployee]
JOIN [prepared_data] 
  ON [prepared_data].[EmployeeID] = [dboEmployee].[BusinessEntityID]
WHERE [prepared_data].[TotalSum] > 5000000;

SET IDENTITY_INSERT #Employee OFF;

SELECT * FROM #Employee;
DELETE FROM #Employee;

/*-------------------------------------------------------------------------------------------*/
/*d) ������� �� ������� dbo.Employee ������, ��� MaritalStatus = �S�*/

DELETE FROM [dbo].[Employee]
WHERE [MaritalStatus] = 'S';

/*-------------------------------------------------------------------------------------------*/
/*e) �������� Merge ���������, ������������ dbo.Employee ��� target, � ��������� ������� 
     ��� source. ��� ����� target � source ����������� BusinessEntityID. 
	 �������� ���� SumTotal � SumTaxAmt, ���� ������ ������������ � source � target. 
	 ���� ������ ������������ �� ��������� �������, �� �� ���������� � target, 
	 �������� ������ � dbo.Employee. ���� � dbo.Employee ������������ ����� ������, 
	 ������� �� ���������� �� ��������� �������, ������� ������ �� dbo.Employee.*/

MERGE [dbo].[Employee] AS [T]
USING [#Employee] AS [S]
ON [T].[BusinessEntityID] = [S].[BusinessEntityID]
WHEN NOT MATCHED BY SOURCE THEN
	DELETE
WHEN MATCHED THEN
	UPDATE SET
		[T].[SumTotal] = [S].[SumTotal],
		[T].[SumTaxAmt] = [S].[SumTaxAmt]
WHEN NOT MATCHED BY TARGET THEN
	INSERT ([BusinessEntityID],
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
			[SumTotal],
			[SumTaxAmt])
	VALUES( [S].[BusinessEntityID],
			[S].[NationalIDNumber],
			[S].[LoginID],
			[S].[JobTitle],
			[S].[BirthDate],
			[S].[MaritalStatus],
			[S].[Gender],
			[S].[HireDate],
			[S].[VacationHours],
			[S].[SickLeaveHours],
			[S].[ModifiedDate],
			[S].[SumTotal],
			[S].[SumTaxAmt]);

	 

/*-------------------------------------------------------------------------------------------*/

SELECt * FROM #Employee
SELECT * FROM [dbo].[Employee]
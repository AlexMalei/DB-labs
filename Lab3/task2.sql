USE [AdventureWorks2012];
GO

/*-------------------------------------------------------------------------------------------*/
/*a) выполните код, созданный во втором задании второй лабораторной работы. 
Добавьте в таблицу dbo.Employee поля SumTotal MONEY и SumTaxAmt MONEY. 
Также создайте в таблице вычисляемое поле WithoutTax, 
вычисляющее разницу между общей суммой уплаченых налогов (SumTaxAmt) 
и общей суммой продаж (SumTotal).*/

ALTER TABLE [dbo].[Employee]
	ADD [SumTotal] MONEY, 
		[SumTaxAmt] MONEY,
		[WithoutTax] AS ([SumTotal] - [SumTaxAmt])
		
ALTER TABLE [dbo].[Employee]
	DROP COLUMN [WithoutTax], [SumTotal], 
		[SumTaxAmt] ;

/*-------------------------------------------------------------------------------------------*/
/*b) Создайте временную таблицу #Employee, с первичным ключом по полю BusinessEntityID. 
	 Временная таблица должна включать все поля таблицы dbo.Employee 
	 за исключением поля WithoutTax.*/
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
/*c) заполните временную таблицу данными из dbo.Employee. 
     Посчитайте сумму продаж (TotalDue) и сумму налогов (TaxAmt) для каждого сотрудника (EmployeeID) 
	 в таблице Purchasing.PurchaseOrderHeader и заполните этими значениями поля SumTotal и SumTaxAmt. 
	 Выберите только те записи, где SumTotal > 5 000 000. Подсчет суммы продаж 
	 и суммы налогов осуществите в Common Table Expression (CTE).*/

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
/*d) удалите из таблицы dbo.Employee строки, где MaritalStatus = ‘S’*/

DELETE FROM [dbo].[Employee]
WHERE [MaritalStatus] = 'S';

/*-------------------------------------------------------------------------------------------*/
/*e) напишите Merge выражение, использующее dbo.Employee как target, а временную таблицу 
     как source. Для связи target и source используйте BusinessEntityID. 
	 Обновите поля SumTotal и SumTaxAmt, если запись присутствует в source и target. 
	 Если строка присутствует во временной таблице, но не существует в target, 
	 добавьте строку в dbo.Employee. Если в dbo.Employee присутствует такая строка, 
	 которой не существует во временной таблице, удалите строку из dbo.Employee.*/

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
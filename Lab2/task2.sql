---¬ј–»јЌ“ 5---
USE [AdventureWorks2012];
GO

/*
a) 
	создайте таблицу dbo.Employee с такой же структурой как HumanResources.Employee, 
	кроме полей OrganizationLevel, SalariedFlag, CurrentFlag, а также кроме полей с типом hierarchyid, 
	uniqueidentifier, не включа€ индексы, ограничени€ и триггеры;
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
	использу€ инструкцию ALTER TABLE, 
    создайте дл€ таблицы dbo.Employee ограничение UNIQUE дл€ пол€ NationalIDNumber;
*/

ALTER TABLE [dbo].[Employee] 
	ADD CONSTRAINT [Unique] UNIQUE ([NationalIDNumber])

/*
c) 
	использу€ инструкцию ALTER TABLE, создайте дл€ таблицы dbo.Employee 
	ограничение дл€ пол€ VacationHours, 
	запрещающее заполнение этого пол€ значени€ми меньшими или равными 0;
*/	

ALTER TABLE [dbo].[Employee] 
	ADD CONSTRAINT [GreaterZero] CHECK ([VacationHours] > 0 )

/*
d) 
	использу€ инструкцию ALTER TABLE, создайте дл€ таблицы dbo.Employee 
	ограничение DEFAULT дл€ пол€ VacationHours, задайте значение по умолчанию 144;
*/

ALTER TABLE [dbo].[Employee] 
	ADD CONSTRAINT [DefaultVacationHours] DEFAULT 144 FOR [VacationHours];

/*
e) 
	заполните новую таблицу данными из HumanResources.Employee о сотрудниках на позиции СBuyerТ. 
	Ќе указывайте дл€ выборки поле VacationHours, чтобы оно заполнилось значени€ми по умолчанию;
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
	измените тип пол€ ModifiedDate на DATE 
	и разрешите добавление null значений дл€ него.
*/

ALTER TABLE [dbo].[Employee] 
	ALTER COLUMN [ModifiedDate] DATE NULL;








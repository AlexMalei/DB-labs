--¬¿–»¿Õ“ 5--
USE [AdventureWorks2012];
GO

SELECT [Name], [GroupName] FROM [HumanResources].[Department]
WHERE [GroupName] = 'Research and Development' ORDER BY [Name];

SELECT TOP 1 [SickLeaveHours] FROM [HumanResources].[Employee] 
ORDER BY [SickLeaveHours];

SELECT MIN([SickLeaveHours]) AS [SickLeaveHours]
FROM [HumanResources].[Employee] 


SELECT DISTINCT TOP 10  [JobTitle], SUBSTRING([JobTitle], 1, (CHARINDEX(' ', [JobTitle] + ' ') - 1)) AS [FirstWord]  
FROM [HumanResources].[Employee]
ORDER BY [JobTitle];  

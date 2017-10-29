--¬¿–»¿Õ“ 5--
USE AdventureWorks2012;
GO

SELECT [Employee].[BusinessEntityID], 
	   [JobTitle], 
	   [Name], 
	   [StartTime], 
	   [EndTime] 
FROM   [HumanResources].[Employee]
	   JOIN [HumanResources].[EmployeeDepartmentHistory] 
		 ON [EmployeeDepartmentHistory].[BusinessEntityID] = [Employee].[BusinessEntityID]
	   JOIN [HumanResources].[Shift]
		 ON [EmployeeDepartmentHistory].[ShiftID] = [Shift].[ShiftID]
WHERE  [HumanResources].[EmployeeDepartmentHistory].[EndDate] IS NULL;
  
/*------------------------------------------------------------------------------------------------------*/

SELECT [GroupName],
	   COUNT(*) AS [CountEmp]
FROM   [HumanResources].[Department]
	   JOIN [HumanResources].[EmployeeDepartmentHistory] 
	     ON [HumanResources].[Department].[DepartmentID] = [HumanResources].[EmployeeDepartmentHistory].[DepartmentID]
WHERE  [HumanResources].[EmployeeDepartmentHistory].[EndDate] IS NULL
GROUP BY [GroupName];



/*------------------------------------------------------------------------------------------------------*/

SELECT [Name],
	   [EmployeeDepartmentHistory].[BusinessEntityID],
	   [Rate],
	   MAX([Rate]) OVER (PARTITION BY [EmployeeDepartmentHistory].[BusinessEntityID]) AS [MaxRateEmployee],	
	   MAX([Rate]) OVER (PARTITION BY [Name] ) AS [MaxInDepartment],
	   DENSE_RANK() OVER (PARTITION BY [Name] ORDER BY [Rate]) AS [RateGroup]
FROM   [HumanResources].[EmployeeDepartmentHistory] 
	   JOIN [HumanResources].[Department]
	     ON [EmployeeDepartmentHistory].[DepartmentID] = [Department].[DepartmentID]
	   JOIN [HumanResources].[EmployeePayHistory]
	     ON [EmployeePayHistory].[BusinessEntityID] = [EmployeeDepartmentHistory].[BusinessEntityID]
WHERE  [HumanResources].[EmployeeDepartmentHistory].[EndDate] IS NULL
---MAX RATE FOR EMPLOYEE---

